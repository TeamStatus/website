angular.module('teamstatus.console.boards', ['teamstatus.console.widget'])
.factory('boards', function() {
	return angular.element('.boards').data('boards');
})
.controller('DeleteModalCtrl', ['$scope', '$modalInstance', 'message', function($scope, $modalInstance, message) {
  $scope.message = message;

  $scope.ok = function () {
    $modalInstance.close();
  };

  $scope.cancel = function () {
    $modalInstance.dismiss('cancel');
  };
}])
.controller('BoardsCtrl', ['$scope', '$http', '$modal', 'boards', 'path', function($scope, $http, $modal, boards, path) {
	$scope.boards = boards;

	$scope.confirmDelete= function(boardId) {
		var confirmDelete = $modal.open({
			templateUrl: 'confirmDelete.html',
			controller: 'DeleteModalCtrl',
			resolve: {
				message: function () {
					return "You are going to delete the board. Are you sure?";
				}
			}
		});

		confirmDelete.result.then(function() {
	    $http.delete(path + '/boards/' + boardId + '.json').success(function() {
				window.location.reload();
			});
	  }, function() {
	    // ignore cancel
	  });
	}
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