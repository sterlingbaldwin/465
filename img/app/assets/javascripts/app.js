var app = angular.module('app', []);

app.controller('ImgCtrl', ['$scope','$http', function($scope, $http){

  $scope.tags = {};
  $scope.tag_modify_id = 0;
  $scope.image_types = {
      'Your Private Images': '',
      'Your Shared Images': '',
      'Public Images': ''
  }

  $scope.get_img_vals = function(key){
    return $scope.image_types[key];
  }

  $scope.get_types = function(){
    return Object.keys($scope.image_types);
  }

  $scope.modify_tag = function(mode, tag_id){
    var image_id = $('#imgModalSrc').attr('data-image-id');
    console.log('mode:' + mode + ' tag_id:' + tag_id + ' image_id:' + image_id);
    if(mode == 'delete'){
      $http({
        method: 'DELETE',
        url: '/tags/' + tag_id
      })
      .success(function(){
        $('#tag_' + tag_id).remove();
      });
    } else {
      console.log('tag_id: ' + tag_id);
      var tag = $.grep($scope.tags, function(e){
        return e.tag_id == tag_id
      });
      console.log(tag[0]);
      $scope.tag_modify_id = tag[0].tag_id
    }
  };

  $scope.submit_edit = function(tag_id){
    var data = {
        'text': $('#edit-tag-input').val()
    }
    console.log('in submit edit with tag_id:' + tag_id + "\nwith input:" + $('#edit-tag-input').val());
    $('#tag_' + tag_id + '_p').text(data['text']);
    $http({
      method: 'PUT',
      url: '/tags/' + tag_id,
      data: data,
      headers: {
        'Accept': 'application/json'
      }
    })
    .success(function(response){
      console.log('success');
      $('#tag-edit-div').hide();
      $scope.tag_modify_id = 0;
    });
  }

  $scope.img_show = function(image){
    console.log('looking for image ' + image.id);
    var url = "http://localhost:3000/images/" + image.id;
    $('#imgModal').foundation('reveal','open');
    $('#imgModalSrc').attr({
        'src': '/images/' + image.filename,
        'data-image-id': image.id
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
      $scope.tags = response.tags;
      $scope.owner = response.owner;
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
      $scope.image_types['Your Private Images'] = response['user_owned'];
      $scope.image_types['Your Shared Images'] = response['shared'];
      $scope.image_types['Public Images'] = response['public'];
    });
  }
}]);
