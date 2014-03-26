var async = require('async'),
    Bamboo = require('./lib/bamboo.js'),
    cache = require('memory-cache'),
    cheerio = require('cheerio');
    _ = require("underscore");

module.exports = function(config, dependencies, job_callback) {

  if(!config.server || !config.server.address) {
    return job_callback("No Bamboo server configured");
  }

  if(!config.server.username || !config.server.password) {
    return job_callback('No Bamboo credentials found');
  }

  if (!config.showBuilds && !config.failBuilds) {
    return job_callback('No Bamboo builds');
  }

  // var logger = dependencies.logger;

  var username = config.server.username;
  var password = config.server.password;
  var bamboo = new Bamboo(config.server.address, username, password, dependencies.request, cache, cheerio);

  // get plan info with extra info if failed build
  var getData = function(plan, callback) {

    // get plan information from
    bamboo.getPlanInfo(plan, function (err, build) {

      var result = {
        link : config.server.address + "/browse/" + plan,
        planKey: plan,
        planName: plan,
        responsible: [],
        isRefreshing: false,
        success : "",
        down : false
      };

      if (err || !build) {
        result.down = true;
        // logger.error (err ? ("error accessing build info for plan " + plan + ": " + err) : "non build info available for plan " + plan);
        // we don´t pass the error to the caller. we just mark it as down.
        return callback(null, result);
      }

      result.planName = build.planName;

      // Find if there is next build in-progress
      var possiblyInProgressBuild = build.key.replace('-' + build.number, '-' + (build.number + 1));
      return bamboo.getBuildStatus(possiblyInProgressBuild, function (err, runningBuildStatus) {
        if (err || !runningBuildStatus){
          result.down = true;
          // logger.error (err ? err : "error getting build info for plan " + plan);
          return callback(null, result);
        }

        result.isRefreshing = !runningBuildStatus.finished;
        if (result.isRefreshing) {
          result.progress = runningBuildStatus.progress.percentageCompletedPretty;
          result.timeRemaining = runningBuildStatus.progress.prettyTimeRemaining.replace(' remaining', '');
        }

        if (build.state == "Successful") {
          result.success = "successful";
          return callback(null, result);
        } else {
          // get some more details, which are not included in plan overview
          result.failedTestCount = build.failedTestCount;
          result.testCount = build.failedTestCount + build.quarantinedTestCount + build.successfulTestCount;
          result.successfulTestCount = build.successfulTestCount;
          result.quarantinedTestCount = build.quarantinedTestCount;

          return bamboo.getResponsible(build.key, function(err, users){
            if (err || !users){
              result.down = true;
              return callback(null, result);
            }
            result.success = "failed";
            result.responsible = users;
            return callback(err, result);
          });
        }
      });
    });
  };

  // -----------------------
  // fetch plans
  // -----------------------
  function check_plans(builds, callback) {
     if (!builds || !builds.length) {
        callback(null, []);
     } else {
       var fetcher = function (build, callback) {
         bamboo.getPlansFromProject(build, function (err, plans) {
          if (err) {
           // logger.error ("error accesing build \"" +  build + "\": " + err);
           return callback(null, []); //we don't want the error to level up.
          }
          return callback(null, plans);
         });
        };

       async.map(builds, fetcher, function(err, results){
         callback(err, _.flatten(results));
       });
     }
  }

  function execute_projects(builds, callback) {
    if (!builds || !builds.length){
      return callback (null, []);
    }
    return check_plans(builds, function(err, plans){
      if (err || !plans || !plans.length){
        return callback(err, []);
      }

      return async.map(plans, getData, function(err, results){
        callback(err, results);
      });
    });
  }

  // ------------------------------------------
  // MAIN
  // ------------------------------------------

  //sort function for consistent build listing
  var failure_sort = function(a, b) {
    function score (build){
      return build.down === true ? 20 : (build.success === "failed" ? 10 : 0);
    }
    return score(a) > score(b);
  };

  if (config.showBuilds === undefined) {
    config.showBuilds = "";
  }

  var failBuilds = config.failBuilds ? _.compact(config.failBuilds.replace(/\s+/g, '').split(",")) : [];
  var showBuilds = config.showBuilds ? _.compact(config.showBuilds.replace(/\s+/g, '').split(",")) : [];
  var projects = [failBuilds, showBuilds];
  console.log("Builds %j", projects);

  return async.map(projects, execute_projects, function(err, results) {
    if (err){
      // logger.error(err);
      job_callback(err);
    }
    else{
      job_callback(null, {
        showBuilds: results[1].sort(failure_sort),
        failBuilds: results[0].sort(failure_sort),
        title: config.widgetTitle
      });
    }
  });
};
