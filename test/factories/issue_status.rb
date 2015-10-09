FactoryGirl.define do
  factory :issue_status do
    sequence(:name) {|count| "Sample Name #{ count }" }
    is_closed false
  end
end
