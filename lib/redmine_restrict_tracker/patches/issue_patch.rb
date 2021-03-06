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
        def can_have_children?
          @settings = Setting.plugin_redmine_restrict_tracker
          return true if !@settings || @settings.blank?

          @available_trackers = self.allowed_target_trackers.pluck(:name).to_a.map(&:downcase)
          @settings.each do |key, value|
            next if ['root_nodes', 'restrict_root'].include?(key)
            return true if key =~ /^restrict_.+$/ && value != '1'
            if key =~ /^parents_for_.+$/
              id_list = value.split(',').map(&:to_i)
              return true if id_list.include?(tracker_id)
            end
          end
          return false
        end

        def available_children
          @settings = Setting.plugin_redmine_restrict_tracker unless @settings
          return [] if !@settings || @settings.blank?

          @available_trackers = self.allowed_target_trackers.pluck(:name).to_a.map(&:downcase) unless @available_trackers
          @settings.reduce([]) do |total, element|
            key = element[0]
            value = element[1]
            if ['root_nodes', 'restrict_root'].include?(key)
              total
            else
              if key =~ /^restrict_.+$/ && value != '1'
                total
              else
                if key =~ /^parents_for_.+$/
                  id_list = value.split(',').map(&:to_i)
                  if id_list.include?(tracker_id)
                    tracker_name = key[12..-1].split('_').map(&:capitalize).join(' ')
                    total << tracker_name if @available_trackers.include?(tracker_name.downcase)
                  end
                  total
                else
                  total
                end
              end
            end

          end
        end

        def restrict_tracker
          settings = Setting.plugin_redmine_restrict_tracker
          return true if !settings || settings.blank?
          if parent_issue_id
            can_create_child_with? settings
          else
            can_create_root_with? settings
          end
        end

        def can_create_root_with?(settings)
          setting_active = settings['restrict_root']
          return true if !setting_active
          node_setting = settings['root_nodes']
          root_node_ids = node_setting.split(',').map(&:to_i)
          if root_node_ids.include?(tracker_id)
            true
          else
            errors.add :base, "#{ tracker.name } can not be a root node, please assign a parent!"
            false
          end
        end

        def can_create_child_with?(settings)
          tracker_name = tracker.name
          active_name = "restrict_#{ tracker_name.downcase.split(' ').join('_') }"
          setting_active = settings[active_name]
          return true if !setting_active
          setting_name = "parents_for_#{ tracker_name.downcase.split(' ').join('_') }"
          node_setting = settings[setting_name]
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
