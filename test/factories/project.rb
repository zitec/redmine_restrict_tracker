FactoryGirl.define do
  factory :project do
    sequence(:name) {|count| "Sample Name #{ count }" }
    sequence(:description) {|count| "Sample Description #{ count }" }
    sequence(:homepage) {|count| "http://sample-user-#{ count }.example.com" }
    sequence(:identifier) {|count| "sample-user-#{ count }" }
    created_on 1.day.ago.to_s(:db)
    updated_on 1.day.ago.to_s(:db)
    is_public true
  end
end
