angular.module('apod').directive('apodPicture', ['$animate', function($animate){
    return {
        restrict: 'A',

        link:function($scope, $elem, $attrs){
            var img = $elem.find('img');
            var title = $elem.find('span');

            $elem.on('mouseenter', function(){
                $animate.addClass(title, 'visible');
            });

            $elem.on('mouseleave', function(){
                $animate.removeClass(title, 'visible');
            });

            $scope.$watch('picture.styles', function(styles, oldStyles){
                var style;

                for (var i in oldStyles){
                    img[0].style[i] = null;
                }

                for (var i in styles){
                    style = styles[i];

                    switch(i){
                        case 'height':
                        case 'width':
                            style += 'px';
                        default:
                            img.css(i, style);
                    }
                }
            });
        }
    };
}]);
