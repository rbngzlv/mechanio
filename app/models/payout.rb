class Payout < ActiveRecord::Base
  belongs_to :job
  belongs_to :mechanic

  mount_uploader :receipt, ReceiptUploader

  validates :account_name, :account_number, :bsb_number, :amount, :transaction_id, :receipt, presence: true
  validates :bsb_number, bsb_number: true
  validates :account_number, bank_account_number: true
end
