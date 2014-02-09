var con = angular.module('teamstatus.console', [
	'ngRoute',
	'angular-underscore',
	'frapontillo.ex.filters',
	'ui.bootstrap'
])
.constant('path', angular.element('meta[name="ts.console.basePath"]').attr('content') + '')
.constant('partials', angular.element('meta[name="ts.console.basePath"]').attr('content') + '/partials')
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

