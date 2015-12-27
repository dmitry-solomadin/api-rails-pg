class Post < ActiveRecord::Base
  belongs_to :author, class_name: User
  has_many :comments, as: :parent

  validates :body, :header, :author, presence: true
end
