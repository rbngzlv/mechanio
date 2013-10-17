app = angular.module('mechanio')

app.controller 'JobsController', ['$scope', '$http', ($scope, $http) ->

  $scope.init = (job) ->
    $scope.job = job

  $scope.addTask = (type) ->
    $scope.job.tasks.push
      type: type, task_items: []

  $scope.deleteTask = (task) ->
    task._destroy = true

  $scope.editingTask = (task) ->
    task.editing || !task.title

  $scope.taskTemplate = (task) ->
    task.type.toLowerCase()

  $scope.hasService = ->
    (return true if task.type == 'Service') for task in $scope.job.tasks
    false

  $scope.addItem = (task, type) ->
    task.task_items.push
      itemable_type: type, itemable: {}

  $scope.deleteItem = (item) ->
    item._destroy = true

  $scope.itemTemplate = (item) ->
    item.itemable_type.underscore()
]
