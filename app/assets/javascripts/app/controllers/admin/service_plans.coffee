app = angular.module('mechanio')

app.controller 'ServicePlansController', ['$scope', '$http', ($scope, $http) ->

  $scope.year
  $scope.make_id
  $scope.model_id
  $scope.model_variation

  $scope.models = []
  $scope.model_variations = []
  $scope.service_plans = []

  $scope.init = (variation) ->
    return unless variation.id
    $scope.year = variation.from_year
    $scope.make_id = variation.make_id
    $scope.model_id = variation.model_id
    $scope.model_variation = variation
    $scope.loadModels()
    $scope.loadModelVariations()
    $scope.loadServicePlans()

  $scope.loadModels = ->
    $scope.no_variations = false
    $http.get('/ajax/models.json', params: { make_id: $scope.make_id })
      .success (data) -> $scope.models = data

  $scope.loadModelVariations = ->
    $scope.no_variations = false
    return unless $scope.model_id
    $http.get('/ajax/model_variations.json', params: { year: $scope.year, model_id: $scope.model_id })
      .success (data) ->
        $scope.model_variations = data
        $scope.no_variations = true if data.length == 0
        if $scope.model_variation && $scope.model_variation.id
          $scope.model_variation = (v for v in data when v.id == $scope.model_variation.id)[0]

  $scope.loadServicePlans = ->
    $scope.no_variations = false
    $http.get('/ajax/service_plans.json', params: { model_variation_id: $scope.model_variation.id })
      .success (data) -> $scope.service_plans = data
]
