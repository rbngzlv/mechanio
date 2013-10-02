app = angular.module('mechanio')

app.controller 'DiagnoseController', ['$scope', '$http', ($scope, $http) ->
  $scope.service_plans = []
  $scope.service_plan = null

  $scope.init = (options) ->
    $scope[key] = value for key, value of options

    $scope.$watch 'params.car.model_variation_id', (new_value, old_value) ->
      if new_value != old_value
        $scope.service_plan = $scope.params.service_plan = null
        $scope.loadServicePlans(new_value)

  $scope.submit = ->
    $scope.params.service_plan = angular.copy($scope.service_plan)
    $scope.submitStep()

  $scope.loadServicePlans = (model_variation_id) ->
    $http.get('/ajax/service_plans', params: { model_variation_id: model_variation_id })
      .success (data) -> $scope.service_plans = data

  $scope.valid = ->
    $scope['diagnose_form'].$valid
]
