var con = angular.module('teamstatus.console', [
	'ngRoute',
	'angular-underscore',
	'frapontillo.ex.filters',
	'ui.bootstrap'
])
.constant('path', '')
.constant('partials', '/partials')
.controller('ConfirmActionModalCtrl', ['$scope', '$modalInstance', 'message', 'action', function($scope, $modalInstance, message, action) {
  $scope.message = message;
  $scope.action = action;

  $scope.ok = function () {
    $modalInstance.close();
  };

  $scope.cancel = function () {
    $modalInstance.dismiss('cancel');
  };
}])

