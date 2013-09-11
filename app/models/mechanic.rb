class Mechanic < ActiveRecord::Base

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :last_name, :email, :dob, :street_address, :suburb,
    :state_id, :postcode, :driver_license, :license_state_id, :license_expiry, presence: true

  belongs_to :state
  belongs_to :license_state, class_name: 'State'

  after_create :registration_email

  def full_name
    "#{first_name} #{last_name}"
  end

  protected

  def registration_email
    MechanicMailer::registration_note(self).deliver
  end
end
