module Jobs
  module Common

    private

    def whitelist(params)
      params = ActionController::Parameters.new(params) unless params.is_a?(ActionController::Parameters)
      params.require(:job).permit(
        :car_id, :contact_email, :contact_phone,
        location_attributes:  [:address, :suburb_id, :postcode, :state_id],
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
      EstimateFollowupEmailService.schedule(job.id)
    end

    def notify_pending(job)
      AdminMailer.async.job_pending(job.id)
      UserMailer.async.job_pending(job.id)
    end

    def notify_estimated(job)
      AdminMailer.async.job_estimated(job.id)
      UserMailer.async.job_estimated(job.id)
    end

    def notify_quote_changed(job)
      AdminMailer.async.job_quote_changed(job.id)
      UserMailer.async.job_quote_changed(job.id)
    end
  end
end
