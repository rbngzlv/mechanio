app = angular.module('mechanio')

app.controller 'WizardController', ['$scope', '$http', ($scope, $http) ->
  $scope.user_id = null
  $scope.job_id = null

  $scope.steps = ['car-details', 'diagnose', 'contact', 'quote']
  $scope.step = $scope.steps[0]
  $scope.enabled_steps = []
  $scope.progress = 0
  $scope.data = {}

  $scope.$on 'bounce', (e, bounce, args...) ->
    $scope.$broadcast(bounce, args...)

  $scope.init = (options = {}) ->
    $scope[key] = value for key, value of options

  $scope.gotoStep = (step) ->
    $scope.step = step if $scope.stepEnabled(step)

  $scope.submitStep = ->
    $scope.enableStep($scope.step)
    $scope.updateProgress()
    if step = $scope.findNextStep()
      $scope.step = step
      $scope.$broadcast("#{step}_step.enter")

  $scope.findNextStep = ->
    index = $scope.steps.indexOf($scope.step)
    $scope.steps[index + 1]

  $scope.enableStep = (step) ->
    $scope.enabled_steps.push(step) unless $scope.stepEnabled(step)

  $scope.stepVisible = (step) ->
    step == $scope.step

  $scope.stepEnabled = (step) ->
    $scope.enabled_steps.indexOf(step) != -1
    
  $scope.inputInvalid = (input) ->
    input.$dirty && input.$invalid && !input.$focused

  $scope.inputClass = (input) ->
    'has-error' if $scope.inputInvalid(input)

  $scope.stepClass = (step) ->
    return 'active' if step == $scope.step
    return 'done' if $scope.stepEnabled(step)

  $scope.updateProgress = ->
    $scope.progress = 100 / ($scope.steps.length - 1) * $scope.enabled_steps.length

  $scope.setProgress = (progress) ->
    $scope.progress = progress

  $scope.finalize = ->
    $scope.enabled_steps = []

  $scope.authorized = ->
    angular.isNumber($scope.user_id)

  $scope.authorize = ->
    angular.element('#login-modal').modal('show')

  $scope.saveJob = (success = false, error = false) ->
    params = $scope.data.job
    params.location_attributes = $scope.data.location
    params.tasks_attributes = $scope.data.tasks

    if $scope.data.car.id
      params.car_id = $scope.data.car.id
    else
      params.car_attributes = { year: $scope.data.car.year, model_variation_id: $scope.data.car.model_variation_id }

    $http.post('/users/jobs', { job: params })
      .success (data) ->
        success(data) if success
      .error (data) ->
        error() if error

  $scope.loadJob = (success, error) ->
    $http.get('/users/jobs/' + $scope.job_id)
      .success (data) ->
        success(data) if success
      .error (data) ->
        error() if error
]
