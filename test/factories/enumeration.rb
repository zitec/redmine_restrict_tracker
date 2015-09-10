FactoryGirl.define do
  factory :issue_priority do
    sequence(:name) {|count| "Priority #{ count }" }
    type 'IssuePriority'
    active true
    sequence(:position) {|count| count }
    sequence(:position_name) {|count| "Position #{ count }" }
  end
end
