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
    Setting.plugin_redmine_restrict_tracker = nil
  end

  def create_base_setup_with_settings(active: true)
    create_base_setup
    hash = {
      'root_nodes' => [@root_tracker_1.id, @root_tracker_2.id].join(','),
      'restrict_root' => active ? '1' : nil,
      tracker_name(@first_child_tracker) => @root_tracker_1.id.to_s,
      restrict_name(@first_child_tracker) => active ? '1' : nil,
      tracker_name(@second_child_tracker) => [@first_child_tracker.id,
        @root_tracker_2.id].join(','),
      restrict_name(@second_child_tracker) => active ? '1' : nil,
      tracker_name(@no_parent_tracker) => '',
      restrict_name(@no_parent_tracker) => active ? '1' : nil
    }
    Setting.plugin_redmine_restrict_tracker = hash
  end

  def create_base_setup_with_enabled_settings
    create_base_setup_with_settings active: true
  end

  def create_base_setup_with_disabled_settings
    create_base_setup_with_settings active: false
  end

  def expect_root_issue_to_be_created
    issue = build_issue_with @root_tracker_1
    issue.save
    expect(issue).to be_valid
  end

  def expect_child_issue_to_be_created
    parent = build_issue_with @root_tracker_1
    parent.save!
    child = build_issue_with @first_child_tracker, parent
    child.save
    expect(child).to be_valid
  end

  def expect_child_of_child_to_be_created
    parent = build_issue_with @root_tracker_1
    parent.save!
    first_child = build_issue_with @first_child_tracker, parent
    first_child.save!
    second_child = build_issue_with @second_child_tracker, first_child
    second_child.save
    expect(second_child).to be_valid
  end
end
