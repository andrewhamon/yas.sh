class UpstreamFile < ApplicationRecord
  belongs_to :account
  has_many :revision_files
  has_many :revisions, through: :revision_files

  validates :md5, presence: true, uniqueness: { scope: :account_id }
  validates :size, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 100.megabytes }

  def upstream_path
    "#{md5}-#{account.id}"
  end

  def presigned_url
    bucket = Aws::S3::Resource.new.bucket(Rails.configuration.upstream_bucket)
    presigned_url = bucket.object(upstream_path).presigned_url(
      :put,
      acl: 'public-read',
      content_type: content_type,
      metadata: {
        account_id: account_id.to_s
      }
    )
  end
end
