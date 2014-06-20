app = angular.module('mechanio')

app.controller 'DeleteEstimateController', ['$scope', ($scope) ->

  $scope.id = null
  $scope.reason = null
  $scope.reason_other = null

  $scope.validateOther = ->
    $scope.reason == 'other'
]
