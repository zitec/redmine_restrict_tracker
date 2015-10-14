require File.expand_path('../../test_helper', __FILE__)

class AdminControllerTest < ActionController::TestCase
  test 'GET #plugins' do
    login_as_admin
    get :plugins
    assert_response :success
    assert_select 'span.name', 'Restrict Tracker'
    assert_select 'td.configure > a', 'Configure'
  end
end
