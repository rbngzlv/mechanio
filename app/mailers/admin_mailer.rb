class AdminMailer < AsyncMailer

  def job_pending(job)
    @job = job
    mail subject: 'New pending job', to: all_admins
  end

  def job_estimated(job)
    @job = job
    mail subject: 'Job estimated', to: all_admins
  end

  def job_assigned(job)
    @job = job
    mail subject: 'Job assigned', to: all_admins
  end

  def job_quote_changed(job)
    @job = job
    mail subject: 'Job quote updated', to: all_admins
  end

  def all_admins
    Admin.all.map(&:email)
  end
end
