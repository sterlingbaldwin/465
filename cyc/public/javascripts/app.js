// Generated by CoffeeScript 1.3.3
(function() {
  var cyc;

  cyc = angular.module('cyc', ['ngAnimate', 'ngCookies']).controller('CycCtrl', [
    '$scope', '$http', '$cookies', function($scope, $http, $cookies) {
      $scope.init = function() {
        $scope.page = 'home';
        $scope.user = {
          loggedin: $cookies.get('cycstatus'),
          token: ''
        };
        $scope.blog_edit = {};
        $scope.profile_edit = {};
        $scope.codeMirrorConfig = {
          mode: 'twilight',
          lineNumbers: true,
          inputStyle: 'textarea',
          viewportMargin: Infinity
        };
        if ($scope.user.loggedin) {
          $scope.user['username'] = $cookies.get('cycuser');
          $scope.user['token'] = $cookies.get('cyctoken');
          $http({
            url: '/user_type',
            method: 'POST',
            data: {
              username: $scope.user['username']
            }
          }).success(function(res) {
            $scope.user.type = res.user_type;
          }).error(function(res) {
            console.log('error in user type request');
            console.log(res);
          });
        }
      };
      $scope.hash = function(str) {
        var char, hash, i, _i, _ref;
        hash = 0;
        if (str.length === 0) {
          return hash;
        }
        for (i = _i = 0, _ref = str.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          char = str.charCodeAt(i);
          hash = ((hash << 5) - hash) + char;
          hash = hash & hash;
        }
        return hash;
      };
      $scope.edit_item = function(index) {
        $scope.profile_edit[index] = true;
      };
      $scope.edit_submit = function(index) {
        var data;
        $scope.profile_edit[index] = false;
        data = {
          username: $scope.user.username,
          token: $scope.user.token,
          key: $('#' + index + '_key').text().trim(),
          value: $('#' + index + '_edit_value').val().trim()
        };
        $http({
          url: 'edit_submit',
          method: 'POST',
          data: data
        }).success(function(res) {
          console.log('profile edit success');
          console.log(res);
          return $scope.get_profile_items();
        }).error(function(res) {
          console.log('profile edit failure');
          return console.log(res);
        });
      };
      $scope.blog_submit = function(arg) {
        var data, id, title;
        if (arg === 'new') {
          title = $('#blog_title').val();
          id = '';
        } else {
          title = $('#' + arg + '_title').text();
          id = $('#' + arg + '_id').text();
        }
        data = {
          text: $scope.codeMirror.getValue(),
          title: title,
          author: $scope.user.username,
          token: $scope.user.token,
          id: id
        };
        $http({
          url: '/blog',
          method: 'POST',
          data: data
        }).success(function(res) {
          $scope.new_blog_post = false;
          $scope.blog_edit[arg] = false;
          $scope.get_blogs();
        }).error(function(res) {
          console.log('blog submit error');
          console.log(res);
        });
      };
      $scope.new_blog = function() {
        $scope.new_blog_post = true;
      };
      $scope.edit_blog = function(blog_index) {
        $scope.blog_edit[blog_index] = true;
        $scope.codeMirror = CodeMirror($('#' + blog_index + '_edit')[0], $scope.codeMirrorConfig);
        $scope.codeMirror.setValue($('#' + blog_index + '_text').text());
      };
      $scope.profile = function() {
        $scope.page = 'profile';
        $scope.get_profile_items();
      };
      $scope.get_profile_items = function() {
        var data;
        data = {
          username: $scope.user.username,
          token: $scope.user.token
        };
        $http({
          url: '/profile_items',
          method: 'POST',
          data: data
        }).success(function(res) {
          console.log('got profile items');
          console.log(res);
          $scope.profile_items = res.profile;
        }).error(function(res) {
          console.log('get profile items error');
          console.log(res);
        });
      };
      $scope.delete_blog = function(blog_index) {
        var data;
        data = {
          id: $('#' + blog_index + '_id').text(),
          username: $scope.user.username,
          token: $scope.user.token
        };
        $http({
          url: '/blog_delete',
          method: 'POST',
          data: data
        }).success(function(res) {
          $scope.get_blogs();
        }).error(function(res) {
          console.log('blog delete error');
          console.log(res);
        });
      };
      $scope.get_blogs = function() {
        $http({
          url: '/blog',
          method: 'GET'
        }).success(function(res) {
          console.log(res);
          res.reverse();
          $scope.blogs = res;
          console.log($scope.blogs);
        }).error(function(res) {
          console.log(res);
        });
      };
      $scope.blog = function() {
        $scope.page = 'blog';
        if (typeof $scope.codeMirror === 'undefined') {
          $scope.codeMirror = CodeMirror($('#blog_edit')[0], $scope.codeMirrorConfig);
        }
        $scope.get_blogs();
      };
      $scope.login = function() {
        var passhash, username;
        username = $('#login-username-field').val();
        passhash = $scope.hash($('#login-password-field').val());
        console.log('login');
        console.log(passhash);
        $http({
          url: '/login',
          method: 'POST',
          data: {
            username: username,
            passhash: passhash
          }
        }).success(function(res) {
          $scope.user['loggedin'] = true;
          $scope.user['token'] = res['response_data']['token'];
          $scope.user['type'] = res['response_data']['user_type'];
          $scope.user['username'] = $('#login-username-field').val();
          $('#login_modal').foundation('reveal', 'close');
          $cookies.put('cycstatus', 'loggedin');
          $cookies.put('cycuser', $scope.user['username']);
          $cookies.put('cyctoken', $scope.user['token']);
          console.log(res);
          console.log('login successful');
        }).error(function(res) {
          console.log(res);
          $scope.user['loggedin'] = false;
          $scope.user['token'] = '';
        });
      };
      $scope.login_modal_trigger = function() {
        $('#login_modal').foundation('reveal', 'open');
      };
      $scope.logout_modal_trigger = function() {
        $('#logout_modal').foundation('reveal', 'open');
      };
      $scope.register_modal_trigger = function() {
        $('#register_modal').foundation('reveal', 'open');
      };
      $scope.logout = function() {
        var data;
        data = {
          username: $scope.user.username,
          token: $scope.user.token
        };
        console.log(data);
        return $http({
          url: '/logout',
          method: 'POST',
          data: data
        }).success(function(res) {
          console.log(res);
          console.log('logout successful');
          $('#logout_modal').foundation('reveal', 'close');
          $scope.user.loggedin = false;
          $cookies.remove('cycstatus');
          $cookies.remove('cyctoken');
          return $scope.page = 'home';
        }).error(function(res) {
          return alert('logout error');
        });
      };
      $scope.register = function() {
        var data;
        data = {
          username: $('#reg-username-field').val(),
          passhash: $scope.hash($('#reg-password-field').val()),
          email: $('#reg-email-field').val()
        };
        console.log('register');
        console.log(data);
        $http({
          url: '/register',
          method: 'POST',
          data: data
        }).success(function(res) {
          console.log(res);
          console.log('registration successful');
          $scope.user['loggedin'] = true;
          $scope.user['token'] = res['token'];
          $scope.user['username'] = $('#reg-username-field').val();
          $scope.user['type'] = res['user_type'];
          $('#register_modal').foundation('reveal', 'close');
          $cookies.put('cycstatus', 'loggedin');
          $cookies.put('cycuser', $scope.user.username);
          $cookies.put('cyctoken', $scope.user.token);
        }).error(function(res) {
          console.log(res);
          $scope.user['loggedin'] = false;
          alert('Failed to register new user!');
        });
      };
      $scope.home = function() {
        return $scope.page = 'home';
      };
      $scope.about = function() {
        $scope.page = 'about';
        $http({
          url: '/about',
          method: 'GET'
        }).success(function(res) {
          console.log(res['text']);
          $scope.about_text = res['text'];
        }).error(function(res) {
          console.log(res);
        });
      };
      return $scope.history = function() {
        $scope.page = 'history';
        $http({
          url: '/history',
          method: 'GET'
        }).success(function(res) {
          console.log(res['text']);
          $scope.history_text = res['text'];
        }).error(function(res) {
          console.log(res);
        });
      };
    }
  ]);

}).call(this);
