module Appointments
  class Book
    include ActiveModel::Validations
    include Common

    attr_accessor :job, :mechanic, :scheduled_at

    validate :scheduled_in_future?
    validate :job_unassigned?
    validate :mechanic_available?

    def initialize(job, mechanic, scheduled_at)
      @job          = job
      @mechanic     = mechanic
      @scheduled_at = scheduled_at.in_time_zone
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

      send_notifications

      true
    end


    private

    def send_notifications
      [AdminMailer, UserMailer, MechanicMailer].map do |mailer|
        mailer.async.job_assigned(@job.id)
      end
    end
  end
end
