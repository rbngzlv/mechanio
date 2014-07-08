class ChargeUserWorker
  @queue = :payment

  def self.enqueue(user_id, job_id)
    Resque.enqueue(ChargeUserWorker, user_id, job_id)
  end

  def self.perform
    Payments::ChargeUser.new.call(user_id, job_id)
  end
end
