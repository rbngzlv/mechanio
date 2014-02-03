class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2, :facebook]

  has_many :cars, -> { where deleted_at: nil }
  has_many :jobs
  has_many :credit_cards
  has_many :authentications, dependent: :destroy
  belongs_to :location, dependent: :destroy

  accepts_nested_attributes_for :location, reject_if: :all_blank

  mount_uploader :avatar, ImgUploader

  validates :first_name, :last_name, :email, presence: true

  def pending_and_estimated
    jobs.with_status(:pending, :estimated)
  end

  def estimates
    jobs.estimates
  end

  def appointments
    jobs.appointments
  end

  def past_appointments
    jobs.past_appointments
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if session[:tmp_job_id]
        attrs = Job.get_location_from_temporary(session[:tmp_job_id]) || {}
        attrs = ActionController::Parameters.new(attrs).permit(:address, :suburb, :postcode, :state_id)
        user.build_location(attrs)
      end
    end
  end

  def self.find_or_create_from_oauth(hash)
    unless user = User.find_by(email: hash['email'])
      user = User.create(
        first_name: hash['first_name'],
        last_name: hash['last_name'],
        email: hash['email'],
        remote_avatar_url: hash['image'],
        password: Devise.friendly_token[0,20]
      )
    end
    user
  end

  def location_attributes=(attrs)
    attrs[:skip_validation] = true
    super
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def avatar_thumb
    avatar_url(:thumb)
  end

  def reviews
    # TODO: It must return count of comments which this user left
    15
  end

  include FakeHelper
  def comments
    # TODO: It must return collection of all users comments
    fake_comments
  end
end
