app = angular.module('mechanio')

app.controller 'CarsController', ['$scope', '$http', ($scope, $http) ->
  $scope.cars = {}
  $scope.cars_count = 0
  $scope.models = []
  $scope.model_variations = []
  $scope.adding_vehicle = true
  $scope.no_results_alert = false

  $scope.car = {}
  $scope.model_variation = {}

  $scope.init = (options) ->
    $scope[key] = value for key, value of options
    $scope.cars_count += 1 for c of $scope.cars
    $scope.adding_vehicle = $scope.cars_count == 0

    # $scope.car = {
    #   year: '2000',
    #   make_id: '90'
    # }    

  $scope.setYear = ->
    $scope.loadModelVariations()

  $scope.setMake = ->
    $http.get('/ajax/models', params: { make_id: $scope.car.make_id })
      .success (data) ->
        $scope.models = data
        $scope.no_results_alert = (data.length == 0)

    $scope.car.model_id = null
    $scope.car.model_variation_id = null
    $scope.model_variations = []
    $scope.model_variation = {}

  $scope.setModel = ->
    $scope.loadModelVariations()

  $scope.setModelVariation = ->
    $scope.car.id = null
    if $scope.model_variation
      $scope.car.model_variation_id = $scope.model_variation.id
      $scope.car.display_title = "#{$scope.car.year} #{$scope.model_variation.display_title}"
    else
      $scope.car.model_variation_id = null
      $scope.car.display_title = null

  $scope.loadModelVariations = ->
    if $scope.car.model_id
      $http.get('/ajax/model_variations', params: { model_id: $scope.car.model_id, year: $scope.car.year })
        .success (data) ->
          $scope.model_variations = data
          $scope.no_results_alert = (data.length == 0)
    else
      $scope.model_variation = null

  $scope.setCar = ->
    c = $scope.cars[$scope.car.id]
    $scope.car.id                 = c.id
    $scope.car.model_variation_id = c.model_variation_id
    $scope.car.display_title      = c.display_title

  $scope.valid = ->
    $scope.car.id || $scope.car.model_variation_id

  $scope.submit = ->
    $scope.params.car = angular.copy($scope.car)
    $scope.submitStep()
]
