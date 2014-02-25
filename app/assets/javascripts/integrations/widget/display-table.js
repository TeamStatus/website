widgets['display-table'] = {
	onData: function (el, data) {
		var $tbody = $('.table tbody', el).empty();
		var rowsTemplate = Handlebars.compile($(".row-template", el).html());
		_.each(data.rows, function(row) {
			$tbody.append(rowsTemplate({row: row}));
		});
	}
};