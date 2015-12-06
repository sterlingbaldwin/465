cyc = angular.module('cyc', ['ngAnimate', 'ngCookies'])
.controller 'CycCtrl',['$scope','$http','$cookies', ($scope, $http, $cookies) ->

  $scope.init = () ->
    $scope.page = 'home'
    $scope.user = {
      loggedin: $cookies.get('cycstatus')
      token: ''
    }
    $scope.blog_edit = {}
    $scope.codeMirrorConfig = {
      mode: 'twilight'
      lineNumbers: true
      inputStyle: 'textarea'
      viewportMargin: Infinity
    }
    if $scope.user.loggedin
      $scope.user['username'] = $cookies.get 'cycuser'
      $scope.user['token'] = $cookies.get 'cyctoken'
      $http({
        url: '/user_type'
        method: 'POST'
        data: {
          username: $scope.user['username']
        }
      })
      .success((res)->
        $scope.user.type = res.user_type
        return
      )
      .error((res)->
        console.log 'error in user type request'
        console.log res
        return
      )
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

  $scope.blog_submit = (arg) ->
    if arg == 'new'
      title = $('#blog_title').val()
      id = ''
    else
      title = $('#' + arg + '_title').text()
      id = $('#' + arg + '_id').text()
    data = {
      text: $scope.codeMirror.getValue()
      title: title
      author: $scope.user.username
      token: $scope.user.token
      id: id
    }
    $http({
      url: '/blog'
      method: 'POST'
      data: data
    })
    .success((res)->
      $scope.new_blog_post = false
      $scope.blog_edit[arg] = false
      $scope.get_blogs()
      return
    )
    .error((res)->
      console.log 'blog submit error'
      console.log res
      return
    )
    return


  $scope.new_blog = () ->
    $scope.new_blog_post = true
    return

  $scope.edit_blog = (blog_index) ->
    $scope.blog_edit[blog_index] = true
    $scope.codeMirror = CodeMirror(
      $('#' + blog_index + '_edit')[0],
      $scope.codeMirrorConfig
    )
    $scope.codeMirror.setValue $('#' + blog_index + '_text').text()
    return

  $scope.delete_blog = (blog_index) ->
    data = {
      id: $('#' + blog_index + '_id').text()
      username: $scope.user.username,
      token: $scope.user.token
    }
    $http({
      url: '/blog_delete'
      method: 'POST'
      data: data
    })
    .success((res)->
      $scope.get_blogs()
      return
    )
    .error((res) ->
      console.log 'blog delete error'
      console.log res
      return
    )
    return

  $scope.get_blogs = () ->
    $http({
      url: '/blog'
      method: 'GET'
    })
    .success((res) ->
      console.log res
      res.reverse()
      $scope.blogs = res
      console.log $scope.blogs
    )
    .error((res) ->
      console.log res
    )
    return

  $scope.blog = () ->
    $scope.page = 'blog'
    if typeof $scope.codeMirror == 'undefined'
      $scope.codeMirror = CodeMirror(
        $('#blog_edit')[0],
        $scope.codeMirrorConfig
      )
    $scope.get_blogs()
    return

  $scope.login = () ->
    username = $('#login-username-field').val()
    passhash = $scope.hash $('#login-password-field').val()
    console.log 'login'
    console.log passhash
    $http({
      url: '/login'
      method: 'POST'
      data: {
        username: username
        passhash: passhash
      }
    })
    .success((res) ->
      $scope.user['loggedin'] = true
      $scope.user['token'] = res['response_data']['token']
      $scope.user['type'] = res['response_data']['user_type']
      $scope.user['username'] = $('#login-username-field').val()
      $('#login_modal').foundation 'reveal', 'close'
      $cookies.put 'cycstatus', 'loggedin'
      $cookies.put 'cycuser', $scope.user['username']
      $cookies.put 'cyctoken', $scope.user['token']
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
      username: $scope.user.username
      token: $scope.user.token
    }
    console.log data
    $http({
      url: '/logout'
      method: 'POST'
      data: data
    })
    .success((res) ->
      console.log res
      console.log 'logout successful'
      $('#logout_modal').foundation 'reveal', 'close'
      $scope.user.loggedin = false
      $cookies.remove 'cycstatus'
      $cookies.remove 'cyctoken'
    )
    .error((res) ->
      alert 'logout error'
    )

  $scope.register = () ->
    data = {
      username: $('#reg-username-field').val()
      passhash: $scope.hash $('#reg-password-field').val()
      email: $('#reg-email-field').val()
    }
    console.log 'register'
    console.log data
    $http({
      url: '/register'
      method: 'POST'
      data: data
    })
    .success((res) ->
      console.log res
      console.log 'registration successful'
      $scope.user['loggedin'] = true
      $scope.user['token'] = res['token']
      $scope.user['username'] = $('#reg-username-field').val()
      $scope.user['type'] = res['user_type']
      $('#register_modal').foundation 'reveal', 'close'
      $cookies.put 'cycstatus', 'loggedin'
      $cookies.put 'cycuser', $scope.user['username']
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
      url: '/history'
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
