FactoryGirl.define do
  factory :issue_priority do
    sequence(:name) {|count| "Sample Name #{ count }" }
    type 'IssuePriority'
    active true
    sequence(:position) {|count| count }
    sequence(:position_name) {|count| "Sample Position Name #{ count }" }
  end
end
