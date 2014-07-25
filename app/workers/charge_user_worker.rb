class ChargeUserWorker
  @queue = :payment

  def self.enqueue(job_id)
    Resque.enqueue(ChargeUserWorker, job_id)
  end

  def self.perform(job_id)
    job = Job.find(job_id)

    Jobs::ChargeUser.new(job).call
  end
end
