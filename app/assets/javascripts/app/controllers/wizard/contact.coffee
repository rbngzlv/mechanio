app = angular.module('mechanio')

app.controller 'ContactController', ['$scope', ($scope) ->
  $scope.job = {}
  $scope.location = {}

  $scope.states = []
  $scope.state = {}

  $scope.postcode_regex = /^\d{4}$/
  $scope.phone_regex = /^04\d{8}$/

  $scope.init = (options = {}) ->
    $scope[key] = value for key, value of options
    state_id = options.location.state_id
    $scope.state = state for state in $scope.states when state.id == state_id
    $scope.job.contact_email = $scope.contact.contact_email
    $scope.job.contact_phone = $scope.contact.contact_phone

  $scope.submit = ->
    $scope.data.job = angular.copy($scope.job)
    $scope.data.location = angular.copy($scope.location)
    $scope.data.location.state_id = $scope.state.id
    $scope.data.location.state_name = $scope.state.name

    if $scope.authorized()
      $scope.submitStep()
    else
      $scope.loading = true
      $scope.saveJob($scope.onSave, $scope.onError)

  $scope.onSave = ->
    $scope.loading = false
    $scope.authorize()

  $scope.onError = ->
    $scope.loading = false
    $scope.error = true

  $scope.valid = ->
    $scope['contact_form'].$valid
]
