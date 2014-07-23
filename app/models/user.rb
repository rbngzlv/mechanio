class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :async,
         :omniauthable, omniauth_providers: [:google_oauth2, :facebook]

  extend Searchable
  include AccountSuspendable

  has_many :cars, -> { where deleted_at: nil }
  has_many :jobs, dependent: :nullify
  has_many :credit_cards
  has_many :authentications, dependent: :destroy
  has_many :ratings
  has_many :sent_invitations, class_name: 'Invitation', foreign_key: :sender_id
  has_one :invitation
  belongs_to :location, dependent: :destroy
  belongs_to :referrer, class_name: 'User', foreign_key: :referred_by

  accepts_nested_attributes_for :location, reject_if: :all_blank

  mount_uploader :avatar, AvatarUploader

  validates :first_name, :last_name, :email, presence: true
  validates :password, confirmation: true

  before_create :generate_referrer_code

  def self.search_fields
    [:first_name, :last_name, :mobile_number]
  end

  def pending_and_estimated_jobs
    jobs.with_status(:pending, :estimated).includes(:car, :tasks)
  end

  def estimated_jobs
    jobs.estimated
  end

  def current_jobs
    jobs.assigned.includes(:mechanic, :car, :tasks, :rating, location: [:suburb])
  end

  def past_jobs
    jobs.past.includes(:mechanic, :car, :rating)
  end

  def unrated_jobs
    jobs.unrated
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

  def generate_referrer_code
    code = SecureRandom.hex(4) while !code || User.where(referrer_code: code).exists?
    self.referrer_code = code
  end
end
