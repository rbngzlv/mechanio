app = angular.module('mechanio')

app.controller 'JobsController', ['$scope', '$http', 'Job', ($scope, $http, Job) ->

  $scope.job
  $scope.service_plans

  $scope.init = (options) ->
    $scope[key] = value for key, value of options when key != 'job'
    $scope.job = new Job(options.job, $scope.hourly_rate, $scope.service_plans)

  $scope.saveDisabled = ->
    $scope.job.final_cost < 0
]
