require 'redmine'

# Patches to the Redmine core.
ActionDispatch::Callbacks.to_prepare do
  Dir[File.dirname(__FILE__) + '/lib/redmine_restrict_tracker/patches/*_patch.rb'].each do |file|
    require_dependency file
  end
  Dir[File.dirname(__FILE__) + '/lib/redmine_restrict_tracker/hooks/*_hook.rb'].each do |file|
    require_dependency file
  end
end

Redmine::Plugin.register :redmine_restrict_tracker do
  name 'Redmine Restrict Tracker plugin'
  author 'Zitec'
  description 'Restricts the root and children trackers'
  version '0.0.1'
  url 'https://github.com/sdwolf/redmine_restrict_tracker'
  author_url 'http://www.zitec.com'
end
