angular.module('apod').service('apodPictureService', ['$q', '$http', function($q, $http){
    function createImage(pic){
        var dfd = $q.defer();
        var img = new Image;

        img.onload = function(){
            pic.height = img.height;
            pic.width = img.width;
            pic.ratio = img.height / img.width;

            dfd.resolve();
        };

        img.onerror = dfd.reject;
        img.src = pic.media_link;

        return dfd.promise;
    }

    return {
        get:function(limit, last){
            var deferred = $q.defer();
            var params = {};

            if (limit != undefined) params.limit = limit;
            if (last != undefined) params.last = last;

            $http({
                method: 'GET',
                url: '/pictures',
                params: params
            }).then(function(resp){
                var pics = resp.data;

                $q.all(pics.map(function(pic){
                    // Return a new promise for loading the image
                    return createImage(pic);

                })).then(function(){
                    deferred.resolve(pics);

                }, function(err){
                    deferred.reject(err);
                });

            }, function(err){
                deferred.reject(err);
            });

            return deferred.promise;
        }
    };
}]);
