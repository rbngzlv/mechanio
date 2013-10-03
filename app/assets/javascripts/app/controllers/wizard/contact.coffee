app = angular.module('mechanio')

app.controller 'ContactController', ['$scope', '$http', ($scope, $http) ->
  $scope.job = {}
  $scope.job.location = {}

  $scope.postcode_regex = /^\d{4}$/
  $scope.phone_regex = /^[\+\(\)\d ]+$/

  $scope.init = (options = {}) ->
    $scope[key] = value for key, value of options

    $scope.job = {
      contact_email: 'email@host.com',
      contact_phone: '123 123124'
    }
    $scope.job.location = {
      address: 'Street address',
      suburb: 'Suburb',
      postcode: '1212',
      state_id: '17'
    }

  $scope.submit = ->
    $scope.params.job = angular.copy($scope.job)
    $scope.submitStep()

  $scope.valid = ->
    $scope['contact_form'].$valid
]
