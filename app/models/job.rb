class Job < ActiveRecord::Base

  belongs_to :user
  belongs_to :car
  belongs_to :service_plan
  has_one :location, as: :locatable

  accepts_nested_attributes_for :car, :location

  validates :car, :service_plan, :location, :contact_email, :contact_phone, presence: true
end
