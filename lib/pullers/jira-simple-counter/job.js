var async = require('async'),
    qs = require('querystring');

module.exports = function(config, dependencies, job_callback) {

  if(!config.server || !config.server.address) {
    return job_callback("No JIRA server configured");
  }

  if(!config.server.username || !config.server.password) {
    return job_callback('No JIRA credentials found');
  }

  if (!config.jqlOpen) {
    return job_callback('No JQL for issues');
  }

  var logger = dependencies.logger;
  var maxResults = 200; // Dictated by the JAC server - we can't change this
  var baseUrl = config.server.address + '/rest/api/2/search?';
  var clickUrl = config.server.address + "/issues/?";
  var options = {
    headers: {
      "authorization": "Basic " + new Buffer(config.server.username + ":" + config.server.password).toString("base64")
    }
  };

  function query (jql, callback) {
    var params = {
      jql: jql,
      maxResults: maxResults,
      fields: "key"
    };

    options.url = baseUrl + qs.stringify(params);

    dependencies.easyRequest.JSON(options, function(err, blockerData) {
      if (err) {
        logger.error(err);
        callback(err);
      } else {
        callback(null, {
          count: blockerData.issues.length,
          maxResults: maxResults,
          url: clickUrl + qs.stringify(params),
          label: "Issues"
        });
      }
    });
  }

  query(config.jqlOpen, job_callback);
};
