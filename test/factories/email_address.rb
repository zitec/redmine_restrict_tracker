FactoryGirl.define do
  factory :email_address do
    sequence(:address) {|count| "sample-email-#{ count }@example.com" }
    is_default true
    created_on 1.day.ago.to_s(:db)
    updated_on 1.day.ago.to_s(:db)
  end
end
