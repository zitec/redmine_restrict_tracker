require File.expand_path '../../test_helper', __FILE__

class IssuePatchTest < ActiveSupport::TestCase
  def tracker_name(tracker)
    'parents_for_' << tracker.name.downcase.split(' ').join('_')
  end

  def build_issue_with(tracker, parent = nil)
    issue = build(:issue)
    issue.tracker = tracker
    issue.priority = @priority
    issue.project = @project
    issue.author = @author
    issue.parent = parent
    issue
  end

  setup do
    @author = create :user
    @status = create :issue_status
    @priority = create :issue_priority
    @project = create :project
    @root_tracker_1 = create :tracker, default_status_id: @status.id
    @root_tracker_2 = create :tracker, default_status_id: @status.id
    @first_child_tracker = create :tracker, default_status_id: @status.id
    @second_child_tracker = create :tracker, default_status_id: @status.id
    @always_root_tracker = create :tracker, default_status_id: @status.id
    @project.trackers << [@root_tracker_1, @root_tracker_2,
      @first_child_tracker, @second_child_tracker, @always_root_tracker]
    @project.save!
    hash = ActiveSupport::HashWithIndifferentAccess.new(
      root_nodes: [@root_tracker_1.id, @root_tracker_2.id].join(','),
      tracker_name(@first_child_tracker) => @root_tracker_1.id.to_s,
      tracker_name(@second_child_tracker) => @first_child_tracker.id.to_s,
      tracker_name(@always_root_tracker) => ''
    )
    Setting.plugin_redmine_restrict_tracker = hash
  end

  test 'Issue is patched with RedmineRestrictTracker::Patches::IssuePatch' do
    patch = RedmineRestrictTracker::Patches::IssuePatch
    assert_includes Issue.included_modules, patch
    assert_includes Issue.instance_methods, :restrict_tracker
    assert_includes Issue.instance_methods, :restrict_root
    assert_includes Issue.instance_methods, :restrict_parent
  end

  test 'creating a root issue' do
    issue = build_issue_with @root_tracker_1
    issue.save
    assert issue.valid?
  end

  test 'creating the clild of a root issue' do
    parent = build_issue_with @root_tracker_1
    parent.save!
    child = build_issue_with @first_child_tracker, parent
    child.save
    assert child.valid?
  end

  test 'creating the clild of a child issue' do
    parent = build_issue_with @root_tracker_1
    parent.save!
    first_child = build_issue_with @first_child_tracker, parent
    first_child.save!
    second_child = build_issue_with @second_child_tracker, first_child
    second_child.save
    assert second_child.valid?
  end

  test 'not creating a child issue without a parent' do
    issue = build_issue_with @first_child_tracker
    issue.save
    errors = issue.errors.messages
    assert_not_empty errors
    assert_equal 1, errors.size
    assert_not_nil errors[:base]
    assert_equal ["#{ @first_child_tracker.name } can not be a root node, "\
      "please assign a parent!"], errors[:base]
  end

  test 'not creating an always root issue with a parent' do
    parent = build_issue_with @root_tracker_1
    parent.save!
    always_root = build_issue_with @always_root_tracker, parent
    always_root.save
    errors = always_root.errors.messages
    assert_not_empty errors
    assert_equal 1, errors.size
    assert_not_nil errors[:base]
    assert_equal ["#{ @always_root_tracker.name.pluralize } can not be set "\
      "as children!"], errors[:base]
  end

  test 'not creating child with the wrong tracker' do
    parent = build_issue_with @root_tracker_2
    parent.save!
    wrong_child = build_issue_with @first_child_tracker, parent
    wrong_child.save
    errors = wrong_child.errors.messages
    assert_not_empty errors
    assert_equal 1, errors.size
    assert_not_nil errors[:base]
    assert_equal ["#{ @first_child_tracker.name.pluralize } can only be "\
      "children of #{ @root_tracker_1.name.pluralize }!"], errors[:base]
  end
end
