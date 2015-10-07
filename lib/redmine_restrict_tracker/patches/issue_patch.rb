module RedmineRestrictTracker
  module Patches
    module IssuePatch
      def self.included(base)
        base.send :include, InstanceMethods
        base.class_eval do
          before_save :restrict_tracker
        end
      end

      module InstanceMethods
        def restrict_tracker
          parent_issue_id ? can_create_child? : can_create_root?
        end

        def can_create_root?
          setting_active = Setting.plugin_redmine_restrict_tracker[:restrict_root]
          return true if !setting_active || setting_active == '0'
          node_setting = Setting.plugin_redmine_restrict_tracker[:root_nodes]
          root_node_ids = node_setting.split(',').map(&:to_i)
          if root_node_ids.include?(tracker_id)
            true
          else
            errors.add :base, "#{ tracker.name } can not be a root node, please assign a parent!"
            false
          end
        end

        def can_create_child?
          tracker_name = tracker.name
          active_name = "restrict_#{ tracker_name.downcase.split(' ').join('_') }"
          setting_active = Setting.plugin_redmine_restrict_tracker[active_name]
          return true if !setting_active || setting_active == '0'
          setting_name = "parents_for_#{ tracker_name.downcase.split(' ').join('_') }"
          node_setting = Setting.plugin_redmine_restrict_tracker[setting_name]
          possible_parent_trackers = node_setting.split(',').map(&:to_i)
          parent_tracker_id = Issue.where(id: parent_issue_id).pluck(:tracker_id).first
          if (possible_parent_trackers.include?(parent_tracker_id))
            true
          else
            possible_parents = Tracker.where(id: possible_parent_trackers).pluck(:name).map(&:pluralize)
            if possible_parents.size == 0
              errors.add :base, "#{ tracker_name.pluralize } can not be set as children!"
              return false
            elsif possible_parents.size > 1
              parents_string = possible_parents[0..-2].join(', ') << " and " << possible_parents[-1]
            else
              parents_string = possible_parents[0]
            end
            errors.add :base, "#{ tracker_name.pluralize } can only be children of #{ parents_string }!"
            false
          end
        end
      end
    end
  end
end

base = Issue
patch = RedmineRestrictTracker::Patches::IssuePatch
base.send :include, patch unless base.included_modules.include? patch
