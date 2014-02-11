class AppointmentService
  include ActiveModel::Validations

  attr_accessor :job, :scheduled_at, :mechanic_id

  validate :scheduled_in_future
  validate :mechanic_available

  def initialize(job, params)
    @job = job
    @scheduled_at = params[:scheduled_at].to_time
    @mechanic_id  = params[:mechanic_id]

    if @scheduled_at.blank? || @mechanic_id.blank?
      raise ArgumentError, "Invalid params passed: #{params.inspect}"
    end

    unless mechanic
      raise ArgumentError, "Mechanic with id #{@mechanic_id} not found"
    end
  end

  def confirm
    return false unless valid?

    @job.mechanic     = mechanic
    @job.scheduled_at = @scheduled_at
    @job.assigned_at  = DateTime.now

    @job.assign! && @job.save! && create_event && notify
  end

  def notify
    [AdminMailer, UserMailer, MechanicMailer].map do |mailer|
      mailer.job_assigned(@job.id).deliver
    end
  end


  private

  def mechanic
    @mechanic ||= Mechanic.where(id: @mechanic_id).first
  end

  def scheduled_in_future
    if @scheduled_at < Date.tomorrow
      errors[:base] << 'You can schedule an appointment for tomorrow or later'
    end
  end

  def mechanic_available
    schedule = EventsManager.new(mechanic)
    unless schedule.available_at?(@scheduled_at)
      errors[:base] << 'This mechanic is unavailable on selected date'
    end
  end

  def create_event
    @job.create_event!(
      date_start: @scheduled_at,
      time_start: @scheduled_at,
      time_end: @scheduled_at + 2.hour,
      mechanic: mechanic
    )
  end
end
