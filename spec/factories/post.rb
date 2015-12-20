FactoryGirl.define do
  factory :post do
    author factory: :user
    body 'body'
    header 'header'
  end
end
