widgets['stfu'] = {
	//runs when we receive data from the job
	onData: function (el, data) {
		var fadeParams = {duration: 3000, easing: 'linear'};

		function startStfu() {
			$('.stfu-off', el).fadeOut(fadeParams);
			$('.stfu-on', el).fadeIn(fadeParams);
		}

		function stopStfu() {
			$('.stfu-on', el).fadeOut(fadeParams);
			$('.stfu-off', el).fadeIn(fadeParams);
		}

		function refreshDate() {
			if (data.isStfu) {
				startStfu();
			} else {
				stopStfu();
			}
		}

		refreshDate();
	}
};