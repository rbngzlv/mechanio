class PayoutMethod < ActiveRecord::Base
  belongs_to :mechanic

  validates :account_name, :bsb_number, :account_number, :mechanic, presence: true
  validates :bsb_number, numericality: { integer_only: true }, length: { maximum: 6 }
  validates :account_number, format: { with: /\A\d+\Z/, message: 'should be digits only' }
end
