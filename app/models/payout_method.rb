class PayoutMethod < ActiveRecord::Base
  belongs_to :mechanic

  validates :account_name, :bsb_number, :account_number, presence: true
  validates :bsb_number, bsb_number: true
  validates :account_number, bank_account_number: true
end
