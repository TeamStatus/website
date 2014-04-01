angular.module('teamstatus.console.boards', ['teamstatus.console', 'teamstatus.integrations'])
.factory('boards', function() {
	return angular.element('.boards').data('boards');
})
.controller('BoardsCtrl', ['$scope', '$http', '$modal', 'boards', 'path', function($scope, $http, $modal, boards, path) {
	$scope.boards = boards;

	$scope.confirmDelete= function(boardId) {
		var confirmDelete = $modal.open({
			templateUrl: path + '/partials/confirm_action_modal',
			controller: 'ConfirmActionModalCtrl',
			resolve: {
				action: function() {return "Delete";},
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
.factory('board', function() {
	return angular.element('.board').data('board');
})
.controller('BoardCtrl', ['$scope', '$http', '$window', '$modal', 'path', 'board', function($scope, $http, $window, $modal, path, board) {
	$scope.editing = board !== undefined && board !== null;
	$scope.board = board;

	$scope.saveBoard = function() {
		if ($scope.editing) {
			$http.put(path + '/boards/' + $scope.board._id + '.json', {
				name: $scope.board.name
			}).success(function(data) {
				if (!data.error) {
					$window.location.href= path + '/boards';
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

	$scope.resetPublicId = function(boardId) {
		var confirmModal = $modal.open({
			templateUrl: path + '/partials/confirm_action_modal',
			controller: 'ConfirmActionModalCtrl',
			resolve: {
				action: function() {return "Reset";},
				message: function () {
					return "You are going to reset public url for the board. Clicking Reset will instantly change it and the previous url will stop working. Are you sure?";
				}
			}
		});

		confirmModal.result.then(function() {
	    $http.post(path + '/boards/' + boardId + '/public_id.json').success(function(data) {
	    	$scope.board.publicId = data.publicId;
	    	$scope.board.public_url = data.public_url;
			});
	  }, function() {
	    // ignore cancel
	  });
	}
}]);