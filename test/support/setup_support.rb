module SetupSupport
  private

  def tracker_name(tracker)
    'parents_for_' << tracker.name.downcase.split(' ').join('_')
  end

  def restrict_name(tracker)
    'restrict_' << tracker.name.downcase.split(' ').join('_')
  end

  def build_issue_with(tracker, parent = nil)
    build :issue, tracker_id: tracker.id, priority_id: @priority.id,
      project_id: @project.id, author_id: @author.id,
      parent_id: parent ? parent.id : nil
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
    @no_parent_tracker = create :tracker, default_status_id: @status.id
    @project.trackers << [@root_tracker_1, @root_tracker_2,
      @first_child_tracker, @second_child_tracker, @no_parent_tracker]
    @project.save!
  end

  def create_base_setup_without_settings
    create_base_setup
    Setting.plugin_redmine_restrict_tracker = ActiveSupport::HashWithIndifferentAccess.new
  end

  def create_base_setup_with_settings(active: '1')
    create_base_setup
    hash = ActiveSupport::HashWithIndifferentAccess.new(
      root_nodes: [@root_tracker_1.id, @root_tracker_2.id].join(','),
      restrict_root: active,
      tracker_name(@first_child_tracker) => @root_tracker_1.id.to_s,
      restrict_name(@first_child_tracker) => active,
      tracker_name(@second_child_tracker) => [@first_child_tracker.id,
        @root_tracker_2.id].join(','),
      restrict_name(@second_child_tracker) => active,
      tracker_name(@no_parent_tracker) => '',
      restrict_name(@no_parent_tracker) => active
    )
    Setting.plugin_redmine_restrict_tracker = hash
  end

  def create_base_setup_with_enabled_settings
    create_base_setup_with_settings active: '1'
  end

  def create_base_setup_with_disabled_settings
    create_base_setup_with_settings active: '0'
  end
end
