class Revision < ApplicationRecord
  belongs_to :site
  has_many :revision_files
  has_many :files, through: :revision_files

  validates :number, presence: true, uniqueness: {scope: :site_id}

  def redis_key
    "#{site.domain}-v#{number}"
  end

  def as_json(options)
    {
      number: number,
      site: site.domain,
      created_at: created_at,
      updated_at: updated_at
    }
  end
end
