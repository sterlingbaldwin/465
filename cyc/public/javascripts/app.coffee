cyc = angular.module('cyc', [])
.controller 'CycCtrl', ['$scope', '$http', ($scope, $http) ->
  $scope.page = 'home'

  $scope.home = () ->
    $scope.page = 'home'

  $scope.about = () ->
    $scope.page = 'about'
    $http({
      url: '/about',
      method: 'GET',
    })
    .success (res) ->
      $scope.about_text = res['about_text']
      return

  $scope.history = () ->
    $scope.page = 'history'
    $http({
      url: '/history',
      method: 'GET'
    })
    .success (res) ->
      $scope.history_text = res['history_text']
      return
]
