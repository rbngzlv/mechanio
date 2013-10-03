app = angular.module('mechanio')

app.controller 'WizardController', ['$scope', '$http', ($scope, $http) ->
  $scope.user_id = null

  $scope.steps = ['car-details', 'diagnose', 'contact', 'quote']
  $scope.step = $scope.steps[0]
  $scope.enabled_steps = []
  $scope.progress = 0
  $scope.params = {}

  $scope.init = (options = {}) ->
    $scope[key] = value for key, value of options

  $scope.gotoStep = (step) ->
    $scope.step = step if $scope.stepEnabled(step)

  $scope.submitStep = ->
    $scope.enableStep($scope.step)
    $scope.progress = 100 / $scope.steps.length * $scope.enabled_steps.length

    next_step = $scope.findNextStep()

    if next_step == 'quote' && !$scope.user_id
      $scope.authorize()
    else
      $scope.step = next_step

  $scope.findNextStep = ->
    index = $scope.steps.indexOf($scope.step)
    $scope.steps[index + 1]

  $scope.enableStep = (step) ->
    $scope.enabled_steps.push($scope.step) unless $scope.stepEnabled($scope.step)

  $scope.stepVisible = (step) ->
    step == $scope.step

  $scope.stepEnabled = (step) ->
    $scope.enabled_steps.indexOf(step) != -1
    
  $scope.authorize = ->
    angular.element('#login-modal').modal('show')

  $scope.inputInvalid = (input) ->
    input.$dirty && input.$invalid && !input.$focused

  $scope.inputClass = (input) ->
    'has-error' if $scope.inputInvalid(input)

  $scope.stepClass = (step) ->
    return 'active' if step == $scope.step
    return 'done' if $scope.stepEnabled(step)
]
