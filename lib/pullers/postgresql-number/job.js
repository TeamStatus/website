var pg = require('pg'), _ = require('underscore');

module.exports = function(config, dependencies, job_callback) {

  if(!config.server || !config.server.address) {
    return job_callback("No PostgreSQL server configured");
  }

  if (!config.sqlQuery) {
    return job_callback('No SQL query');
  }

  var logger = dependencies.logger;
  var client = new pg.Client(config.server.address);
  client.on('drain', client.end.bind(client)); // disconnect client when all queries are finished
  client.connect();

  var query = client.query(config.sqlQuery, function(err, result) {
    if (err) {
      logger.error(err);
      job_callback(err);
    } else {
      job_callback(null, {
        count: result.rows[0][_.keys(result.rows[0])[0]]
      });
    }
  });
};
