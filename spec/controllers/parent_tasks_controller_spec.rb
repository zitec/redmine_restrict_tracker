require 'spec_helper'

describe ParentTasksController, type: :controller do
  include LoginSupport
  include SetupSupport
  render_views

  context 'GET #parents as JSON' do
    context 'first child' do
      before :example do
        login_as_admin
        create_base_setup_with_settings active: true
        @parent = build_issue_with @root_tracker_1
        @parent.save
        @child = build_issue_with @first_child_tracker, @parent
        @child.save
      end

      it 'responds with the parent tracker' do
        params = { issue_id: @child.id, tracker_id: @first_child_tracker,
          project_id: @project.id, term: '', scope: 'tree' }
        get :parents, params
        expect(response).to have_http_status(:ok)
        expect(response.body).to match(/#{@parent.subject}/)
      end
    end

    context 'second child' do
      before :example do
        login_as_admin
        create_base_setup_with_settings active: true
        @root_1 = build_issue_with @root_tracker_1
        @root_1.save
        @root_2 = build_issue_with @root_tracker_2
        @root_2.save
        @first_child = build_issue_with @first_child_tracker, @root_1
        @first_child.save
        @second_child = build_issue_with @second_child_tracker, @first_child
        @second_child.save
      end

      it 'responds with both parent tracker' do
        params = { issue_id: @second_child.id, term: '', scope: 'tree',
          tracker_id: @second_child_tracker, project_id: @project.id }
        get :parents, params
        expect(response).to have_http_status(:ok)
        expect(response.body).to match(/#{@first_child.subject}/)
        expect(response.body).to match(/#{@root_2.subject}/)
      end
    end
  end
end
