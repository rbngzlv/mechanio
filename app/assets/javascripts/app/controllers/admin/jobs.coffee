app = angular.module('mechanio')

app.controller 'JobsController', ['$scope', '$http', ($scope, $http) ->

  $scope.init = (options) ->
    $scope[key] = value for key, value of options

  $scope.addTask = (type) ->
    $scope.job.tasks.push
      type: type, task_items: [], editing: true

  $scope.deleteTask = (task) ->
    task._destroy = true

  $scope.editingTask = (task) ->
    task.editing

  $scope.taskTemplate = (task) ->
    task.type.toLowerCase()

  $scope.hasService = ->
    (return true if task.type == 'Service') for task in $scope.job.tasks
    false

  $scope.onServicePlanChanged = (task) ->
    plan = p for p in $scope.service_plans when p.id == parseInt(task.service_plan_id)
    task.title = "Service: #{plan.display_title}" if plan

  $scope.addItem = (task, type) ->
    task.task_items.push
      itemable_type: type, itemable: {}

  $scope.deleteItem = (item) ->
    item._destroy = true

  $scope.itemTemplate = (item) ->
    item.itemable_type.underscore()
]
