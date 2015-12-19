FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "email-#{n}@example.com" }
    sequence(:first_name) { |n| "John-#{n}" }
    sequence(:last_name) { |n| "Doe-#{n}" }
    password '12345678'
  end
end
