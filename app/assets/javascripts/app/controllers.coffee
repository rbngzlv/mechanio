app = angular.module('mechanio')

app.controller 'WizardController', ['$scope', '$http', ($scope, $http) ->
  $scope.steps = ['car-details', 'diagnose', 'contact', 'quote']
  $scope.step = $scope.steps[0]
  $scope.enabled_steps = []
  $scope.progress = 0

  $scope.job = {}
  $scope.job.location = {}
  $scope.car = {}
  $scope.model_variation = {}
  $scope.service_plan = null

  $scope.models = []
  $scope.model_variations = []
  $scope.service_plans = []

  $scope.postcode_regex = /^\d{4}$/
  $scope.phone_regex = /^[\+\(\)\d ]+$/

  $scope.gotoStep = (step) ->
    $scope.step = step if $scope.stepEnabled(step)

  $scope.submitStep = (step, next_step) ->
    $scope.enabled_steps.push(step) if $scope.enabled_steps.indexOf(step) == -1
    $scope.step = next_step
    $scope.progress = 100 / $scope.steps.length * $scope.enabled_steps.length

  $scope.stepVisible = (step) ->
    step == $scope.step

  $scope.stepEnabled = (step) ->
    $scope.enabled_steps.indexOf(step) != -1

  $scope.stepValid = (step) ->
    return false if $scope.steps.indexOf(step) == -1
    form = step.replace('-', '_') + '_form'
    $scope[form].$valid
    
  $scope.stepInvalid = (step) ->
    !$scope.stepValid(step)

  $scope.inputInvalid = (input) ->
    input.$dirty && input.$invalid && !input.$focused

  $scope.inputClass = (input) ->
    'has-error' if $scope.inputInvalid(input)

  $scope.stepClass = (step) ->
    return 'active' if step == $scope.step
    return 'done' if $scope.stepEnabled(step)

  $scope.loadModels = ->
    $http.get('/ajax/models', params: { make_id: $scope.car.make_id })
      .success (data) -> $scope.models = data

  $scope.loadModelVariations = ->
    if $scope.car.model_id
      $http.get('/ajax/model_variations', params: { model_id: $scope.car.model_id, year: $scope.car.year })
        .success (data) -> $scope.model_variations = data
    else
      $scope.model_variation = null

  $scope.loadServicePlans = ->
    $http.get('/ajax/service_plans', params: { model_variation_id: $scope.model_variation.id })
      .success (data) ->
        $scope.service_plans = data
]
