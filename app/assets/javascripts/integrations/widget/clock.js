widgets['clock'] = {
	//runs when we receive data from the job
	onData: function (el, data) {
		var fadeParams = {duration: 3000, easing: 'linear'};

		function refreshDate() {
			if (data !== undefined && data.hour !== undefined) {
				var d = new Date();
				var colonClass = 'time-colon time-colon-' + (d.getSeconds() % 2);
				var colon = '<span class="' + colonClass + '">:</span>';
				$('.content > .clock-time', el).html(data.hour + colon + data.minutes);
				$('.content > .clock-date').html(data.dateStr);
			}
		}

		refreshDate();

		if (this.prevInterval !== undefined) {
			clearInterval(this.prevInterval);
		}

		this.prevInterval = setInterval(refreshDate, 1000);
	}
};