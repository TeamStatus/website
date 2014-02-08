var con = angular.module('teamstatus.console', [
	'ngRoute',
	'angular-underscore',
	'frapontillo.ex.filters',
	'ui.bootstrap'
])
.constant('path', angular.element('meta[name="ts.console.basePath"]').attr('content') + '')
.constant('partials', angular.element('meta[name="ts.console.basePath"]').attr('content') + '/partials');
