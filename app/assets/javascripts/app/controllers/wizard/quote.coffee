app = angular.module('mechanio')

app.controller 'QuoteController', ['$scope', '$http', ($scope, $http) ->
  $scope.total    = false
  $scope.error    = false

  $scope.loading  = true
  $scope.loading_text = 'Waiting for your quote...'

  $scope.$on 'quote_step.enter', ->
    $scope.finalize()
    $scope.saveJob($scope.onSuccess, $scope.onError)

  $scope.init = ->
    if $scope.job_id
      $scope.finalize()
      $scope.enableStep('quote')
      $scope.gotoStep('quote')
      $scope.loadJob($scope.onLoad, $scope.onError)

  $scope.onLoad = (data) ->
    $scope.onSuccess(data)
    $scope.data.tasks = data.tasks
    $scope.data.car = data.car
    $scope.data.location = data.location
    $scope.setProgress(100)

  $scope.onSuccess = (data) ->
    $scope.total = data.cost if data.cost
    $scope.loading = false

  $scope.onError = ->
    $scope.error = true
    $scope.loading = false
]
