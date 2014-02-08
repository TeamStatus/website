angular.module('teamstatus.console.boards', ['teamstatus.console.widget'])
.factory('boards', function() {
	return angular.element('.boards').data('boards');
})
.controller('BoardsCtrl', ['$scope', 'boards', function($scope, boards) {
	$scope.boards = boards;
}])
.controller('BoardCtrl', ['$scope', '$http', '$window', 'path', function($scope, $http, $window, path) {
	$scope.saveBoard = function() {
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
			$http.post(path + '/boards.json', {
				name: $scope.board.name
			}).success(function(data) {
				if (!data.error) {
					$window.location.href= path + '/boards';
				}
			});
		}
	};
}]);