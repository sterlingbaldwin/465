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
  $scope.login = () ->
    username = $('#login-username-field').val()
    passhash = $scope.hash $('#login-password-field').val()
    console.log 'login'
    console.log passhash
    $http({
      url: '/login',
      method: 'POST',
      data: {
        username: username,
        passhash: passhash
      }
    })
    .success((res) ->
      $scope.user['loggedin'] = true
      $scope.user['token'] = res['response_data']['token']
      $scope.user['username'] = $('#login-username-field').val()
      $('#login_modal').foundation 'reveal', 'close'
      console.log res
      console.log 'login successful'
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

  $scope.logout = () ->
    data = {
      username: $scope.user.username,
      token: $scope.user.token
    }
    console.log data
    $http({
      url: '/logout',
      method: 'POST',
      data: data
    })
    .success((res) ->
      console.log res
      console.log 'logout successful'
      $('#logout_modal').foundation 'reveal', 'close'
      $scope.user.loggedin = false
    )
    .error((res) ->
      alert 'logout error'
    )

  $scope.register = () ->
    data = {
      username: $('#reg-username-field').val(),
      passhash: $scope.hash($('#reg-password-field').val()),
      email: $('#reg-email-field').val()
    }
    console.log 'register'
    console.log data
    $http({
      url: '/register',
      method: 'POST',
      data: data
    })
    .success((res) ->
      console.log res
      console.log 'registration successful'
      $scope.user['loggedin'] = true
      $scope.user['token'] = res['token']
      $scope.user['username'] = $('#reg-username-field').val()
      $('#register_modal').foundation 'reveal', 'close'
      return
    )
    .error((res)->
      console.log res
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
