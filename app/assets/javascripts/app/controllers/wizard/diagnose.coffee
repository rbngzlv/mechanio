app = angular.module('mechanio')

app.controller 'DiagnoseController', ['$scope', '$http', ($scope, $http) ->
  $scope.mode = 'service'
  $scope.service_plans = []
  $scope.service_plan = {}
  $scope.note = ''
  $scope.symptoms = []
  $scope.problem_description = ''

  $scope.$on 'cars_step.car_changed', (e, args...) ->
    $scope.service_plan = null
    $scope.data.tasks = []
    $scope.loadServicePlans(args[0]) if args[0]

  $scope.init = (options = {}) ->
    $scope[key] = value for key, value of options

  $scope.submit = ->
    tasks = []

    if $scope.service_plan
      tasks.push {
        type: 'Service',
        service_plan_id: $scope.service_plan.id,
        title: $scope.service_plan.display_title,
        note: $scope.note
      }

    if $scope.repairValid()
      tasks.push {
        type: 'Repair',
        title: 'Diagnose car problem',
        symptom_ids: $scope.symptomIds(),
        note: $scope.problem_description
      }

    $scope.data.tasks = tasks
    $scope.submitStep()

  $scope.loadServicePlans = (model_variation_id) ->
    $http.get('/ajax/service_plans.json', params: { model_variation_id: model_variation_id })
      .success (data) -> $scope.service_plans = data

  $scope.serviceButtonLabel = ->
    if $scope.service_plan then 'Edit Service' else 'Add Service'

  $scope.symptomIds = ->
    for k, v of $scope.symptoms when v then parseInt(k)

  $scope.repairValid = ->
    !!$scope.symptomIds().length || !!$scope.problem_description

  $scope.valid = ->
    $scope['service_form'].$valid || $scope.repairValid()
]
