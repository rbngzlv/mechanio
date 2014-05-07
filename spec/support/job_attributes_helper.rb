module JobAttributesHelper

  def verify_job(rows)
    rows.each_with_index do |value, i|
      page.should have_css "tr:nth-child(#{i + 1})", text: value
    end
  end

  def create_temporary_job
    service = JobService.new
    service.create_job(nil, job: job_attributes)
  end

  def job_attributes
    attributes_for(:job).merge({
      location_attributes: location_attributes,
      car_attributes: car_attributes,
      tasks_attributes: [service_attributes, repair_attributes, inspection_attributes]
    })
  end

  def pending_job_attributes
    attributes_for(:job).merge({
      location_attributes: location_attributes,
      car_attributes: car_attributes,
      tasks_attributes: [pending_repair_attributes]
    })
  end

  def invalid_job_attributes
    attributes_for(:job).merge({
      car_attributes: car_attributes,
      tasks_attributes: [repair_attributes]
    })
  end


  def car_attributes
    { year: '2000', model_variation_id: create(:model_variation).id, last_service_kms: '10000' }
  end

  def location_attributes
    attributes_for(:location, state_id: create(:state).id)
  end

  def service_attributes
    attributes_for(:service, service_plan_id: create(:service_plan).id)
  end

  def repair_attributes
    attributes_for(:repair, task_items_attributes: [
      attributes_for(:task_item, itemable_type: 'Labour', itemable_attributes: attributes_for(:labour)),
      attributes_for(:task_item, itemable_type: 'Part', itemable_attributes: attributes_for(:part)),
      attributes_for(:task_item, itemable_type: 'FixedAmount', itemable_attributes: attributes_for(:fixed_amount))
    ])
  end

  def inspection_attributes
    attributes_for(:inspection)
  end

  def pending_repair_attributes
    attributes_for(:repair)
  end
end
