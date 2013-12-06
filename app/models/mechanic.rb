class Mechanic < ActiveRecord::Base

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  belongs_to :location, dependent: :destroy
  belongs_to :business_location, dependent: :destroy, class_name: "Location"
  has_many :jobs

  accepts_nested_attributes_for :location
  accepts_nested_attributes_for :business_location, reject_if: :all_blank

  mount_uploader :avatar, ImgUploader
  mount_uploader :driver_license, ImgUploader
  mount_uploader :abn, ImgUploader
  mount_uploader :mechanic_license, ImgUploader

  validates :first_name, :last_name, :email, :dob, :location, presence: true

  belongs_to :license_state, class_name: 'State'
  belongs_to :mechanic_license_state, class_name: 'State'

  scope :close_to, -> (latitude, longitude) {
    joins(:location).merge(Location.close_to(latitude, longitude))
  }

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

  def socials
    # TODO: It must return collection of socials connections
    fake_socials
  end
end
