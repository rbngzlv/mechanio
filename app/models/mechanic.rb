class Mechanic < ActiveRecord::Base

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  belongs_to :location, dependent: :destroy
  belongs_to :business_location, dependent: :destroy, class_name: "Location"
  has_many :jobs
  has_many :events
  has_many :mechanic_regions
  has_many :regions, through: :mechanic_regions

  accepts_nested_attributes_for :location
  accepts_nested_attributes_for :business_location, reject_if: :all_blank

  mount_uploader :avatar, AvatarUploader
  mount_uploader :driver_license, ImgUploader
  mount_uploader :abn, ImgUploader
  mount_uploader :mechanic_license, ImgUploader

  validates :first_name, :last_name, :email, :dob, :mobile_number, :location, presence: true
  validates :mobile_number, phone: true
  validates :business_mobile_number, phone: true, allow_blank: true
  validates :years_as_a_mechanic, numericality: { only_integer: true }, allow_blank: true
  validates :abn_number, format: { with: /\A\d{11}\Z/, message: 'ABN should be 11-digit number' }, allow_blank: true
  validates :driver_license_number, format: { with: /\A\d{8}\Z/, message: "Driver's License Number should be 8-digit number" }, allow_blank: true

  belongs_to :license_state, class_name: 'State'
  belongs_to :mechanic_license_state, class_name: 'State'

  delegate :geocoded?, to: :location, prefix: true, allow_nil: true

  scope :close_to, -> (latitude, longitude) {
    joins(:location).merge(Location.close_to(latitude, longitude))
  }
  scope :by_region, -> (postcode) {
    joins(:mechanic_regions).where(mechanic_regions: { postcode: postcode }).uniq
  }

  def appointments
    jobs.appointments
  end

  def past_appointments
    jobs.past_appointments
  end

  def self.by_location(location)
    if location.geocoded?
      close_to(location.latitude, location.longitude)
    else
      joins(:location).where(locations: { postcode: location.postcode })
    end
  end

  def build_locations
    build_location unless location
    build_business_location unless business_location
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

  def reviews
    # TODO: It must return count of comments about this mechanic
    12
  end

  def rating
    # TODO: It must return real rating
    2
  end

  include FakeHelper
  def comments
    # TODO: It must return collection of all mechanic reviews
    fake_comments
  end
end
