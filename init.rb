ActionDispatch::Callbacks.to_prepare do
  paths = '/lib/redmine_restrict_tracker/{patches/*_patch,hooks/*_hook}.rb'
  Dir.glob(File.dirname(__FILE__) + paths).each do |file|
    require_dependency file
  end
end

Redmine::Plugin.register :redmine_restrict_tracker do
  name 'Restrict Tracker'
  author 'Zitec'
  description 'Restricts the root and children trackers'
  version '0.0.2'
  url 'https://github.com/sdwolf/redmine_restrict_tracker'
  author_url 'http://www.zitec.com'

  settings partial: 'settings/plugin'
end
