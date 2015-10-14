FactoryGirl.define do
  factory :project do
    sequence(:description) {|count| "Sample Description #{ count }" }
    sequence :homepage do |count|
      "http://sample-homepage-#{ count }.example.com/"
    end
    sequence(:identifier) {|count| "sample-user-#{ count }" }
    sequence(:name) {|count| "Sample Name #{ count }" }
    created_on 1.day.ago.to_s(:db)
    updated_on 1.day.ago.to_s(:db)
    is_public true
  end
end
