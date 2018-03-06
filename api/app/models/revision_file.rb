class RevisionFile < ApplicationRecord
  belongs_to :revision
  belongs_to :upstream_file

  validates :site_path, uniqueness: {scope: :revision_id}

  before_validation :ensure_leading_slash
  after_commit :persist_to_redis

  private

  def persist_to_redis
    $redis.with do |conn|
      conn.hset(revision.redis_key, site_path, upstream_file.upstream_path)
    end
  end

  def ensure_leading_slash
    self.site_path = File.join("/", site_path)
  end
end
