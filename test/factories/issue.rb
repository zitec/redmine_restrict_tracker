FactoryGirl.define do
  factory :issue do
    created_on 3.days.ago.to_s(:db)
    project_id 1
    updated_on 1.day.ago.to_s(:db)
    priority_id 4
    subject 'Cannot print recipes'
    category_id 1
    description 'Unable to print recipes'
    tracker_id 1
    author_id 2
    status_id 1
    start_date 1.day.ago.to_date.to_s(:db)
    due_date 10.day.from_now.to_date.to_s(:db)
  end
end
