var oldReplaceIssueFormWith = replaceIssueFormWith;

replaceIssueFormWith = function(html) {
  oldReplaceIssueFormWith(html);
  addS2ToParentTaskField();
}

$(document).ready(function(){
  addS2ToParentTaskField();
});

function addS2ToParentTaskField() {
  var parentTaskField = $('#issue_parent_issue_id');
  var parentTask = parentTaskField.val();
  var issueForm = $('#issue-form');
  if (issueForm.length === 0) { return; }
  var issueFormAction = issueForm.attr('action').split('/')
  var issueId = issueFormAction[issueFormAction.length -1];
  var projectId = $('#issue_project_id').val();
  var projectIdentifier = null;
  if (projectId === undefined) {
    projectIdentifier = window.location.pathname.split('/')[2];
  }
  parentTaskField.select2({
    ajax: {
      url: '/autocomplete/parents',
      dataType: 'json',
      quietMillis: 250,
      data: function (params) {
        return {
          issue_id: issueId,
          tracker_id: $('#issue_tracker_id').val(),
          project_id: projectId,
          project_identifier: projectIdentifier,
          term: params,
          scope: 'tree'
        };
      },
      results: function (data, page) {
        var myResults = [];
        $.each(data, function (index, item) {
            var issues = [];
            $.each (item, function(issue_index, issue) {
              issues.push({
                'id': issue.id,
                'text': issue.subject + ' (' + issue.id + ') <span class="status status-' + issue.status_id + '">' + issue.name + '</span>'
              });
            });
            myResults.push({
                'text': index,
                'children': issues
            });
        });
        return {results: myResults};
      },
      cache: true
    },
    initSelection: function(element, callback) {
      callback({id: parentTask, text: parentTask });
    },
    formatResult: function(item) {
      return item.text;
    },
    formatSelection: function(item) {
      return item.id;
    },
    allowClear: true,
    width: '200',
    dropdownAutoWidth: true,
    minimumInputLength: 0,
    placeholder: 'None'
  })
}
