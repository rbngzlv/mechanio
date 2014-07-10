class Mechanic < ActiveRecord::Base

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :async

  extend Searchable
  include AccountSuspendable

  belongs_to :location, dependent: :destroy
  belongs_to :business_location, dependent: :destroy, class_name: "Location"
  has_many :jobs
  has_many :events
  has_many :mechanic_regions
  has_many :regions, through: :mechanic_regions
  has_many :payouts
  has_many :ratings, -> { where(published: true) }
  has_one :payout_method

  accepts_nested_attributes_for :location
  accepts_nested_attributes_for :business_location, reject_if: :all_blank

  mount_uploader :avatar, AvatarUploader
  mount_uploader :driver_license, DocumentUploader
  mount_uploader :abn, DocumentUploader
  mount_uploader :mechanic_license, DocumentUploader

  validates :first_name, :last_name, :email, :dob, :mobile_number, :location, presence: true
  validates :mobile_number, phone: true
  validates :business_mobile_number, phone: true, allow_blank: true
  validates :years_as_a_mechanic, numericality: { only_integer: true }, allow_blank: true
  validates :abn_number, format: { with: /\A\d{11}\Z/, message: 'ABN should be 11-digit number' }, allow_blank: true
  validates :driver_license_number, format: { with: /\A\d{8}\Z/, message: "Driver's License Number should be 8-digit number" }, allow_blank: true

  belongs_to :license_state, -> { states }, class_name: 'Region'
  belongs_to :mechanic_license_state, -> { states }, class_name: 'Region'

  delegate :geocoded?, to: :location, prefix: true, allow_nil: true

  scope :active, -> { where(suspended_at: nil) }
  scope :close_to, -> (latitude, longitude) {
    joins(:location).merge(Location.close_to(latitude, longitude))
  }
  scope :by_region, -> (postcode) {
    joins(:mechanic_regions).where(mechanic_regions: { postcode: postcode }).uniq
  }

  def self.search_fields
    [:first_name, :last_name, :email, :mobile_number]
  end

  def current_jobs
    jobs.assigned.includes(:user, :car, :tasks, location: [:suburb])
  end

  def past_jobs
    jobs.past.includes(:user, :car, :tasks, location: [:suburb])
  end

  def paid_jobs
    jobs.paid_out
  end

  def self.by_location(location)
    if location.geocoded?
      close_to(location.latitude, location.longitude)
    else
      joins(:location).where(locations: { postcode: location.postcode })
    end
  end

  def build_associations
    build_location          unless location
    build_business_location unless business_location
    build_payout_method     unless payout_method
  end

  def toggle_regions(region_ids, toggle)
    mechanic_regions.where(region_id: region_ids).delete_all
    MechanicRegion.bulk_insert(id, region_ids) if toggle
  end

  def region_ids
    mechanic_regions.pluck(:region_id)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def update_job_counters
    update_attributes(
      current_jobs_count: current_jobs.length,
      completed_jobs_count: past_jobs.length
    )
  end

  def update_earnings
    update_attributes(total_earnings: payouts.sum(:amount))
  end

  def update_rating
    averages = ratings.map(&:average)
    rating = averages.size > 0 ? averages.sum.to_f / averages.size : 0
    update_attribute(:rating, rating)
  end

  def available_at?(time)
    EventsManager.new(self).available_at?(time)
  end

  def event_feed(options = {})
    EventsManager.new(self).events_list(options).to_json
  end
end
