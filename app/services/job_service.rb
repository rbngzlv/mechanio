class JobService

  def create_job(user = nil, params)
    user ? create(user, params) : create_temporary(params)
  end

  def convert_from_temporary(id, user)
    job = Job.find_temporary(id)
    job.user_id = user.id
    job.update(whitelist(job.serialized_params))

    job.set_cost
    notify_new_job(job)
    job
  end

  def update_job(job, params)
    return false unless job.update(whitelist(params))

    job.set_cost

    if job.quote_available? && job.quote_changed?
      notify_quote_changed(job)
      schedule_followup_email(job)
    end

    job
  end


  private

  def create(user, params)
    job = Job.create(whitelist(params).merge(user: user))

    job.set_cost
    notify_new_job(job)
    job
  end

  def create_temporary(params)
    job = build_temporary(whitelist(params))
    raise ActiveRecord::RecordInvalid, job unless job.valid?

    job = build_temporary(serialized_params: params)
    job.save(validate: false)
    job
  end

  def build_temporary(params)
    job = Job.new(params)
    job.skip_user_validation = true
    job.car.skip_user_validation = true if job.car
    job.status = 'temporary'
    job
  end

  def whitelist(params)
    params = ActionController::Parameters.new(params) unless params.is_a?(ActionController::Parameters)
    params.require(:job).permit(
      :car_id, :contact_email, :contact_phone,
      location_attributes:  [:address, :suburb, :postcode, :state_id],
      car_attributes:       [:id, :year, :model_variation_id, :last_service_kms, :last_service_date],
      tasks_attributes:     [:id, :type, :service_plan_id, :note, :title, :description, :_destroy,
        task_items_attributes: [:id, :itemable_type, :_destroy,
          itemable_attributes: [:description, :name, :unit_cost, :quantity, :duration_hours, :duration_minutes, :cost]
        ]
      ]
    )
  end

  def notify_new_job(job)
    if job.quote_available?
      job.estimate
      notify_estimated(job)
      schedule_followup_email(job)
    else
      notify_pending(job)
    end
  end

  def schedule_followup_email(job)
    EstimateFollowupEmailService.schedule(job)
  end

  def notify_pending(job)
    AdminMailer.job_pending(job.id).deliver
    UserMailer.job_pending(job.id).deliver
  end

  def notify_estimated(job)
    AdminMailer.job_estimated(job.id).deliver
    UserMailer.job_estimated(job.id).deliver
  end

  def notify_quote_changed(job)
    AdminMailer.job_quote_changed(job.id).deliver
    UserMailer.job_quote_changed(job.id).deliver
  end
end
