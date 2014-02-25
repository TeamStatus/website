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