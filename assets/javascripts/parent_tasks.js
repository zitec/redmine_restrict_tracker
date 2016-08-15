var oldReplaceIssueFormWith = replaceIssueFormWith;

replaceIssueFormWith = function(html) {
  oldReplaceIssueFormWith(html);
  addS2ToParentTaskField();
}

$(document).ready(function(){
  addS2ToParentTaskField();
});

function addS2ToParentTaskField() {
  var issueForm = $('#issue-form');
  if (issueForm.length === 0) { return; }

  parentTaskField = $('#issue_parent_issue_id')
  var parentTask = parentTaskField.val();
  parentTaskField.replaceWith("<select id='issue_parent_issue_id' name='issue[parent_issue_id]'></select>")

  var issueFormAction = issueForm.attr('action').split('/')
  var issueId = issueFormAction[issueFormAction.length -1];
  var projectId = $('#issue_project_id').val();
  var projectIdentifier = null;
  if (projectId === undefined) {
    projectIdentifier = window.location.pathname.split('/')[2];
  }

  var $element = $("#issue_parent_issue_id").select2({
    ajax: {
      url: '/autocomplete/parents',
      dataType: 'json',
      delay: 250,
      minimumInputLength: 2,
      data: function (params) {
        return {
          issue_id: issueId,
          tracker_id: $('#issue_tracker_id').val(),
          project_id: projectId,
          project_identifier: projectIdentifier,
          term: params.term,
          scope: 'tree'
        };
      },
      processResults: function (data, params) {
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
    templateResult : function(item) {
      if (item.placeholder) return item.placeholder;
      return item.text;
    },
    templateSelection : function(item) {
      if (item.placeholder) return item.placeholder;
      return item.id;
    },
    escapeMarkup: function(m) {
      // Do not escape HTML in the select options text
      return m;
    },
    allowClear: true,
    placeholder: "None",
    width: '200',
    dropdownAutoWidth: true,
    minimumInputLength: 0
  }).on("select2:unselecting", function(e) {
    $(this).data('state', 'unselected');
  }).on("select2:open", function(e) {
    if ($(this).data('state') === 'unselected') {
        $(this).removeData('state');
        $element.find('option').replaceWith('<option value=""></option>').trigger("change")

        var self = $(this);
        setTimeout(function() {
            self.select2('close');
        }, 1);
    }
  });

  if (parentTask) {
    var option = new Option(parentTask, parentTask, true, true);
    // Append it to the select
    $element.append(option).trigger("change");
  }
}
