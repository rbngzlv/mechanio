app = angular.module('mechanio')

app.controller 'DiagnoseController', ['$scope', '$http', ($scope, $http) ->
  $scope.mode = 'service'
  $scope.service_plans = []
  $scope.service_plan = {}
  $scope.note = ''
  $scope.symptoms = []
  $scope.questions = []
  $scope.selected_symptoms = []
  $scope.problem_description = ''

  $scope.tasks = []
  $scope.editing_task = null

  $scope.$on 'cars_step.car_changed', (e, args...) ->
    $scope.resetServicePlans(args[0])

  $scope.init = (options = {}) ->
    $scope[key] = value for key, value of options
    $scope.questions = $scope.symptoms

  $scope.saveService = ->
    $scope.updateTask
      type: 'Service',
      service_plan_id: $scope.service_plan.id,
      title: "#{$scope.service_plan.display_title} service",
      note: $scope.note
    $scope.service_plan = {}

  $scope.saveRepair = ->
    if $scope.editing_task
      $scope.updateTask
        note: $scope.problem_description
    else
      $scope.updateTask
        type: 'Inspection',
        title: $scope.selected_symptoms[1].description,
        description: $scope.lastSymptom().comment
        note: $scope.problem_description

  $scope.updateTask = (task) ->
    if $scope.editing_task == null
      if task.type == 'Service'
        $scope.tasks.unshift task
      else
        $scope.tasks.push task
    else
      $scope.tasks[$scope.editing_task][k] = v for k, v of task
    $scope.backToSummary()

  $scope.removeTask = (i) ->
    $scope.tasks.splice(i, 1)
    $scope.mode = 'service' if $scope.tasks.length == 0

  $scope.editTask = (i) ->
    $scope.editing_task = i
    $scope.mode = if $scope.tasks[i].type == 'Service' then 'service' else 'repair'

  $scope.addingRepair = ->
    $scope.editing_task == null && $scope.mode == 'repair'

  $scope.editingRepair = ->
    $scope.editing_task != null && $scope.mode == 'repair'

  $scope.saveButtonLabel = ->
    if $scope.editing_task == null then 'Add' else 'Update'

  $scope.goBack = ->
    if $scope.mode == 'review' || $scope.tasks.length == 0
      $scope.gotoStep("car-details")
    else
      $scope.backToSummary()

  $scope.backToSummary = ->
    $scope.resetDiagnostics()
    $scope.editing_task = null
    $scope.mode = 'review'

  $scope.continue = ->
    return $scope.submit() if $scope.mode == 'review'

    if $scope.mode == 'service'
      $scope.saveService()
    else if $scope.mode == 'repair'
      $scope.saveRepair()

  $scope.continueEnabled = ->
    return $scope.valid() if $scope.mode == 'review'

    if $scope.mode == 'service'
      return !!($scope.service_plan && $scope.service_plan.id)

    if $scope.mode == 'repair'
      if $scope.editing_task == null
        !!($scope.lastSymptom() && $scope.lastSymptom().comment)
      else
        true

  $scope.continueLabel = ->
    if $scope.mode == 'review'
      'Continue'
    else
      if $scope.editing_task == null then 'Add' else 'Update'

  $scope.submit = ->
    $scope.data.tasks = $scope.tasks
    $scope.submitStep()

  $scope.resetServicePlans = (model_variation_id = null) ->
    $scope.service_plan = null
    $scope.data.tasks = []
    $scope.loadServicePlans(model_variation_id) if model_variation_id

  $scope.loadServicePlans = (model_variation_id) ->
    $http.get('/ajax/service_plans.json', params: { model_variation_id: model_variation_id })
      .success (data) -> $scope.service_plans = data

  $scope.hasService = ->
    for task in $scope.tasks
      return task if task.type == 'Service'
    false

  $scope.repairValid = ->
    !!$scope.selected_symptoms.length || !!$scope.problem_description

  $scope.valid = ->
    $scope.tasks.length > 0

  $scope.addSymptom = (symptom) ->
    $scope.selected_symptoms.push(symptom)
    $scope.questions = symptom.children

  $scope.lastSymptom = ->
    l = $scope.selected_symptoms.length
    $scope.selected_symptoms[l - 1]

  $scope.resetDiagnostics = ->
    $scope.selected_symptoms = []
    $scope.questions = $scope.symptoms
]
