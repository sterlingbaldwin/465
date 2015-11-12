var app = angular.module('app', []);

app.controller('ImgCtrl', ['$scope','$http', function($scope, $http){
  console.log('asdf');
  $scope.init = function(){
    $http({
      method: 'GET',
      url: "http://localhost:3000",
      headers: {
        'Accept': 'application/json'
      }
    }).success(function(response) {

    });
  }
}]);
