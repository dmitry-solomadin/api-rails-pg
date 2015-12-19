class Post < ActiveRecord::Base
  belongs_to :author, class: User
end
