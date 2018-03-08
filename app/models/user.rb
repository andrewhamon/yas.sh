class User < ApplicationRecord
  has_secure_password
  has_one :account, foreign_key: :owner_id
  has_and_belongs_to_many :accounts

  validates :email, presence: true, uniqueness: true

  before_validation :downcase_email

  has_many :sites, through: :accounts
  has_many :revisions, through: :sites, source: :revisions
  has_many :tokens

  def revoke_tokens!
    tokens.delete_all
  end

  def exchange_password_for_token(password)
    fail unless authenticate(password)
    tokens.create
  end

  def as_json(options)
    result = {
      email: email,
      created_at: created_at,
      updated_at: updated_at
    }
  end

  class << self
    def exchange_token_for_user(token)
      Token.find_by!(access_token: token).user
    end
  end

  private

  def downcase_email
    self.email = self.email&.downcase
  end
end
