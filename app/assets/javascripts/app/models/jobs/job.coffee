app = angular.module('mechanio.models')

app.factory 'Job', ['CostCalculator', 'Service', 'Repair', 'Inspection', (CostCalculator, Service, Repair, Inspection) ->
  class Job
    constructor: (attrs, @hourly_rate, @service_plans) ->
      @[key] = value for key, value of attrs when key != 'tasks'
      @tasks = attrs.tasks.map (t) => @create_task(t, hourly_rate, service_plans)

    create_task: (attrs, hourly_rate, service_plans) ->
      switch attrs.type
        when 'Service'    then new Service(attrs, this, hourly_rate, service_plans)
        when 'Repair'     then new Repair(attrs, this, hourly_rate, service_plans)
        when 'Inspection' then new Inspection(attrs, this, hourly_rate, service_plans)

    hasService: ->
      service = task for task in @tasks when task.isService() && !task.isDeleted()
      if service then true else false

    addTask: (type) ->
      attrs = { type: type, task_items: [], editing: true }
      @tasks.push @create_task(attrs, @hourly_rate, @service_plans)

    updateCost: ->
      cost_calculator = new CostCalculator
      cost_calculator.set_job_cost(this)

    total: ->
      @updateCost()
]
