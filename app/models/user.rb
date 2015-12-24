class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable

  include DeviseTokenAuth::Concerns::User

  has_many :posts, foreign_key: :author_id, dependent: :destroy
  has_many :comments, foreign_key: :author_id, dependent: :destroy

  ROLES = ['ADMIN', 'USER']

  validates :password, :role, presence: true, on: :create
  validates_confirmation_of :password, on: :create
  validates_inclusion_of :role, in: ROLES

  before_validation :set_provider, :set_uid

  def admin?
    role == 'ADMIN'
  end

private

  def set_provider
    self[:provider] = 'email' if self[:provider].blank?
  end

  def set_uid
    self[:uid] = self[:email] if self[:uid].blank? && self[:email].present?
  end
end
