FactoryGirl.define do
  factory :tracker do
    sequence(:name) {|count| "Tracker #{ count }" }
    is_in_chlog true
  end
end
