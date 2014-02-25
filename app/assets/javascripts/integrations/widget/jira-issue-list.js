widgets['jira-issue-list'] = {
	onError: function (el, data) {
		$(el).find('.counter').html("N/A");
	},

	onData: function (el, data) {
		var $tbody = $('.table tbody', el).empty();
		var issueTemplate = Handlebars.compile($(".issue-row-template", el).html());
		_.each(data.issues, function(issue) {
			$tbody.append(issueTemplate({issue: issue}));
		});
	}
};