class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable

  include DeviseTokenAuth::Concerns::User

  has_many :posts, foreign_key: :author_id, dependent: :destroy
  has_many :comments, foreign_key: :author_id, dependent: :destroy

  validates :password, presence: true, on: :create
  validates_confirmation_of :password, on: :create

  before_validation :set_provider, :set_uid

private

  def set_provider
    self[:provider] = 'email' if self[:provider].blank?
  end

  def set_uid
    self[:uid] = self[:email] if self[:uid].blank? && self[:email].present?
  end
end
