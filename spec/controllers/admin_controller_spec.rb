require 'spec_helper'

describe AdminController, type: :controller do
  include LoginSupport
  render_views

  context 'GET #plugins as admin' do
    before :example do
      login_as_admin
      get :plugins
    end

    it 'responds with the plugins page' do
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:plugins)
    end
  end
end
