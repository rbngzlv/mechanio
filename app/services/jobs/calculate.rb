module Jobs
  class Calculate

    def initialize(job)
      @job = job
    end

    def call
      @job.cost = @job.final_cost = sum_task_costs(@job.tasks)

      if @job.cost && @job.discount.present?
        @job.discount_amount = @job.discount.discount_amount(@job.cost)
        @job.final_cost = @job.cost - @job.discount_amount
      end
    end


    private

    def sum_task_costs(job_tasks)
      tasks = job_tasks.reject { |t| t.marked_for_destruction? }

      has_service     = tasks.any? { |t| t.is_a?(Service) }
      has_inspection  = false

      tasks.each do |task|
        if task.is_a?(Inspection)
          cost = has_service || has_inspection ? 0 : Inspection::INSPECTION_COST
          has_inspection = true
        else
          cost = sum_item_costs(task.task_items)
        end

        task.update_attribute(:cost, cost)
      end

      sum_costs tasks.map(&:cost)
    end

    def sum_item_costs(task_items)
      items = task_items.reject { |i| i.marked_for_destruction? }

      items.each do |item|
        item.set_cost
      end

      sum_costs items.map(&:cost)
    end

    def sum_costs(costs)
      cost = costs.include?(nil) ? nil : costs.sum
      cost = nil if cost == 0
      cost
    end
  end
end
