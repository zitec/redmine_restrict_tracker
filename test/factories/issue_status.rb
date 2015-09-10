FactoryGirl.define do
  factory :issue_status do
    sequence(:name) {|count| "Status #{ count }" }
    is_closed false
  end
end
