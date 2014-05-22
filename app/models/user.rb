class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2, :facebook]

  extend Searchable
  include AccountSuspendable

  has_many :cars, -> { where deleted_at: nil }
  has_many :jobs, dependent: :nullify
  has_many :credit_cards
  has_many :authentications, dependent: :destroy
  has_many :ratings
  belongs_to :location, dependent: :destroy

  accepts_nested_attributes_for :location, reject_if: :all_blank

  mount_uploader :avatar, AvatarUploader

  validates :first_name, :last_name, :email, presence: true

  def self.search_fields
    [:first_name, :last_name, :mobile_number]
  end

  def pending_and_estimated_jobs
    jobs.with_status(:pending, :estimated)
  end

  def estimated_jobs
    jobs.estimated
  end

  def current_jobs
    jobs.assigned
  end

  def past_jobs
    jobs.completed
  end

  def unrated_jobs
    jobs.unrated
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
end
