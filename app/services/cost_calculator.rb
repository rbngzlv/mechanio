class CostCalculator

  def initialize(job)
    @job = job
  end

  def set_job_cost
    tasks = @job.tasks.reject { |t| t.marked_for_destruction? }

    has_service = tasks.any? { |t| t.is_a?(Service) }
    has_inspection = false

    costs = tasks.map do |t|
      if t.is_a?(Inspection)
        t.cost = has_service || has_inspection ? 0 : Inspection::INSPECTION_COST
        has_inspection = true
        t.cost
      else
        t.cost = items_cost(t)
      end
    end

    @job.cost = costs.include?(nil) ? nil : costs.sum
    @job.cost = nil if @job.cost == 0
    @job.cost
  end


  private

  def items_cost(task)
    costs = task.task_items.map { |ti| ti.marked_for_destruction? ? 0 : ti.set_cost }
    cost = costs.include?(nil) ? nil : costs.sum
    cost = nil if cost == 0
    cost
  end
end
