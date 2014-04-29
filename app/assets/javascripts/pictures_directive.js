angular.module('apod').directive('apodPictures', ['apodPictureService', function($pictures){
    var MARGIN = 4; // hacky

    function errHandler(err){
        console.warn(err);
    }

    return {
        restrict: 'A',
        scope: true,

        // $scope.pictures is our visual buffer
        link:function($scope, $elem, $attrs){
            var sheight, swidth, request, limit;

            function layout(pics){
                var height, twidth, row, pic;
                var theight = 0;

                function totalWidth(){
                    return row.reduce(function(sum, pic){
                        return sum + ((height / pic.height) * pic.width) + MARGIN;
                    }, 0);
                }

                function hide(pic){ pic.styles = { display: 'none' }; }
                function style(pic){ pic.styles = { height: height }; }

                if (pics == undefined || sheight == undefined)
                    return;

                for (var i = 0, len = pics.length; i < len; i++){
                    pic = pics[i];

                    if (height == undefined){ // new row
                        height = sheight;
                        row = [];
                    }

                    if (pic.height < height) // small picture
                        height = pic.height;

                    row.push(pic);

                    twidth = totalWidth();

                    if (twidth < swidth){
                        if (i + 1 == len) // end of the set
                            row.forEach(hide);

                        continue; // add another pic

                    } else {
                        while(twidth > swidth){
                            height -= 1; // find an optimal height for this row
                            twidth = totalWidth();
                        }

                        // Set height for all pictures in row
                        row.forEach(style);

                        // Onto another row we go
                        theight += height;
                        height = row = undefined;
                    }
                }

                if (theight < sheight)
                    load(); // We need more to fill the screen
            }

            function setScreen(screen, oldScreen){
                if (screen != undefined){
                    sheight = screen.height;
                    swidth = screen.width;

                    if (oldScreen === undefined){
                        // TODO tweak this based up screen size?
                        // We assume the avg picture 500x500
                        limit = Math.ceil((sheight/500) * (swidth/500));

                        load();
                    }
                }

                if (oldScreen != undefined){
                    layout($scope.pictures);
                }
            }

            function load(){
                if (request != undefined)
                    return; // loading in progress...

                var pics = $scope.pictures;

                var lastPic = pics && pics[pics.length - 1];
                var last = lastPic && lastPic.apid;

                $elem.addClass('load-below');

                request = $pictures.get(limit, last).then(function(newPics){
                    var existing = $scope.pictures;
                    var pics;

                    $scope.pictures = existing == undefined ?
                        newPics : existing.concat(newPics);
                });

                // Always clear the request promise when complete
                request['finally'](function(){
                    $elem.removeClass('load-below');

                    request = undefined;
                });
            }

            $scope.$watch('screen', setScreen);
            $scope.$watch('pictures', layout);

            $scope.$on('$scrollEnd', function(){
                if (request == undefined){
                    load();
                }
            });
        }
    };
}]);
