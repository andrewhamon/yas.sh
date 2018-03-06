class Site < ApplicationRecord
  belongs_to :account
  belongs_to :current_revision, class_name: 'Revision', optional: true
  has_many :revisions

  validates :domain, uniqueness: true, presence: true

  before_validation :downcase_domain
  after_commit :persist_to_redis

  def new_revision
    next_revision_number = increment_and_return_revision_count
    revisions.new(number: next_revision_number)
  end

  def as_json(options)
    result = {
      domain: domain,
      account: account.as_json(options),
      current_revision: current_revision.as_json(options),
      created_at: created_at,
      updated_at: updated_at,
      domain_prevalidated: domain_recently_prevalidated?
    }
  end

  def enqueue_domain_prevalidation!
    ActiveRecord::Base.transaction do
      prepare_domain_prevalidation!
      PrevalidateDomainJob.enqueue(id)
    end
  end

  def domain_recently_prevalidated?
    return false unless domain_prevalidated_at
    domain_prevalidated_at > Rails.configuration.domain_prevalidation_period.ago
  end

  def prepare_domain_prevalidation!
    self.domain_prevalidation_token = SecureRandom.uuid
    self.domain_prevalidation_content = SecureRandom.uuid
    save!
  end

  def perform_domain_prevalidation!
    uri = URI("http://#{domain}/.well-known/yassh-challenge/#{domain_prevalidation_token}")
    http = Net::HTTP.new(uri.host, uri.port)
    req =  Net::HTTP::Get.new(uri)
    res = http.request(req)
    if res.body.strip == domain_prevalidation_content
      self.domain_prevalidated_at = Time.now
      save!
    else
      raise "Domain prevalidation content mismatch"
    end
  end

  private

  def increment_and_return_revision_count
    quoted_id = self.class.connection.quote(id)

    sql = "UPDATE sites SET revision_count = revision_count + 1 WHERE sites.id = #{quoted_id} RETURNING revision_count"
    self.class.connection.select_value(sql).to_i
  end

  def downcase_domain
    self.domain = self.domain&.downcase
  end

  def persist_to_redis
    $redis.with do |conn|
      conn.hset(domain, "revision_key", current_revision&.redis_key)
    end
  end
end
