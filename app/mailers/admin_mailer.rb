class AdminMailer < ActionMailer::Base
  def new_job(job)
    @job = job
    mail subject: 'New Job!', to: all_admins
  end

  def all_admins
    Admin.all.map(&:email)
  end
end
