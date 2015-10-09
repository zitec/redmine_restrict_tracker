FactoryGirl.define do
  factory :tracker do
    sequence(:name) {|count| "Sample Name #{ count }" }
    is_in_chlog true
  end
end
