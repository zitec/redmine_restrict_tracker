ActionDispatch::Callbacks.to_prepare do
  paths = '/lib/redmine_restrict_tracker/{patches/*_patch,hooks/*_hook}.rb'
  Dir.glob(File.dirname(__FILE__) << paths).each do |file|
    require_dependency file
  end
end

Redmine::Plugin.register :redmine_restrict_tracker do
  name 'Restrict Tracker'
  author 'Zitec'
  description 'Restricts the root and child trackers'
  version '1.0.0'
  url 'https://github.com/ZitecCOM/redmine_restrict_tracker'
  author_url 'http://www.zitec.com'
  requires_redmine version_or_higher: '3.1.1'
  settings partial: 'redmine_restrict_tracker/plugin_settings'
end

Rails.application.config.after_initialize do
  test_dependencies = { redmine_testing_gems: '1.1.1' }
  restrict_tracker = Redmine::Plugin.find :redmine_restrict_tracker
  check_dependencies = proc do |plugin, version|
    begin
      restrict_tracker.requires_redmine_plugin plugin, version
    rescue Redmine::PluginNotFound => error
      raise Redmine::PluginNotFound,
        "Restrict Tracker depends on plugin: " \
          "#{ plugin } version: #{ version }"
    end
  end
  test_dependencies.each &check_dependencies if Rails.env.test?
end
