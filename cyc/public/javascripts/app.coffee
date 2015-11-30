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
      console.log res['text']
      $scope.about_text = res['text']
      return
    .fail (res) ->
      console.log res
      return

  $scope.history = () ->
    $scope.page = 'history'
    $http({
      url: '/history',
      method: 'GET'
    })
    .success (res) ->
      console.log res['text']
      $scope.history_text = res['text']
      return
    .fail (res) ->
      console.log res
      return
]
