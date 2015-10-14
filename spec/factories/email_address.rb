FactoryGirl.define do
  factory :email_address do
    sequence(:address) {|count| "sample-address-#{ count }@example.com" }
    created_on 1.day.ago.to_s(:db)
    updated_on 1.day.ago.to_s(:db)
    is_default true
  end
end
