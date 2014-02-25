var con = angular.module('teamstatus.integrations', [])
.directive('teamstatusWidgetSize', [function () {
	return {
		restrict: 'E',
		template: '<div class="form-group">' +
	  '<label for="size">Display size</label>' +
	  '<select class="form-control" id="size" required ng-model="widgetSettings.size" ng-options="s[0] + \'x\' +  s[1] for s in supportedSize"></select>' +
	'</div>',
		scope: {
			supportedSize: '=supportedSize',
			widgetSettings: '=settings'
		},
		link: function ($scope, iElement, iAttrs) {
			if (!$scope.widgetSettings) {
				$scope.widgetSettings = {};
			}
			if(!$scope.widgetSettings.size) {
				$scope.widgetSettings.size = $scope.supportedSize[0];
			}
		}
	};
}])
.directive('teamstatusWidgetInterval', [function () {
	return {
		restrict: 'E',
		template: '<div class="form-group">' +
	  '<label for="interval">Refresh interval</label>' +
	  '<select class="form-control" id="interval" required ng-model="settings.interval" ng-options="i for i in supportedInterval"></select>' +
	'</div>',
		link: function ($scope, iElement, iAttrs) {
			if (!$scope.supportedInterval) {
				$scope.supportedInterval = ['1 minute', '60 minutes'];
			}

			if (!$scope.settings) {
				$scope.settings = {};
			}
			if(!$scope.settings.interval) {
				$scope.settings.interval = $scope.supportedInterval[0];
			}
		}
	};
}])
.factory('widgets', [function() {
	return [
		{
			name: "Clock",
			id: "clock",
			description: "Add a clock",
			configurable: true,
			widgetSettings: {
				title: "Clock"
			}
		},
		{
			name: "STFU",
			id: "stfu",
			description: "Tell your team to be quiet",
			configurable: true,
			widgetSettings: {
				title: "Shhh..."
			}
		},
		{
			name: "Bamboo Builds",
			id: "bamboo-builds",
			description: "Get Bamboo Builds status",
			configurable: true,
			widgetSettings: {
				title: "Builds"
			}
		},
		{
			name: "JIRA Counter",
			id: "jira-simple-counter",
			description: "Display number of issues in JIRA",
			configurable: true,
			widgetSettings: {
				title: "Issues"
			}
		},
		{
			name: "JIRA Issues",
			id: "jira-issue-list",
			description: "Display list of issues from JIRA",
			configurable: true,
			widgetSettings: {
				title: "Issues"
			}
		},
		{
			name: "Static HTML",
			id: "static-html",
			description: "Display static HTML",
			configurable: true,
			widgetSettings: {
				title: "HTML"
			}
		},
		{
			name: "Days until",
			id: "countdown",
			description: "Display number of days to a given date",
			configurable: true,
			widgetSettings: {
				title: "Days until"
			}
		},
		{
			name: "Crucible Reviews",
			id: "crucible-reviews",
			description: "Display number of open reviews for each team member",
			configurable: true,
			widgetSettings: {
				title: "Open reviews"
			}
		},
		{
			name: "PostgreSQL table",
			id: "postgresql-list",
			description: "Display results of PostgreSQL query",
			configurable: true,
			widgetSettings: {
				title: "PostgreSQL"
			}
		},
		{
			name: "PostgreSQL number",
			id: "postgresql-number",
			description: "Display number from PostgreSQL query",
			configurable: true,
			widgetSettings: {
				title: "PostgreSQL"
			}
		}
	];
}]);