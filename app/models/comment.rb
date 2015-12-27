class Comment < ActiveRecord::Base
  belongs_to :parent, polymorphic: true
  belongs_to :author, class_name: User
  has_many :comments, as: :parent

  validates :text, :author, :parent, presence: true
  validate :parent_id_not_changed

private

  def parent_id_not_changed
    if parent_id_changed? && self.persisted?
      errors.add(:parent_id, 'Change of parent_id not allowed!')
    end
  end
end
