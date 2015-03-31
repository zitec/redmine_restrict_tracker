require_dependency 'issue'

module RedmineRestrictTracker
  module Patches
    module IssuePatch
      def self.included(base)
        base.send :include, InstanceMethods
        base.class_eval do
          before_save :restrict_tracker_type
        end
      end

      module InstanceMethods
        def restrict_tracker_type
          parent_issue_id ? restrict_parent : restrict_root
        end

        def restrict_root
          if [2,5,6,8,9].include? tracker_id
            true
          else
            errors.add :base, "#{tracker.name} can't be a root node, please assign a parent."
            false
          end
        end

        def restrict_parent
          case tracker_id
          when 1
            restrict_for [2], 'Bugs can only be children for Features.'
          when 2
            restrict_for [5,6], 'Features can only be children for Epics and Releases.'
          when 3
            restrict_for [2], 'Supports can only be children for Features.'
          when 4
            restrict_for [2], 'Task can only be children for Features.'
          when 5
            restrict_for [5], 'Epics can only be children for Epics.'
          when 6
            restrict_for [], 'Releases can only be root nodes.'
          when 7
            restrict_for [2], 'QA Tasks can only be children for Features.'
          when 8
            restrict_for [2,5], 'Enhancements can only be children for Features and Epics.'
          when 9
            restrict_for [2], 'Alerts can only be children for Features.'
          else
            true
          end
        end

        def restrict_for(tracker_ids, error_message)
          restriction = tracker_ids.include? Issue.where(id: parent_issue_id).select(:tracker_id).first.tracker_id
          errors.add(:base, error_message) unless restriction
          restriction
        end
      end
    end
  end
end

unless Issue.included_modules.include? RedmineRestrictTracker::Patches::IssuePatch
  Issue.send :include, RedmineRestrictTracker::Patches::IssuePatch
end
