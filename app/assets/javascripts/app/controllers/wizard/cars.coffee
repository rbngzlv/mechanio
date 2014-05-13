app = angular.module('mechanio')

app.controller 'CarsController', ['$scope', '$http', ($scope, $http) ->
  $scope.car = {}

  $scope.last_service_month
  $scope.last_service_year

  $scope.cars = []
  $scope.models = []
  $scope.model_variations = []

  $scope.adding_vehicle = true
  $scope.no_results_alert = false

  $scope.init = (options = {}) ->
    $scope[key] = value for key, value of options
    $scope.adding_vehicle = $scope.cars.length == 0

  $scope.setYear = ->
    $scope.loadModelVariations()

  $scope.setMake = ->
    $http.get('/ajax/models.json', params: { make_id: $scope.car.make_id })
      .success (data) ->
        $scope.models = data
        $scope.no_results_alert = (data.length == 0)

    $scope.car.model_id = null
    $scope.car.model_variation_id = null
    $scope.model_variations = []

  $scope.setModel = ->
    $scope.loadModelVariations()

  $scope.setModelVariation = ->
    if $scope.car.model_variation_id
      variation = (v for v in $scope.model_variations when v.id is +$scope.car.model_variation_id)[0]
      $scope.car.id = null
      $scope.car.display_title = "#{$scope.car.year} #{variation.display_title}"
      $scope.notifyCarChanged()

  $scope.setCar = ->
    car = (c for c in $scope.cars when c.id is +$scope.car.id)[0]
    $scope.car.model_variation_id = car.model_variation_id
    $scope.car.display_title      = car.display_title
    $scope.notifyCarChanged()

  $scope.notifyCarChanged = ->
    $scope.$emit 'bounce', 'cars_step.car_changed', $scope.car.model_variation_id

  $scope.loadModelVariations = ->
    if $scope.car.model_id
      $http.get('/ajax/model_variations.json', params: { model_id: $scope.car.model_id, year: $scope.car.year })
        .success (data) ->
          $scope.model_variations = data
          $scope.no_results_alert = (data.length == 0)

  $scope.valid = ->
    valid_car = $scope.car.id || $scope.car.model_variation_id
    valid_car && ($scope.validLastServiceDate() || $scope.validLastServiceKms())

  $scope.validLastServiceKms = ->
    $scope.car.last_service_kms >= 5000

  $scope.invalidLastServiceKms = ->
    $scope.car.last_service_kms && !$scope.validLastServiceKms()

  $scope.validLastServiceDate = ->
    date = $scope.lastServiceDate()
    date && date.isValid() && date.isBefore(moment())

  $scope.lastServiceDate = ->
    return false if $scope.last_service_year < 1980
    moment(new Date($scope.last_service_year, $scope.last_service_month - 1, 1))

  $scope.submit = ->
    date = $scope.lastServiceDate()
    $scope.data.car = angular.copy($scope.car)
    $scope.data.car.last_service_date = date.format() if date
    $scope.submitStep()
]
