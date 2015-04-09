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
          if (Setting.plugin_redmine_restrict_tracker[:root_nodes].split(',')
              .map(&:to_i).include?(tracker_id))
            true
          else
            errors.add :base, "#{tracker.name} can't be a root node, please assign a parent!"
            false
          end
        end

        def restrict_parent
          tracker_name = tracker.name
          setting_name = "parents_for_#{tracker_name.downcase.split(' ').join('_')}"
          possible_parent_trackers = Setting.plugin_redmine_restrict_tracker[setting_name]
            .split(',').map(&:to_i)
          parent_tracker_id = Issue.where(id: parent_issue_id).pluck(:tracker_id).first
          if (possible_parent_trackers.include?(parent_tracker_id))
            true
          else
            possible_parents = Tracker.where(id: possible_parent_trackers).pluck(:name).map(&:pluralize)
            if possible_parents.size == 0
              errors.add :base, "#{tracker_name.pluralize} can't be set as children!"
              return false
            elsif possible_parents.size > 1
              parents_string = possible_parents[0..-2].join(', ') << " and " << possible_parents[-1]
            else
              parents_string = possible_parents[0]
            end
            errors.add :base, "#{tracker_name.pluralize} can only be children of #{parents_string}!"
            false
          end
        end
      end
    end
  end
end

unless Issue.included_modules.include? RedmineRestrictTracker::Patches::IssuePatch
  Issue.send :include, RedmineRestrictTracker::Patches::IssuePatch
end
