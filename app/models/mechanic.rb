class Mechanic < ActiveRecord::Base

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :last_name, :email, :dob, :street_address, :suburb,
    :state_id, :postcode, :driver_license, :license_state_id, :license_expiry, presence: true

  belongs_to :state
  belongs_to :license_state, class_name: 'State'

  def full_name
    "#{first_name} #{last_name}"
  end
end
