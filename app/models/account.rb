class Account < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_and_belongs_to_many :users
  has_many :sites
  has_many :upstream_files

  def collaborators
    users
  end

  def as_json(options)
    {
      owner: owner.email,
      created_at: created_at,
      updated_at: updated_at
    }
  end
end
