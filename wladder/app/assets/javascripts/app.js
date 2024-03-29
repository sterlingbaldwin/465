wladder = angular.module('wladder', []).controller('MainCtrl', [
	'$scope', '$http',
	function($scope, $http) {
		$scope.show_button = function(button_num) {
			if (button_num != 0) {
				angular.element('#' + (button_num - 1) + '_button').css({
					'opacity': '0'
				});
			}
			console.log("got a click on " + button_num);
			angular.element('#' + button_num + '_button').css({
				'opacity': '1'
			});
		}
		$scope.init = function() {
			$http({
				method: 'GET',
				url: "http://baldwin.codes:8000",
				headers: {
					'Accept': 'application/json'
				}
			}).success(function(response) {
				$scope.start_word = response.start_word
				$scope.end_word = response.end_word
			});
			$scope.victory = false;
			$scope.checked = false;
			$scope.attempts = ["", "", "", "", ""];
		}
		$scope.victory = false;
		$scope.checked = false;
		$scope.attempts = ["", "", "", "", ""];
		$scope.refresh = function() {
			$scope.init();
		}
		$scope.getNumber = function(num) {
			return new Array(num);
		}
		$scope.distance = function(a, b) {
			if (a.length != b.length) return -1;
			var distance = 0;
			for (var i = 0; i < a.length; i++) {
				if (a[i] != b[i]) {
					distance++;
				}
			}
			return distance;
		}
		$scope.check = function() {
			var good = true;
			$scope.attempts.forEach(function(element, index, array) {
				if (index != 5 && element.length != 0 && array[index + 1].length == 0) {
					if ($scope.distance(element, $scope.end_word) != 1) {
						good = false;
					}
					return;
				}
				if (index == 0) {
					var a = $scope.start_word.slice(0);
					if ($scope.distance(a, element) != 1) {
						good = false;
					}
					return;
				}
				if ($scope.distance(element, array[index - 1]) != 1) {
					good = false;
					return;
				}
				if (index == array.length - 1) {
					if ($scope.distance(element, $scope.end_word) != 1) {
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
	}
]);