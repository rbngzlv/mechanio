class Discount < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  extend Searchable

  DISCOUNT_TYPES = %w(amount percent)

  validates :title, :code, :discount_type, :discount_value, presence: true
  validates :discount_type, inclusion: { in: DISCOUNT_TYPES }
  validates :discount_value, numericality: true
  validates :uses_left, numericality: true, allow_nil: true

  before_validation :generate_code

  def self.search_fields
    [:title, :code]
  end

  def apply_discount(amount)
    amount - discount_amount(amount)
  end

  def discount_amount(amount)
    discount_type == 'percent' ? amount * discount_value / 100 : discount_value
  end

  def display_value
    if discount_type == 'percent'
      "#{discount_value.to_i}%"
    else
      number_to_currency(discount_value)
    end
  end

  def generate_code
    self.code ||= SecureRandom.hex(4)
  end
end
