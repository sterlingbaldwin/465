var app = angular.module('app', []);

app.controller('ImgCtrl', ['$scope','$http', function($scope, $http){

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
