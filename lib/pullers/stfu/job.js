module.exports = function (config, dependencies, job_callback) {
	var isStfu = function (timeSpans) {
		var date = new Date();
		var currentHour = date.getHours();
		var currentMinute = date.getMinutes();

		if (timeSpans && timeSpans.length) {
			for (var i = 0; i < timeSpans.length; i++) {
				var startTime = new Date(timeSpans[i].start), endTime = new Date(timeSpans[i].end);
				if (startTime > endTime) {
					endTime = [startTime, startTime = endTime][0]; // swap
				}

				if ((startTime.getHours() < currentHour
						|| (startTime.getHours() == currentHour && startTime.getMinutes() < currentMinute))
					&& (currentHour < endTime.getHours()
						|| (currentHour == endTime.getHours() && currentMinute < endTime.getMinutes()))) {
					return true;
				}
			}
		}
		return false;
	};

	job_callback(null, {
		isStfu: isStfu(config.timeSpans)
	});
};