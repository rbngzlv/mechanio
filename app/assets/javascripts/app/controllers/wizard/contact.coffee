app = angular.module('mechanio')

app.controller 'ContactController', ['$scope', ($scope) ->
  $scope.job = {}
  $scope.location = {}

  $scope.states = []
  $scope.state

  $scope.postcode_regex = /^\d{4}$/
  $scope.phone_regex = /^[\+\(\)\d ]+$/

  $scope.submit = ->
    $scope.data.job = angular.copy($scope.job)
    $scope.data.location = angular.copy($scope.location)
    $scope.data.location.state_id = $scope.state.id
    $scope.data.location.state_name = $scope.state.name

    if $scope.authorized()
      $scope.submitStep()
    else
      $scope.saveJob()
      $scope.authorize()

  $scope.valid = ->
    $scope['contact_form'].$valid
]
