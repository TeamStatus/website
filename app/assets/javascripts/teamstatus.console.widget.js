//= require integrations-config.js
angular.module('teamstatus.console.widget', ['teamstatus.console', 'teamstatus.integrations'])
	.directive('bsHolder', function() {
		return {
			link: function (scope, element, attrs) {
				Holder.run({images: element.get(0)});
			}
		};
	})
	.factory('board', ['$document', function($document) {
		return {
			editUrl: angular.element('meta[name="ts.board.editUrl"]').attr('content'),
			publicId: angular.element('meta[name="ts.board.publicId"]').attr('content'),
			boardId: angular.element('meta[name="ts.board.id"]').attr('content')
		};
	}]);

angular.module('teamstatus.console.widget.add', ['teamstatus.console.widget'])
	.config(['$routeProvider', 'partials', function($routeProvider, partials) {
		$routeProvider.when('/welcome', {
			templateUrl: partials + '/new_widget_welcome'
		}).when('/:id', {
			templateUrl: partials + '/new_widget_form',
			controller: 'WidgetCtrl'
		}).otherwise({
			redirectTo: '/welcome'
		});
	}]);

angular.module('teamstatus.console.widget.edit', ['teamstatus.console.widget'])
	.config(['$routeProvider', 'partials', function($routeProvider, partials) {
		$routeProvider.when('/:id', {
			templateUrl: partials + '/new_widget_form',
			controller: 'WidgetCtrl'
		});
	}]);

var WidgetsCtrl = ['$scope', '$routeParams', '$log', '$http', '$window', 'partials', 'widgets', 'board',
	function($scope, $routeParams, $log, $http, $window, partials, widgets, board) {
	$scope.widgets = widgets;
	$scope.board = board;
	$scope.$on('$routeChangeSuccess', routeChanged);

	routeChanged();

	function routeChanged() {
		var widgets = $scope.widgets;
		var widgetId = $routeParams.id;

		_.each(widgets, function(widget) {
			widget['active'] = !!widget['id'] && widget['id'] === widgetId;
			if(widget.active) {
				$scope.currentWidget = widget;
				$scope.$broadcast('currentWidgetChanged', $scope.currentWidget);
			}
		});
	}
}];

var EditWidgetsCtrl = ['$scope', '$routeParams', '$log', '$http', '$window', 'path', 'widgets', 'board',
	function($scope, $routeParams, $log, $http, $window, path, widgets, board) {
	$scope.editing = true;
	$scope.widgetsMap = _.indexBy(widgets, 'id');
	$scope.board = board;
	$scope.$on('$routeChangeSuccess', routeChanged);

	$http.get(path + '/boards/' + board.boardId + '/jobs.json').success(function(data) {
		$scope.boardWidgets = data;
		routeChanged();
	});

	function routeChanged() {
		var widgetId = $routeParams.id;

		_.each($scope.boardWidgets, function(widget) {
			widget['active'] = !!widget['_id'] && widget['_id'] === widgetId;
			if(widget.active) {
				$scope.currentWidget = _.extend(_.clone($scope.widgetsMap[widget.jobId]), widget);
				$scope.$broadcast('currentWidgetChanged', $scope.currentWidget);
			}
		});
	}
}];

var WidgetCtrl = ['$scope', '$http', '$compile', '$window', 'path', 'widgets', 'board', 'path',
	function($scope, $http, $compile, $window, path, widgets, board, path) {
	$scope.$on('currentWidgetChanged', function(event, widget) {
		widgetChanged(widget);
	});

	if ($scope.currentWidget !== undefined) {
		widgetChanged($scope.currentWidget);
	}

	function widgetChanged(widget) {
		$scope.settings = widget.settings || {};
		$scope.widgetSettings = widget.widgetSettings || { title: "Widget" };
		if (widget.configurable) {
			$http.get(path + "/integrations/" + widget.id + "/config").success(function (data) {
				$scope.settings = widget.settings || {};
				angular.element('.settings').html($compile(data)($scope));
			});
		}
	}

	$scope.addWidget = function() {
		if ($scope.editing) {
			$http.put(path + '/boards/' + $scope.board.boardId + '/jobs/' + $scope.currentWidget._id + '.json', {
				settings: $scope.settings,
				widgetSettings: $scope.widgetSettings
			}).success(function(data) {
				if (!data.error) {
					$window.location.href=$scope.board.editUrl;
				}
			});
		} else {
			$http.post(path + '/boards/' + $scope.board.boardId + '/jobs.json', {
				jobId: $scope.currentWidget.id,
				settings: $scope.settings,
				widgetSettings: $scope.widgetSettings
			}).success(function(data) {
				if (!data.error) {
					$window.location.href=$scope.board.editUrl;
				}
			});
		}
	};
}];
