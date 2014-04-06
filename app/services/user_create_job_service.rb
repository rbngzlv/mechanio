class UserCreateJobService

  def initialize(user, params)
    @user   = user
    @params = params
  end

  def create_job
    @user ? create : create_temporary
  end

  def convert_from_temporary(id)
    job = Job.find_temporary(id)
    job.user_id = @user.id
    job.update(whitelist(job.serialized_params))
    job
  end


  private

  def create
    Job.create(whitelist(@params).merge(user: @user))
  end

  def create_temporary
    job = build_temporary(whitelist(@params))
    raise ActiveRecord::RecordInvalid, job unless job.valid?

    job = build_temporary(serialized_params: @params)
    job.save(validate: false)
    job
  end

  def build_temporary(params)
    job = Job.new(params)
    job.skip_user_validation = true
    job.car.skip_user_validation = true if job.car
    job.status = :temporary
    job
  end

  def whitelist(params)
    params = ActionController::Parameters.new(params) unless params.is_a?(ActionController::Parameters)
    params.require(:job).permit(
      :car_id, :contact_email, :contact_phone,
      location_attributes:  [:address, :suburb, :postcode, :state_id],
      car_attributes:       [:id, :year, :model_variation_id, :last_service_kms, :last_service_date],
      tasks_attributes:     [:type, :service_plan_id, :note, :title, :description,
        task_items_attributes: [:itemable_type,
          itemable_attributes: [:description, :name, :unit_cost, :quantity, :duration_hours, :duration_minutes, :cost]
        ]
      ]
    )
  end
end
