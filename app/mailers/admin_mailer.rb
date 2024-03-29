class AdminMailer < ActionMailer::Base
  extend AsyncMailer::Mailer

  def job_pending(job_id)
    @job = Job.find(job_id)
    mail subject: 'New pending job', to: all_admins
  end

  def job_estimated(job_id)
    @job = Job.find(job_id)
    mail subject: 'Job estimated', to: all_admins
  end

  def job_assigned(job_id)
    @job = Job.find(job_id)
    mail subject: 'Job assigned', to: all_admins
  end

  def job_quote_changed(job_id)
    @job = Job.find(job_id)
    mail subject: 'Job quote updated', to: all_admins
  end

  def job_completed(job_id)
    @job = Job.find(job_id)
    mail subject: "Job #{@job.uid} has been completed", to: all_admins
  end

  def job_rated(job_id)
    @job = Job.find(job_id)
    mail subject: "Job #{@job.uid} has been rated", to: all_admins
  end

  def estimate_deleted(job_id)
    @job = Job.find(job_id)
    mail subject: 'A customer has deleted an estimate', to: all_admins
  end

  def payment_error(job_id)
    @job = Job.find(job_id)
    mail subject: "Error processing payment for job #{@job.uid}", to: all_admins
  end

  def payment_success(job_id)
    @job = Job.find(job_id)
    mail subject: "Payment for job #{@job.uid} processed succesfully", to: all_admins
  end


  def all_admins
    Admin.all.map(&:email)
  end
end
