FactoryGirl.define do
  factory :project do
    sequence(:name) {|count| "Project #{ count }" }
    sequence(:description) {|count| "Description #{ count }" }
    sequence(:homepage) {|count| "http://user#{ count }.zitec.ro/" }
    sequence(:identifier) {|count| "user_#{ count }" }
    is_public true
    created_on '2006-07-19 19:13:59 +02:00'
    updated_on '2006-07-19 22:53:01 +02:00'
  end
end
