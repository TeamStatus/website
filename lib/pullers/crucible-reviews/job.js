var async = require('async'), qs = require('querystring'), util = require('util'), _ = require('underscore');

module.exports = function(config, dependencies, job_callback) {
	if(!config.server || !config.server.address) {
		return job_callback("No Bamboo server configured");
	}

	if(!config.server.username || !config.server.password) {
		return job_callback('No Bamboo credentials found');
	}

	if (!config.teamMembers) {
		return job_callback("No team members configured");
	}

	if (!config.projects) {
		return job_callback("No projects configured");
	}

	var requestOptions = {
			headers: {
				"authorization": "Basic " + new Buffer(config.server.username + ":" + config.server.password).toString("base64")
			}
		};

	// var logger = dependencies.logger;
	var reviewsUrl = config.server.address + '/rest-service/reviews-v1/filter.json?states=Review&';
	var userUrl = config.server.address + '/rest-service/users-v1/';

	var teamMembers = config.teamMembers.replace(/\s+/g, '').split(",");
	var projects = config.projects.replace(/\s+/g, '').split(",");

	async.map(teamMembers, function(teamMember, teamMemberCallback) {
		async.map(projects, function(project, projectCallback) {
			requestOptions.url = reviewsUrl + qs.stringify({author: teamMember, project: project});

			// logger.log("Downloading reviews from " + requestOptions.url);

			dependencies.request(requestOptions, function(err, response, body) {
				if (err || !response || response.statusCode != 200) {
					var error_msg = (err || (response ? ("Bad status code: " + response.statusCode) : "Bad response")) + " from " + requestOptions.url;
					// logger.error(error_msg);
					projectCallback(error_msg);
				} else {
					var filterResult;
					try {
						filterResult = JSON.parse(body);
					} catch(e) {
						// logger.error("Unable to parse JSON " + e);
						return projectCallback(e);
					}
					projectCallback(null, filterResult.reviewData.length);
				}
			});
		}, function(err, reviewCounts) {
			if (err) {
				teamMemberCallback(err, null);
			} else {
				var summary = _.reduce(reviewCounts, function(memo, num) {
					return memo + num;
				});

				teamMemberCallback(null, {
					"username": teamMember,
					"openReviews": summary
				});
			}
		});
	}, function(err, reviewsByUser) {
		job_callback(err, {baseUrl: config.server.address, reviews: reviewsByUser});
	});
};
