var moment = require('moment');

require('moment-timezone');

module.exports = function (config, dependencies, job_callback) {
	var now = moment();

	if (config.timezone !== undefined) {
		var withTz = now.tz(config.timezone);
		if (withTz !== undefined) {
			now = withTz;
		}
	}

	job_callback(null, {
		hour: now.format('HH'),
		minutes: now.format('mm'),
		dateStr: now.format('YYYY-MM-DD')
	});
};