app = angular.module('mechanio')

app.controller 'ContactController', ['$scope', ($scope) ->
  $scope.job = {}
  $scope.location = {}

  $scope.postcode_regex = /^\d{4}$/
  $scope.phone_regex = /^[\+\(\)\d ]+$/

  $scope.submit = ->
    $scope.data.job = angular.copy($scope.job)
    $scope.data.location = angular.copy($scope.location)

    if $scope.authorized()
      $scope.submitStep()
    else
      $scope.authorize()

  $scope.valid = ->
    $scope['contact_form'].$valid
]
