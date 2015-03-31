require_dependency 'issue'

module RedmineRestrictTracker
  module Patches
    module IssuePatch
      def self.included(base)
        base.send :include, InstanceMethods
        base.class_eval do
        end
      end

      module InstanceMethods
      end
    end
  end
end

unless Issue.included_modules.include? RedmineRestrictTracker::Patches::IssuePatch
  Issue.send :include, RedmineRestrictTracker::Patches::IssuePatch
end
