module Jobs
  class BookAppointment
    include ActiveModel::Validations

    attr_accessor :job, :mechanic, :scheduled_at

    validate :scheduled_in_future?
    validate :job_unassigned?
    validate :mechanic_available?

    def initialize(job, mechanic, scheduled_at)
      @job          = job
      @mechanic     = mechanic
      @scheduled_at = scheduled_at.to_time
    end

    def call
      return false unless valid?

      ActiveRecord::Base.transaction do

        appointment = Appointment.create!(
          job:          @job,
          user:         @job.user,
          mechanic:     @mechanic,
          scheduled_at: @scheduled_at
        )

        @job.update_attributes!(
          appointment:   appointment,
          mechanic:      mechanic,
          scheduled_at:  @scheduled_at,
          assigned_at:   DateTime.now
        )
        @job.assign!

        Event.create!(
          job:        @job,
          mechanic:   mechanic,
          date_start: @scheduled_at,
          time_start: @scheduled_at,
          time_end:   @scheduled_at + 2.hour
        )

        mechanic.update_job_counters
      end

      [AdminMailer, UserMailer, MechanicMailer].map do |mailer|
        mailer.async.job_assigned(@job.id)
      end

      true
    end


    private

    def scheduled_in_future?
      if @scheduled_at < Date.tomorrow
        errors[:base] << 'You can schedule an appointment for tomorrow or later'
      end
    end

    def job_unassigned?
      if @job.appointment.present?
        errors[:base] << 'This job is already assigned'
      end
    end

    def mechanic_available?
      unless EventsManager.new(@mechanic).available_at?(@scheduled_at)
        errors[:base] << 'This mechanic is unavailable on selected date'
      end
    end
  end
end
