class Post < ActiveRecord::Base
  belongs_to :author, class_name: User

  validates :body, :header, :author, presence: true
end
