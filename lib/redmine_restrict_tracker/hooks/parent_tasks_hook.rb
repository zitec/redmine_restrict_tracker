class ParentTasksHook < Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context)
    controller = context[:controller]
    if controller.is_a? IssuesController
      controller.render_to_string partial: 'redmine_restrict_tracker/header_assets'
    else
      ''
    end
  end
end
