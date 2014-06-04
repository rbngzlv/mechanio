module Appointments
  class Reschedule
    include ActiveModel::Validations
    include Common

    validate :scheduled_in_future?
    validate :mechanic_available?

    def initialize(job, scheduled_at)
      @job          = job
      @mechanic     = @job.mechanic
      @scheduled_at = scheduled_at.in_time_zone
    end

    def call
      return false unless valid?

      ActiveRecord::Base.transaction do
        @job.appointment.update(scheduled_at: @scheduled_at)

        @job.update(scheduled_at: @scheduled_at)

        @job.event.update(
          date_start: @scheduled_at,
          time_start: @scheduled_at,
          time_end:   @scheduled_at + 2.hour
        )
      end

      send_notifications

      true
    end


    private

    def send_notifications
      # TODO: send some email notifications here
    end
  end
end
