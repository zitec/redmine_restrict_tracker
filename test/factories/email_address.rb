FactoryGirl.define do
  factory :email_address do
    sequence(:address) {|count| "email#{ count }@example.com" }
    is_default true
    created_on '2006-07-19 19:34:07 +02:00'
    updated_on '2006-07-19 19:34:07 +02:00'
  end
end
