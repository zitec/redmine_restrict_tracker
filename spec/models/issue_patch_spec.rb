require 'spec_helper'

describe Issue, type: :model do
  include SetupSupport

  it 'is patched with RedmineRestrictTracker::Patches::IssuePatch' do
    patch = RedmineRestrictTracker::Patches::IssuePatch
    expect(Issue.included_modules).to include(patch)
  end

  context 'without plugins settings defined' do
    before :example do
      create_base_setup_without_settings
    end

    it 'creates a root issue' do
      expect_root_issue_to_be_created
    end

    it 'creates the clild of a root issue' do
      expect_child_issue_to_be_created
    end

    it 'creates the clild of a child issue' do
      expect_child_of_child_to_be_created
    end
  end

  context 'with plugin settings defined and disabled' do
    before :example do
      create_base_setup_with_disabled_settings
    end

    it 'creates a root tracker as root' do
      expect_root_issue_to_be_created
    end

    it 'creates a child tracker as root' do
      issue = build_issue_with @first_child_tracker
      issue.save
      expect(issue).to be_valid
    end

    it 'creates a root tracker as child' do
      parent = build_issue_with @first_child_tracker
      parent.save!
      child = build_issue_with @root_tracker_1, parent
      child.save
      expect(child).to be_valid
    end

    it 'creates a child tracker as child' do
      expect_child_of_child_to_be_created
    end
  end

  context 'with plugin settings defined and enabled' do
    before :example do
      create_base_setup_with_enabled_settings
    end

    it 'creates a root issue' do
      expect_root_issue_to_be_created
    end

    it 'creates the clild of a root issue' do
      expect_child_issue_to_be_created
    end

    it 'creates the clild of a child issue' do
      expect_child_of_child_to_be_created
    end

    it 'does not create a child issue without a parent' do
      issue = build_issue_with @first_child_tracker
      issue.save
      errors = issue.errors.messages
      expect(errors).not_to be_empty
      expect(errors.size).to eq(1)
      expect(errors[:base]).not_to be_nil
      expect(errors[:base]).to eq(["#{ @first_child_tracker.name } can not be" \
        " a root node, please assign a parent!"])
    end

    it 'does not create a non parent issue with a parent' do
      parent = build_issue_with @root_tracker_1
      parent.save!
      non_parent = build_issue_with @no_parent_tracker, parent
      non_parent.save
      errors = non_parent.errors.messages
      expect(errors).not_to be_empty
      expect(errors.size).to eq(1)
      expect(errors[:base]).not_to be_nil
      expect(errors[:base]).to eq(["#{ @no_parent_tracker.name.pluralize }" \
        " can not be set as children!"])
    end

    it 'does not create child with wrong tracker and one possible parent' do
      parent = build_issue_with @root_tracker_2
      parent.save!
      wrong_child = build_issue_with @first_child_tracker, parent
      wrong_child.save
      errors = wrong_child.errors.messages
      expect(errors).not_to be_empty
      expect(errors.size).to eq(1)
      expect(errors[:base]).not_to be_nil
      expect(errors[:base]).to eq(["#{ @first_child_tracker.name.pluralize }" \
        " can only be children of #{ @root_tracker_1.name.pluralize }!"])
    end

    it 'not creating child with the wrong tracker and many possible parents' do
      parent = build_issue_with @root_tracker_1
      parent.save!
      wrong_child = build_issue_with @second_child_tracker, parent
      wrong_child.save
      errors = wrong_child.errors.messages
      expect(errors).not_to be_empty
      expect(errors.size).to eq(1)
      expect(errors[:base]).not_to be_nil
      expect(errors[:base]).to eq(["#{ @second_child_tracker.name.pluralize }" \
        " can only be children of #{ @root_tracker_2.name.pluralize } and " \
        "#{ @first_child_tracker.name.pluralize }!"])

    end
  end
end
