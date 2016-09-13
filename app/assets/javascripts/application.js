//= require angular
//= require angular-animate
//= require_self
//= require pictures_service
//= require pictures_directive
//= require picture_directive

angular.module('apod', ['ngAnimate'], ['$httpProvider', function($httpProvider){
    $httpProvider.defaults.headers.common['Accept'] = 'application/json';

}]).directive('body', ['$window', '$document', function($window, $docment){
    var docEl = $docment[0].documentElement;

    return {
        restrict: 'E',

        link:function($scope, $elem, $attrs){
            var win = angular.element($window);
            var el = $elem[0];

            var lastBcast, screen;

            function bcast(){
                $scope.$broadcast('$load');
            }

            function set(){
                var height = docEl.clientHeight;
                var width = docEl.clientWidth;

                $scope.screen = screen = {
                    height: height,
                    width: width,
                    ratio: height / width
                };

                $scope.$apply();
            }

            win.on('load', set);
            win.on('resize', set);
            win.on('orientationchange', set);

            win.on('scroll', function(ev){
                var diff = (el.scrollTop + el.offsetHeight) - el.scrollHeight;

                if (diff === 0)
                    $scope.$broadcast('$scrollEnd');
            });
        }
    };
}]);
