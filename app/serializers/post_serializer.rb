class PostSerializer < ActiveModel::Serializer
  belongs_to :author, include: false
  has_many :comments, include: false

  attributes :id, :body, :header, :created_at, :updated_at
end
