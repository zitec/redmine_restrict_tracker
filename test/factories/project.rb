FactoryGirl.define do
  factory :project do
    sequence(:name) {|count| "Sample Name #{ count }" }
    sequence(:description) {|count| "Sample Description #{ count }" }
    sequence(:homepage) {|count| "http://sample-homepage-#{ count }.example.com/" }
    sequence(:identifier) {|count| "sample-user-#{ count }" }
    is_public true
    created_on 1.day.ago.to_s(:db)
    updated_on 1.day.ago.to_s(:db)
  end
end
