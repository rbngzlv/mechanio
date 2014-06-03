module Jobs
  class Convert
    include Common

    def call(id, user)
      job = Job.find_temporary(id)
      job.user_id = user.id
      job.update(whitelist(job.serialized_params))

      job.set_cost
      notify_new_job(job)
      job
    end
  end
end
