module SettingsSupport
  private

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

  def create_base_setup
    @author = create :user
    @priority = create :issue_priority
    @status = create :issue_status
    @project = create :project
    @root_tracker_1 = create :tracker, default_status_id: @status.id
    @root_tracker_2 = create :tracker, default_status_id: @status.id
    @first_child_tracker = create :tracker, default_status_id: @status.id
    @second_child_tracker = create :tracker, default_status_id: @status.id
    @always_root_tracker = create :tracker, default_status_id: @status.id
    @project.trackers << [@root_tracker_1, @root_tracker_2,
    @first_child_tracker, @second_child_tracker, @always_root_tracker]
    @project.save!
  end

  def create_base_setup_with_settings
    create_base_setup
    hash = ActiveSupport::HashWithIndifferentAccess.new(
      root_nodes: [@root_tracker_1.id, @root_tracker_2.id].join(','),
      tracker_name(@first_child_tracker) => @root_tracker_1.id.to_s,
      tracker_name(@second_child_tracker) => [@first_child_tracker.id,
        @root_tracker_2.id].join(','),
      tracker_name(@always_root_tracker) => ''
    )
    Setting.plugin_redmine_restrict_tracker = hash
  end
end
