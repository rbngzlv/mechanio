app = angular.module('mechanio')

app.controller 'QuoteController', ['$scope', '$http', ($scope, $http) ->
  $scope.total    = false
  $scope.error    = false
  $scope.loading  = true

  $scope.$on 'quote_step.enter', ->
    $scope.finalize()
    $scope.saveJob()

  $scope.saveJob = ->
    params = $scope.data.job
    params.location_attributes = $scope.data.location
    params.tasks_attributes = $scope.data.tasks

    if $scope.data.car.id
      params.car_id = $scope.data.car.id
    else
      params.car_attributes = { year: $scope.data.car.year, model_variation_id: $scope.data.car.model_variation_id }

    $http.post('/users/jobs', { job: params })
      .success (data) ->
        if angular.isNumber(data.id)
          $scope.total = data.total if data.total
        else
          $scope.error = true
        $scope.loading = false
      .error (data) ->
        $scope.error = true
        $scope.loading = false
]
