








var con = angular.module('teamstatus.integrations', [])
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
		}
	];
}]);
var BambooBuildsCtrl = ['$scope', function($scope) {
}];
var JiraSimpleCounterCtrl = ['$scope', function($scope) {
}];
var JiraSimpleCounterCtrl = ['$scope', function($scope) {
}];
var StaticHtmlCtrl = ['$scope', function($scope) {
}];
var StfuCtrl = ['$scope', function($scope) {
	$scope.addTimeSpan = function() {
		var span = { start : new Date(), end : new Date() };
		span.start.setHours(10);
		span.start.setMinutes(0);
		span.end.setHours(11);
		span.end.setMinutes(0);
		$scope.settings.timeSpans.push(span);
	};

	$scope.removeTimeSpan = function(idx) {
		$scope.settings.timeSpans.splice(idx, 1);
	};

	if ($scope.settings.timeSpans === undefined) {
		$scope.settings.timeSpans = [];
		$scope.addTimeSpan();
	}
}];
var CountdownCtrl = ['$scope', function($scope) {
	$scope.today = new Date();

	$scope.open = function($event) {
		$event.preventDefault();
		$event.stopPropagation();
		$scope.opened = true;
	};

	if ($scope.settings.targetDate === undefined) {
		$scope.settings.targetDate = new Date();
	}
}];
var CrucibleReviewsCtrl = ['$scope', function($scope) {
}];
var PostgreSqlListCtrl = ['$scope', function($scope) {
}];
var con = angular.module('teamstatus.console', ['ngRoute', 'angular-underscore', 'frapontillo.ex.filters', 'ui.bootstrap'])
	.constant('path', angular.element('meta[name="ts.console.basePath"]').attr('content') + '')
	.constant('partials', angular.element('meta[name="ts.console.basePath"]').attr('content') + '/partials');

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

var WidgetCtrl = ['$scope', '$http', '$compile', '$window', 'partials', 'widgets', 'board', 'path',
	function($scope, $http, $compile, $window, partials, widgets, board, path) {
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
			$http.get(partials + "/integrations/" + widget.id).success(function (data) {
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
