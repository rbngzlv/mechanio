module JobAttributesHelper

  def create_temporary_job
    job = Job.new(status: :temporary, serialized_params: { job: job_attributes })
    job.save(validate: false)
    job
  end

  def job_attributes
    attributes_for(:job).merge({
      location_attributes: attributes_for(:location, state_id: create(:state).id),
      tasks_attributes: [
        attributes_for(:service, service_plan_id: create(:service_plan).id),
        attributes_for(:repair, task_items_attributes: [
          attributes_for(:task_item, itemable_type: 'Labour', itemable_attributes: attributes_for(:labour))
        ])
      ],
      car_attributes: { year: '2000', model_variation_id: create(:model_variation).id, last_service_kms: '10000' }
    })
  end
end
