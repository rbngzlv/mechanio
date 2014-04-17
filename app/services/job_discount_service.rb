class JobDiscountService
  include ActiveModel::Validations

  validate :discount_found?
  validate :discount_available?
  validate :discount_active?

  def initialize(job, discount_code)
    @job            = job
    @user           = job.user
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

  def discount_available?
    return false unless @discount

    if no_uses_left? || already_used?
      errors[:base] << 'This discount code was already used'
    end
  end

  def no_uses_left?
    @discount.uses_left != nil && @discount.uses_left == 0
  end

  def already_used?
    @user && @user.jobs.where(discount_id: @discount.id).exists?
  end

  def discount_active?
    return false unless @discount

    valid = @discount.starts_at.nil? || @discount.starts_at < Time.now
    valid = valid && (@discount.ends_at.nil? || @discount.ends_at > Time.now)
    errors[:base] << 'This discount code is not active' unless valid
  end
end
