wladder = angular.module('wladder',[]).controller('MainCtrl', [
'$scope', '$http', function($scope, $http){
  
  $scope.init = function(){
	$http.get("http://baldwin.codes:8000/words")
        .success(function(response){console.log(response)});
  }
  $scope.victory = false;
  $scope.checked = false;
  $scope.start_word = 'qwert';
  $scope.end_word = 'trewq';
  $scope.attempts = ["1", "2", "3", "4", "5"];
  $scope.refresh = function(){
	$scope.victory = false;
	$scope.checked = false;
	$scope.attempts = ["1", "2", "3", "4", "5"];
	//ajax call to get new start and end words
        $http.get("http://baldwin.codes:8000/words")
        .success(function(response){console.log(response)});
  }
  $scope.getNumber = function(num) {
    return new Array(num);   
  } 
  $scope.distance = function(a, b){
	if(a.length != b.length) return -1;
	var distance = 0;
	for(var i = 0; i < a.length; a++){
		if(a[i] != b[i]){
			distance++;
		}
	}
	return distance;  
  }
  $scope.is_good = function(i){
  	var good = 0;
	switch(i){
		case 0:{
			if($scope.distance($scope.start_word, $scope.attempts[i]) > 0) good = 1;
			break;
		}
		default:{
			if($scope.distance($scope.attempts[i-1], $scope.attempts[i]) > 0) good = 1;
		}
	}
	return good;
  }
 $scope.check = function(){
	var good = true;
 	$scope.attempts.forEach(function(element, index, array){
		console.log(element, index, array);
		if(index == 0){
			if($scope.distance($scope.start_word, element) != 1){
				good = false;
			}
			return;
		} 
		if($scope.distance(element, array[index - 1]) != 1){
			good = false;
			return;
		}
		if(index == array.length - 1){
			if($scope.distance(element, $scope.end_word) != 1){
				good = false;
			}
			return;
		}
	});
	$scope.victory = good;
        $scope.checked = true;
	$("#checked-false").hide();
	$("#checled-true").show();
 }
}]);
