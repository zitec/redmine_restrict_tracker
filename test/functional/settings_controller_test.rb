require File.expand_path '../../test_helper', __FILE__

class SettingsControllerTest < ActionController::TestCase
  setup do
    login_as_admin
    create_base_settings
  end

  test 'GET plugin settings' do
    get :plugin, id: 'redmine_restrict_tracker'
    assert_response :success
    assert_select 'h2', /Redmine Restrict Tracker plugin/
  end
end
