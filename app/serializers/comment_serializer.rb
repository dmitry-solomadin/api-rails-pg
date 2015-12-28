class CommentSerializer < ActiveModel::Serializer
  belongs_to :author, include: false
  has_many :comments, include: false

  attributes :id, :text, :created_at, :updated_at
end
