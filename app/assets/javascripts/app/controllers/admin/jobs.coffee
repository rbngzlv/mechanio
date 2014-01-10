app = angular.module('mechanio')

class Itemable
  constructor: (attrs) ->
    @[key] = value for key, value of attrs

  template: ->
    @itemable_type.underscore()

  delete: ->
    @_destroy = true

  isDeleted: ->
    @_destroy == true

class FixedAmount extends Itemable
  total: ->
    @itemable.cost

class Labour extends Itemable
  constructor: (attrs, hourly_rate) ->
    super
    @itemable.duration_hours   ||= 0
    @itemable.duration_minutes ||= 0
    @itemable.hourly_rate      ||= hourly_rate

  total: ->
    @duration() * @itemable.hourly_rate / 60

  duration: ->
    hours = +@itemable.duration_hours || 0
    minutes = +@itemable.duration_minutes || 0
    hours * 60 + minutes

class ServiceCost extends Itemable
  total: ->
    @itemable.cost

class Part extends Itemable
  total: ->
    @itemable.quantity * @itemable.unit_cost

class ItemFactory
  @create: (attrs, hourly_rate) ->
    switch attrs.itemable_type
      when 'FixedAmount'  then new FixedAmount(attrs)
      when 'Labour'       then new Labour(attrs, hourly_rate)
      when 'ServiceCost'  then new ServiceCost(attrs)
      when 'Part'         then new Part(attrs)

calculateTotals = (items) ->
  totals = (parseFloat(i.total()) for i in items when !i.isDeleted())
  return 'pending' if totals.length == 0 || 0 in totals || 'pending' in totals
  totals.reduce (a, b) -> a + b

class Task
  constructor: (attrs, @hourly_rate, @service_plans) ->
    @[key] = value for key, value of attrs
    @task_items = attrs.task_items.map (i) -> ItemFactory.create(i, @hourly_rate)

  total: ->
    calculateTotals(@task_items)

  template: ->
    @type.toLowerCase()

  isService: ->
    @type == 'Service'

  isDeleted: ->
    @_destroy == true

  delete: ->
    @_destroy = true

  isEditing: ->
    @editing == true

  edit: ->
    @editing = true

  doneEditing: ->
    @editing = false

  addItem: (type) ->
    item = ItemFactory.create(itemable_type: type, itemable: {}, @hourly_rate)
    @task_items.push(item)
    item

class Service extends Task
  heading: ->
    @title || 'Service'

  find_or_create_service_cost: ->
    item = i for i in @task_items when i.itemable_type == 'ServiceCost'
    item ||= @addItem('ServiceCost')

  doneEditing: ->
    service_plan = sp for sp in @service_plans when sp.id == parseInt(@service_plan_id)

    item = @find_or_create_service_cost()
    item.itemable.cost = service_plan.cost
    item.itemable.description = service_plan.display_title

    @title = "#{service_plan.display_title} service"
    super

class Repair extends Task
  heading: ->
    @title || 'Repair'

class TaskFactory
  @create: (attrs, hourly_rate, service_plans) ->
    switch attrs.type
      when 'Service'  then new Service(attrs, hourly_rate, service_plans)
      when 'Repair'   then new Repair(attrs, hourly_rate, service_plans)

class Job
  constructor: (attrs, @hourly_rate, @service_plans) ->
    @[key] = value for key, value of attrs when key != 'tasks'
    @tasks = attrs.tasks.map (t) -> TaskFactory.create(t, hourly_rate, service_plans)

  hasService: ->
    service = task for task in @tasks when task.isService() && !task.isDeleted()
    if service then true else false

  addTask: (type) ->
    task = { type: type, task_items: [], editing: true }
    @tasks.push TaskFactory.create(task, @hourly_rate, @service_plans)

  total: ->
    calculateTotals(@tasks)


app.controller 'JobsController', ['$scope', '$http', ($scope, $http) ->

  $scope.job
  $scope.service_plans

  $scope.init = (options) ->
    $scope[key] = value for key, value of options when key != 'job'
    $scope.job = new Job(options.job, $scope.hourly_rate, $scope.service_plans)
]
