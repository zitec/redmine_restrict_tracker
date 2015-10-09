FactoryGirl.define do
  factory :issue_priority do
    sequence(:name) {|count| "Sample Name #{ count }" }
    sequence(:position) {|count| count }
    sequence(:position_name) {|count| "Sample Position Name #{ count }" }
    type 'IssuePriority'
    active true
  end
end
