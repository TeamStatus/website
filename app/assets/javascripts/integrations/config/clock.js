//= require moment
//= require moment-timezone/moment-timezone
//= require ./moment-timezone-data.js
var ClockCtrl = ['$scope', function($scope) {
	$scope.timezones = _.map(moment.tz.zones(), function(tz) { return tz.displayName; }).sort();
}];