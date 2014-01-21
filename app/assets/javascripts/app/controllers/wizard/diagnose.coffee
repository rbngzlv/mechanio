app = angular.module('mechanio')

app.controller 'DiagnoseController', ['$scope', '$http', ($scope, $http) ->
  $scope.mode = 'service'
  $scope.service_plans = []
  $scope.service_plan = {}
  $scope.note = ''
  $scope.symptoms = []
  $scope.selected_symptoms = {}
  $scope.problem_description = ''

  $scope.tasks = []
  $scope.editing_task = null

  $scope.$on 'cars_step.car_changed', (e, args...) ->
    $scope.service_plan = null
    $scope.data.tasks = []
    $scope.loadServicePlans(args[0]) if args[0]

  $scope.init = (options = {}) ->
    $scope[key] = value for key, value of options

  $scope.saveService = ->
    service =
      type: 'Service',
      service_plan_id: $scope.service_plan.id,
      title: "#{$scope.service_plan.display_title} service",
      note: $scope.note
    $scope.updateTask(service)

  $scope.saveRepair = ->
    last = s for k, s of $scope.selected_symptoms
    repair = {
      type: 'Inspection',
      title: 'Inspection',
      note: last.comment
    }
    $scope.resetSelectedSymptoms()
    $scope.updateTask(repair)

  $scope.updateTask = (task) ->
    if $scope.editing_task == null
      if task.type == 'Service'
        $scope.tasks.unshift task
      else
        $scope.tasks.push task
    else
      $scope.tasks[$scope.editing_task] = task
    $scope.editing_task = null
    $scope.mode = 'review'

  $scope.editTask = (i) ->
    $scope.editing_task = i
    $scope.mode = if $scope.tasks[i].type == 'Service' then 'service' else 'repair'

  $scope.submit = ->
    $scope.data.tasks = $scope.tasks
    $scope.submitStep()

  $scope.loadServicePlans = (model_variation_id) ->
    $http.get('/ajax/service_plans.json', params: { model_variation_id: model_variation_id })
      .success (data) -> $scope.service_plans = data

  $scope.findService = ->
    service = task for task in $scope.tasks when task.type == 'Service'

  $scope.hasService = ->
    if $scope.findService() then true else false

  $scope.repairValid = ->
    !!$scope.symptomIds().length || !!$scope.problem_description

  $scope.valid = ->
    $scope.tasks.length > 0

  $scope.resetSelectedSymptoms = ->
    $scope.selected_symptoms = {}

  $scope.isParent = (symptom) ->
    symptom.parent_ids.length == 0

  $scope.childrenOf = (parent) ->
    (symptom) ->
      parent.id in symptom.parent_ids

  $scope.hasChildren = (parent) ->
    children = s for s in $scope.symptoms when parent.id in s.parent_ids
    if children then true else false
]
