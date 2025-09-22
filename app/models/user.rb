class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  has_many :user_projects, dependent: :destroy
  has_many :projects, through: :user_projects

  before_create :calculate_age# , :set_access_token

  private

  def calculate_age
    if birth_date.present?
      self.age = Date.current.year - birth_date.year
    end
  end
  # def set_access_token
  #   self.access_token = SecureRandom.uuid if access_token.blank?
  # end
end
