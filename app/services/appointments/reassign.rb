module Appointments
  class Reassign
    include ActiveModel::Validations
    include Common

    validate :scheduled_in_future?
    validate :job_assigned?
    validate :mechanic_available?

    def initialize(job, mechanic, scheduled_at)
      @job          = job
      @mechanic     = mechanic
      @scheduled_at = scheduled_at.in_time_zone
    end

    def call
      return false unless valid?

      ActiveRecord::Base.transaction do
        previous_mechanic = @job.mechanic

        @job.appointment.update!(
          mechanic:     @mechanic,
          scheduled_at: @scheduled_at
        )

        @job.event.update!(
          mechanic:   @mechanic,
          date_start: @scheduled_at,
          time_start: @scheduled_at,
          time_end:   @scheduled_at + 2.hour
        )

        @job.update!(
          mechanic:      @mechanic,
          scheduled_at:  @scheduled_at,
          assigned_at:   DateTime.now
        )

        @mechanic.update_job_counters
        previous_mechanic.update_job_counters
      end

      send_notifications

      true
    end


    private

    def send_notifications
      UserMailer.async.job_reassigned(@job.id)
      MechanicMailer.async.job_assigned(@job.id)
    end
  end
end
