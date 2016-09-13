angular.module('apod').service('apodPictureService', ['$q', '$http', function($q, $http){
    function loadImage(pic){
        return $q(function(resolve, reject){
            var img = new Image;

            img.onload = function(){
                pic.height = img.height;
                pic.width = img.width;
                pic.ratio = img.height / img.width;

                resolve();
            };

            img.onerror = reject;
            img.src = pic.media_link;
        });
    }

    return {
        get:function(limit, last){
            var params = {};

            if (limit != undefined) params.limit = limit;
            if (last != undefined) params.last = last;

            return $q(function(resolve){
                $http({
                    method: 'GET',
                    url: '/pictures',
                    params: params
                }).then(function(resp){
                    var pics = [];

                    resp.data.reduce(function(promise, pic){
                        function create(){
                            return createImage(pic).then(function(){
                                pics.push(pic);
                            });
                        }

                        return promise ? promise.then(createImage) : createImage();
                    }, false).then(function(){
                        resolve(pics);
                    });
                });
            });
        }
    };
}]);
