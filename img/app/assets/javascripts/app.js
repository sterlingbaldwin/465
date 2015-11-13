var app = angular.module('app', []);

app.controller('ImgCtrl', ['$scope','$http', function($scope, $http){

  $scope.tags = {};

  $scope.img_show = function(image){
    console.log('looking for image ' + image.id);
    var url = "http://localhost:3000/images/" + image.id;
    $('#imgModal').foundation('reveal','open');
    $('#imgModalSrc').attr({
        'src': '/images/' + image.filename
    });

    $http({
      method: 'GET',
      url: url,
      headers: {
        'Accept': 'application/json'
      }
    })
    .success(function(response) {
      console.log(response);
      // get resonse info and set it for the front end

    });
  }

  $scope.init = function(){
    console.log('starting init');
    $http({
      method: 'GET',
      url: "http://localhost:3000",
      headers: {
        'Accept': 'application/json'
      }
    }).success(function(response) {
      console.log(response);
      $scope.public_image_names = response[0];
      $scope.private_image_names = response[1];
      $scope.shared_image_names = response[2];
    });
  }
}]);
