//= require integrations-config.js
angular.module('teamstatus.jobs', ['teamstatus.console', 'teamstatus.integrations'])
.factory('widget', function() {
	return angular.element('.widget').data('widget');
})
.directive('bsHolder', function() {
	return {
		link: function (scope, element, attrs) {
			Holder.run({images: element.get(0)});
		}
	};
})
.config(['$locationProvider', function($locationProvider) {
   $locationProvider.html5Mode(true);
}])
.run(['$http', function($http) {
	$http.defaults.headers.common.Accept = 'application/json';
}])
.controller('WidgetCtrl', ['$scope', '$http', '$window', '$location', 'path', 'widget',	function($scope, $http, $window, $location, path, widget) {
	$scope.editing = widget !== undefined;
	if ($scope.editing) {
		$scope.widgetSettings = widget.widgetSettings;
		$scope.settings = widget.settings;
	};

	$scope.saveWidget = function() {
		if ($scope.editing) {
			$http.put('.', {
				settings: $scope.settings,
				widgetSettings: $scope.widgetSettings
			}).success(function(data) {
				if (!data.error) {
					$window.location.href = angular.element('.btn.cancel').attr('href');
				}
			});
		} else {
			$http.post('.', {
				jobId: $location.search().widget_id,
				settings: $scope.settings,
				widgetSettings: $scope.widgetSettings
			}).success(function(data) {
				if (!data.error) {
					$window.location.href = angular.element('.btn.cancel').attr('href');
				}
			});
		}
	};
}]);
