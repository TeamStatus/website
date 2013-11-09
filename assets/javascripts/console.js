var con = angular.module('teamstatus.console', []);

var JiraCtrl = ['$scope', '$log', '$http', '$window', function($scope, $log, $http, $window) {
	$http.get("/console/ajax/jiraServer").success(function(data) {
		$scope.jira = data;
	});

	$scope.saveJira = function() {
		$scope.saved = false;
		$scope.sending = true;
		$http.post("/console/ajax/jiraServer", $scope.jira).success(function(data) {
			$scope.saved = true;
			$scope.sending = false;
			$scope.jira = data;
		}).error(function(data) {
			$scope.sending = false;
		});
	};
}];