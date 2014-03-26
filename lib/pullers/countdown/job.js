module.exports = function(config, dependencies, job_callback) {
	var today = dependencies.moment();
	// days between today and targetDate and then add one to include today
	var targetDate = dependencies.moment(config.targetDate);
	var days = targetDate.diff(today, 'days') + 1;
	if (days < 0) {
		days = 0;
	}
	if (!config.excludeWeekends || days === 0) {
		job_callback(null, {
			count: days,
			label: config.milestoneName
		});
	} else {
		var businessDays = 0;
		var currentDay = today.clone();
		for(i = 0; i < days; i++) {
			// exclude Sundays (0) and Saturdays (6). Not accounting for public holidays ATM
			if (currentDay.day() !== 0 && currentDay.day() !== 6) {
				businessDays++;
			}
			currentDay.add(1, 'day');
		}

		job_callback(null, {
			count: businessDays,
			label: config.milestoneName
		});
	}
};