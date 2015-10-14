require File.expand_path('../../test_helper', __FILE__)

class SettingsControllerTest < ActionController::TestCase
  test 'GET #plugin without initial settigns' do
    login_as_admin
    create_base_setup_without_settings
    data = { id: 'redmine_restrict_tracker' }
    get :plugin, data
    expect_plugin_setting_page_to_load
  end

  test 'GET #plugin with initial settigns disabled' do
    login_as_admin
    create_base_setup_with_disabled_settings
    data = { id: 'redmine_restrict_tracker' }
    get :plugin, data
    expect_plugin_setting_page_to_load
  end

  test 'GET #plugin with initial settigns enabled' do
    login_as_admin
    create_base_setup_with_enabled_settings
    data = { id: 'redmine_restrict_tracker' }
    get :plugin, data
    expect_plugin_setting_page_to_load
  end

  private

  def expect_plugin_setting_page_to_load
    assert_response :success
    assert_select 'h2', /Restrict Tracker/
  end
end
