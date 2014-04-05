class Discount < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  DISCOUNT_TYPES = %w(amount percent)

  validates :title, :code, :discount_type, :discount_value, presence: true
  validates :discount_type, inclusion: { in: DISCOUNT_TYPES }
  validates :discount_value, numericality: true
  validates :uses_left, numericality: true, allow_nil: true

  def apply_discount(amount)
    if discount_type == 'percent'
      amount - (amount * discount_value / 100)
    else
      amount - discount_value
    end
  end

  def display_value
    if discount_type == 'percent'
      "#{discount_value.to_i}%"
    else
      number_to_currency(discount_value)
    end
  end
end
