widgets['display-number'] = {
	onError: function (el, data) {
		$(el).find('.counter').html("N/A");
	},

	onData: function (el, data) {
		var openPlus = data.count == data.maxResults ? "+" : "";
		if (data.url) {
			$(el).find('.counter').html($('<a/>').attr('href', data.url).text(data.count));
		} else {
			$(el).find('.counter').html(data.count);
		}
		if (data.label) {
			$(el).find('.label').html(data.label).show();
		} else {
			$(el).find('.label').hide();
		}
		$('.content > .counter', el).boxfit();
	}
};

widgets['postgresql-number'] = widgets['jira-simple-counter'] = widgets['display-number'];
