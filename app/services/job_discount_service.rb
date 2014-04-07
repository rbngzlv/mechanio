class JobDiscountService
  include ActiveModel::Validations

  validate :discount_found?
  validate :discount_uses_available?
  validate :discount_active?

  def initialize(job, discount_code)
    @job            = job
    @discount_code  = discount_code
    @discount       = Discount.find_by(code: discount_code)
  end

  def apply_discount
    return false unless valid?

    ActiveRecord::Base.transaction do
      @job.update_column(:discount_id, @discount.id)

      # save job to trigger #set_cost
      @job.save unless @job.status.to_sym == :temporary

      unless @discount.uses_left.nil?
        @discount.uses_left -= 1
        @discount.save
      end
    end

    true
  end


  private

  def discount_found?
    unless @discount
      errors[:base] << 'Discount code is invalid'
    end
  end

  def discount_uses_available?
    return false unless @discount

    if @discount.uses_left != nil && @discount.uses_left == 0
      errors[:base] << 'This discount code was already used'
    end
  end

  def discount_active?
    return false unless @discount

    valid = @discount.starts_at.nil? || @discount.starts_at < Time.now
    valid = valid && (@discount.ends_at.nil? || @discount.ends_at > Time.now)
    errors[:base] << 'This discount code is not active' unless valid
  end
end
