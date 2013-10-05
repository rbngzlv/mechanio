app = angular.module('mechanio')

app.controller 'DiagnoseController', ['$scope', '$http', ($scope, $http) ->
  $scope.service_plans = []
  $scope.service_plan = null
  $scope.task_type = null

  $scope.$on 'cars_step.car_changed', (e, args...) ->
    $scope.service_plan = $scope.data.service_plan = null
    $scope.loadServicePlans(args[0]) if args[0]

  $scope.submit = ->
    $scope.data.service_plan = angular.copy($scope.service_plan)
    $scope.submitStep()

  $scope.loadServicePlans = (model_variation_id) ->
    $http.get('/ajax/service_plans', params: { model_variation_id: model_variation_id })
      .success (data) -> $scope.service_plans = data

  $scope.valid = ->
    $scope['diagnose_form'].$valid
]
