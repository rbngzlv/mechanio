app = angular.module('mechanio.models')

app.factory 'Task', ['CostCalculator','FixedAmount', 'Labour', 'ServiceCost', 'Part', (CostCalculator, FixedAmount, Labour, ServiceCost, Part) ->
  class Task
    constructor: (attrs, @job, @hourly_rate, @service_plans) ->
      @[key] = value for key, value of attrs
      @task_items = attrs.task_items.map (i) => @create_item(i, @hourly_rate)

    create_item: (attrs, hourly_rate) ->
      switch attrs.itemable_type
        when 'FixedAmount'  then new FixedAmount(attrs)
        when 'Labour'       then new Labour(attrs, hourly_rate)
        when 'ServiceCost'  then new ServiceCost(attrs)
        when 'Part'         then new Part(attrs)

    template: ->
      @type.toLowerCase()

    isService: ->
      @type == 'Service'

    isDeleted: ->
      @_destroy == true

    hasLabour: ->
      labour = item for item in @task_items when item.itemable_type == 'Labour' && !item.isDeleted()
      if labour then true else false

    delete: ->
      @_destroy = true

    isEditing: ->
      @editing == true

    edit: ->
      @editing = true

    doneEditing: ->
      @editing = false

    addItem: (type) ->
      item = @create_item(itemable_type: type, itemable: {}, @hourly_rate)
      @task_items.push(item)
      item

    total: ->
      @job.updateCost()
      @cost
]
