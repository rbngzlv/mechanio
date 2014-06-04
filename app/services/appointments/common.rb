module Appointments
  module Common

    private

    def scheduled_in_future?
      if @scheduled_at < DateTime.tomorrow.in_time_zone
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
