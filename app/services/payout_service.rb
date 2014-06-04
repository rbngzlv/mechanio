class PayoutService

  def initialize(mechanic, job)
    @mechanic = mechanic
    @job = job
  end

  def record_payout(attrs)
    data = attrs.merge(mechanic: @mechanic, job: @job)

    if attrs[:id].present?
      payout = @mechanic.payouts.find(attrs[:id])
      payout.update(data)
      payout
    else
      payout = Payout.create(data)
    end

    if payout && payout.valid?
      @mechanic.update_earnings
    end

    payout
  end
end
