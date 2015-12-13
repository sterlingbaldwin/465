cyc = angular.module('cyc', ['ngAnimate', 'ngCookies'])
.controller 'CycCtrl',['$scope','$http','$cookies', ($scope, $http, $cookies) ->

  $scope.sortType     = 'name'
  $scope.sortReverse  = false
  $scope.searchFish   = ''


  $scope.init = () ->
    $scope.page = 'home'
    $scope.blog_edit = {}
    $scope.profile_edit = {}
    $scope.codeMirrorConfig = {
      mode: 'twilight'
      lineNumbers: true
      inputStyle: 'textarea'
      viewportMargin: Infinity
    }
    $scope.user = {
      loggedin: $cookies.get('cycstatus')
      token: ''
    }
    if $scope.user.loggedin
      $scope.user['username'] = $cookies.get 'cycuser'
      $scope.user['token'] = $cookies.get 'cyctoken'
      $scope.get_user_type()
    return

  $scope.profile_modal_trigger = (profile) ->
    $('#profile_modal').foundation 'reveal', 'open'
    $scope.selected_profile = profile
    console.log profile
    return

  $scope.get_user_type = () ->
    $http({
      url: '/user_type'
      method: 'POST'
      data: {
        username: $scope.user['username']
      }
    })
    .success((res)->
      $scope.user.user_type = res.user_type
      return
    )
    .error((res)->
      console.log 'error in user type request'
      console.log res
      return
    )
    return

  $scope.members = () ->
    $scope.page = "members"
    if $scope.user.loggedin && !($scope.user.user_type)
      $scope.get_user_type()

    $scope.edit_member_flag = false
    $scope.get_members()
    return

  $scope.get_members = ()->
    data = {
      username: $scope.user.username
      token: $scope.user.token
    }
    $http({
      url: '/get_members'
      method: 'POST'
      data: data
    })
    .success((res) ->
      console.log '[+] Get members success'
      console.log res
      $scope.profiles = res.response_data
      return
    )
    .error((res) ->
      console.log '[-] Get members error'
      console.log res
      return
    )
    return

  $scope.member_edit = () ->
    $scope.edit_member_flag = true
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

  $scope.edit_item = (index) ->
    $scope.profile_edit[index] = true
    return

  $scope.edit_profile_submit = (index) ->
    $scope.profile_edit[index] = false
    data = {
      username: $scope.user.username
      token: $scope.user.token
      key: $('#' + index + '_profile_key').text().trim()
      value: $('#' + index + '_edit_profile_value').val().trim()
      target_user: $scope.selected_profile.username
    }
    $http({
      url: '/edit_profile_submit'
      method: 'POST'
      data: data
    })
    .success((res)->
      console.log 'profile edit success'
      console.log res
      $scope.get_profile_items($scope.selected_profile.username)
    )
    .error((res)->
      console.log 'profile edit failure'
      console.log res
    )
    return


  $scope.edit_submit = (index) ->
    $scope.profile_edit[index] = false
    data = {
      username: $scope.user.username
      token: $scope.user.token
      key: $('#' + index + '_key').text().trim()
      value: $('#' + index + '_edit_value').val().trim()
    }
    $http({
      url: 'edit_submit'
      method: 'POST'
      data: data
    })
    .success((res)->
      console.log 'profile edit success'
      console.log res
      $scope.get_profile_items()
    )
    .error((res)->
      console.log 'profile edit failure'
      console.log res
    )
    return

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

  $scope.profile = () ->
    $scope.page = 'profile'
    $scope.get_profile_items()
    return


  $scope.get_profile_items = (target_username) ->
    data = {
      username: $scope.user.username
      token: $scope.user.token
    }
    if target_username
      data.target_user = target_username

    $http({
      url: '/profile_items'
      method: 'POST'
      data: data
    })
    .success((res)->
      console.log 'got profile items'
      console.log res
      if target_username
        $scope.selected_profile = res.profile
      else
        $scope.profile_items = res.profile
      return
    )
    .error((res)->
      console.log 'get profile items error'
      console.log res
      return
    )
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
      return
    )
    .error((res) ->
      console.log res
      return
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
      $scope.user['user_type'] = res['response_data']['user_type']
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

  $scope.dbpop = () ->
    $http {
      url: '/dbpop'
      method: 'GET'
    }
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
      $scope.page = 'home'
      $scope.user = {}
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
      $scope.user['user_type'] = res['user_type']
      $('#register_modal').foundation 'reveal', 'close'
      $cookies.put 'cycstatus', 'loggedin'
      $cookies.put 'cycuser', $scope.user.username
      $cookies.put 'cyctoken', $scope.user.token
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
