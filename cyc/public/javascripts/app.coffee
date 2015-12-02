cyc = angular.module('cyc', ['ngAnimate'])
.controller 'CycCtrl', ['$scope', '$http', ($scope, $http) ->

  $scope.init = () ->
    $scope.page = 'home'
    $scope.user = {
      loggedin: false,
      token: ''
    }
    return

  $scope.hash = (str) ->
    hash = 0
    if (str.length == 0)
      return hash
    for i in [0..str.length-1]
        char = str.charCodeAt(i)
        hash = ((hash<<5)-hash)+char
        hash = hash & hash
    hash

  #TODO: finish this
  $scope.login = (username, password) ->
    $http({
      url: '/login',
      method: 'GET'
    })
    .success((res) ->
      $scope.user['loggedin'] = res['loggedin']
      $scope.user['token'] = res['token']
      return
    )
    .error((res) ->
      console.log res
      $scope.user['loggedin'] = false
      $scope.user['token'] = ''
      return
    )
    return

  $scope.login_modal_trigger = () ->
    $('#login_modal').foundation 'reveal', 'open'
    return

  $scope.logout_modal_trigger = () ->
    $('#logout_modal').foundation 'reveal', 'open'
    return

  $scope.register_modal_trigger = () ->
    $('#register_modal').foundation 'reveal', 'open'
    return

  $scope.register_trigger = () ->
    data = {
      username: $('#reg-username-field').val(),
      passhash: $scope.hash($('#reg-password-field').val()),
      email: $('#reg-email-field').val()
    }
    $http({
      url: '/register',
      method: 'POST',
      data: data
    })
    .success((res) ->
      console.log res
      $scope.user['loggedin'] = true
      $scope.user['token'] = res['token']
      $('#register_modal').foundation 'reveal', 'close'
      return
    )
    .error((res)->
      $scope.user['loggedin'] = false
      alert 'Failed to register new user!'
      return
    )
    return

  $scope.home = () ->
    $scope.page = 'home'

  $scope.about = () ->
    $scope.page = 'about'
    $http({
      url: '/about',
      method: 'GET',
    })
    .success((res) ->
      console.log res['text']
      $scope.about_text = res['text']
      return
    )
    .error((res) ->
      console.log res
      return
    )
    return

  $scope.history = () ->
    $scope.page = 'history'
    $http({
      url: '/history',
      method: 'GET'
    })
    .success((res) ->
      console.log res['text']
      $scope.history_text = res['text']
      return
    )
    .error((res) ->
      console.log res
      return
    )
    return
]
