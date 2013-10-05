app = angular.module('mechanio')

app.controller 'DiagnoseController', ['$scope', '$http', ($scope, $http) ->
  $scope.service_plans = []
  $scope.service_plan = null

  $scope.$on 'cars_step.car_changed', (e, args...) ->
    $scope.service_plan = null
    $scope.data.tasks = []
    $scope.loadServicePlans(args[0]) if args[0]

  $scope.submit = ->
    tasks = []
    tasks.push {
      type: 'Service',
      service_plan_id: $scope.service_plan.id,
      title: $scope.service_plan.display_title,
      note: $scope.note
    }
    $scope.data.tasks = tasks
    $scope.submitStep()

  $scope.loadServicePlans = (model_variation_id) ->
    $http.get('/ajax/service_plans', params: { model_variation_id: model_variation_id })
      .success (data) -> $scope.service_plans = data

  $scope.valid = ->
    $scope['diagnose_form'].$valid
]
