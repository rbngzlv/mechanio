app = angular.module('mechanio.models')

app.factory 'Service', ['Task', (Task) ->

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
]
