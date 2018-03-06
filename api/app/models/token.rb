class Token < ActiveRecord::Base
  belongs_to :user
  before_validation :generate_access_token

  private

  def generate_access_token
    self.access_token ||= SecureRandom.uuid
  end
end
