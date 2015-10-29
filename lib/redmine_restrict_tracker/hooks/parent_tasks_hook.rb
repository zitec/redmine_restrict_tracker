class ParentTasksHook < Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context)
    controller = context[:controller]
    controller.render_to_string partial: 'redmine_restrict_tracker/header_assets'
  end
end
