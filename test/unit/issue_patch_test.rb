require File.expand_path '../../test_helper', __FILE__

class IssuePatchTest < ActiveSupport::TestCase
  def tracker_name(tracker)
    'parents_for_' << tracker.name.downcase.split(' ').join('_')
  end

  setup do
    @assignee = create :user
    @status = create :issue_status
    @priority = create :issue_priority
    @project = create :project
    @root_tracker_1 = create :tracker, default_status_id: @status.id
    @root_tracker_2 = create :tracker, default_status_id: @status.id
    @first_child_tracker = create :tracker, default_status_id: @status.id
    @second_child_tracker = create :tracker, default_status_id: @status.id
    @always_child_tracker = create :tracker, default_status_id: @status.id
    @project.trackers << @root_tracker_1
    @project.save!
    hash = ActiveSupport::HashWithIndifferentAccess.new(
      root_nodes: [@root_tracker_1.id, @root_tracker_2.id].join(','),
      tracker_name(@first_child_tracker) => @root_tracker_1.id.to_s,
      tracker_name(@second_child_tracker) => @first_child_tracker.id.to_s,
      tracker_name(@always_child_tracker) => ''
    )
    Setting.plugin_redmine_restrict_tracker = hash
  end

  test 'Issue is patched with RedmineRestrictTracker::Patches::IssuePatch' do
    patch = RedmineRestrictTracker::Patches::IssuePatch
    assert Issue.included_modules.include? patch
    assert Issue.instance_methods.include? :restrict_tracker_type
    assert Issue.instance_methods.include? :restrict_root
    assert Issue.instance_methods.include? :restrict_parent
  end

  test 'creating a root issue' do
    issue = build(:issue)
    issue.tracker = @root_tracker_1
    issue.priority = @priority
    issue.project = @project
    issue.assigned_to = @assignee
    issue.save!
    assert issue.valid?
  end
end
