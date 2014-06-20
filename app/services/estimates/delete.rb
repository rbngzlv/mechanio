module Estimates
  class Delete

    def initialize(job)
      @job = job
    end

    def call(params)
      @job.delete_reason        = params[:delete_reason]
      @job.delete_reason_other  = params[:delete_reason_other]
      @job.estimate_deleted_at  = Time.now.in_time_zone

      return false unless @job.delete_estimate!

      AdminMailer.async.estimate_deleted(@job.id)
    end
  end
end
