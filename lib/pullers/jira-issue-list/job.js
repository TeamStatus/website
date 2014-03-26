var async = require('async'),
    qs = require('querystring'),
    _ = require('underscore');

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

  // var logger = dependencies.logger;
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
      maxResults: 10,
      fields: "key,summary"
    };

    options.url = baseUrl + qs.stringify(params);

    dependencies.easyRequest.JSON(options, function(err, queryData) {
      if (err) {
        // logger.error(err);
        callback(err);
      } else {
        callback(null, {
          count: queryData.issues.length,
          issues: _.map(queryData.issues, function(issue) {
            issue.url = issue.self.substring(0 , issue.self.indexOf("/rest")) + "/browse/" + issue.key;
            return issue;
          }),
          maxResults: params.maxResults,
          url: clickUrl + qs.stringify(params)
        });
      }
    });
  }

  query(config.jqlOpen, job_callback);
};
