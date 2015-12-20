FactoryGirl.define do
  factory :comment do
    author factory: :user
    text 'text'
  end
end
