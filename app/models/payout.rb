class Payout < ActiveRecord::Base
  belongs_to :job
  belongs_to :mechanic

  validates :account_name, :account_number, :bsb_number, :amount, :transaction_id, presence: true
  validates :bsb_number, bsb_number: true
  validates :account_number, bank_account_number: true
end
