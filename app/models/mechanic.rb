class Mechanic < ActiveRecord::Base

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  has_one :location, -> { where location_type: 'location' },
          as: :locatable, dependent: :destroy, autosave: true
  has_one :business_location, -> { where location_type: 'business_location' }, class_name: "Location",
          as: :locatable, dependent: :destroy, autosave: true

  accepts_nested_attributes_for :location
  accepts_nested_attributes_for :business_location, reject_if: :all_blank

  mount_uploader :avatar, ImgUploader
  mount_uploader :driver_license, ImgUploader
  mount_uploader :abn, ImgUploader
  mount_uploader :mechanic_license, ImgUploader

  validates :first_name, :last_name, :email, :dob, :location, presence: true

  belongs_to :license_state, class_name: 'State'
  belongs_to :mechanic_license_state, class_name: 'State'

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
