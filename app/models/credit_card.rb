class CreditCard < ActiveRecord::Base

  belongs_to :user

  validates :last_4, :token, presence: true
end
