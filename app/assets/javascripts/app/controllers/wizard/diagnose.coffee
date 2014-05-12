app = angular.module('mechanio')

app.controller 'DiagnoseController', ['$scope', '$http', ($scope, $http) ->
  $scope.mode = 'service'
  $scope.service_plans = []
  $scope.service_plan = {}
  $scope.symptoms = []
  $scope.questions = []
  $scope.selected_symptoms = []
  $scope.note = ''
  $scope.repair_description = ''

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
    attrs = {
      type:         'Inspection',
      description:  $scope.repair_description,
      note:         $scope.note
    }

    if $scope.selected_symptoms[1]
      attrs.title       = $scope.selected_symptoms[1].description
      attrs.description = $scope.lastSymptom().comment

    unless attrs.title || $scope.editingRepair()
      attrs.title       = 'Inspection'

    $scope.updateTask(attrs)

  $scope.updateTask = (task) ->
    if $scope.editing_task == null
      if task.type == 'Service' then $scope.tasks.unshift(task) else $scope.tasks.push(task)
    else
      $scope.tasks[$scope.editing_task][k] = v for k, v of task
    $scope.note = ''
    $scope.repair_description = ''
    $scope.backToSummary()

  $scope.removeTask = (i) ->
    is_service = !!($scope.tasks[i].type == 'Service')
    $scope.service_plan = {} if is_service
    $scope.tasks.splice(i, 1)

    if $scope.tasks.length == 0
      $scope.mode = if is_service then 'service' else 'repair'

  $scope.editTask = (i) ->
    $scope.editing_task = i
    task = $scope.tasks[i]
    if task.type == 'Service'
      $scope.service_plan = sp for sp in $scope.service_plans when sp.id == task.service_plan_id
      $scope.mode = 'service'
    else
      $scope.mode = 'repair'
    $scope.note = task.note
    $scope.repair_description = task.description

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
    switch $scope.mode
      when 'review'  then $scope.submit()
      when 'service' then $scope.saveService()
      when 'repair'  then $scope.saveRepair()

  $scope.continueEnabled = ->
    switch $scope.mode
      when 'review'  then $scope.valid()
      when 'service' then !!($scope.service_plan && $scope.service_plan.id)
      when 'repair'
        return true unless $scope.editing_task == null
        symptom_selected = !!($scope.lastSymptom() && $scope.lastSymptom().comment)
        !!(symptom_selected || $scope.repair_description)


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
