app = angular.module('mechanio.models')

app.factory 'CostCalculator', ->
  class CostCalculator
    set_job_cost: (job) ->
      has_service = job.hasService()
      has_inspection = false

      totals = for t in job.tasks when !t.isDeleted()
        t.cost = if t.type == 'Inspection'
          cost = if has_service || has_inspection then 0 else t.inspection_cost()
          has_inspection = true
          cost
        else
          @task_cost(t)

      job.cost = if totals.length == 0 || 'pending' in totals
        'pending'
      else
        totals.reduce (a, b) -> a + b

    task_cost: (task) ->
      totals = for i in task.task_items when !i.isDeleted()
        if i.total() == 'pending' then 'pending' else parseFloat(i.total())

      return 'pending' if totals.length == 0 || 'pending' in totals
      totals.reduce (a, b) -> a + b
