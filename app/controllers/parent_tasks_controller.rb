class ParentTasksController < ApplicationController
  before_filter :find_issue_and_project

  def parents
    query = (params[:q] || params[:term]).to_s.strip
    scope = Issue.includes(:tracker).cross_project_scope(@project, params[:scope])
      .visible.joins(:status).order('issues.id DESC').limit(20)
      .select(:id, :subject, :tracker_id, :status_id, 'issue_statuses.name')
    if @allowed_trackers
      scope = scope.where('issues.tracker_id IN (?)', @allowed_trackers)
    end
    if query.blank?
      @issues = scope.to_a
    elsif query.match(/\A#?(\d+)\z/)
      @issues = scope.where('CONVERT(issues.id, char) LIKE ?', "%#{$1}%")
    else
      @issues = scope.where('LOWER(issues.subject) LIKE LOWER(?)', "%#{query}%")
    end
    render json: @issues.group_by { |issue| issue.tracker.name }
  end

  private

  def find_issue_and_project
    @issue = Issue.where(id: params[:issue_id]).first
    project_identifier = params[:project_identifier]
    project_id = params[:project_id]
    if project_identifier
      @project = Project.where(identifier: project_identifier).first
    else
      @project = Project.where(id: project_id).first
    end
    @project ||= @issue.project
    settings = Setting.plugin_redmine_restrict_tracker
    if settings.present?
      tracker_id = params[:tracker_id] || issue.tracker_id
      tracker = Tracker.where(id: tracker_id).first or render_404
      tracker_name = tracker.name
      restricted_name = "restrict_#{tracker_name.downcase.split(' ').join('_')}"
      restrict_setting = settings[restricted_name]
      if restrict_setting && restrict_setting == '1'
        parents_name = "parents_for_#{tracker_name.downcase.split(' ').join('_')}"
        tracker_settings = settings[parents_name]
        if tracker_settings
          @allowed_trackers = tracker_settings.split(',').map(&:to_i)
        end
      end
    end
  end
end
