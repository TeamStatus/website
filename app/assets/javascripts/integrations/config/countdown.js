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