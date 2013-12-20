class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :cars, -> { where deleted_at: nil }
  has_many :jobs
  has_many :credit_cards
  has_many :authorizations, dependent: :delete_all
  belongs_to :location, dependent: :destroy

  accepts_nested_attributes_for :location, reject_if: :all_blank

  mount_uploader :avatar, ImgUploader

  validates :first_name, :last_name, :email, presence: true

  def self.new_with_session(params, session)
    super.tap do |user|
      if session[:tmp_job_id]
        attrs = Job.get_location_from_temporary(session[:tmp_job_id]) || {}
        attrs = ActionController::Parameters.new(attrs).permit(:address, :suburb, :postcode, :state_id)
        user.build_location(attrs)
      end
    end
  end

  def self.create_from_hash!(hash)
    user = User.find_by_email(hash['email'])
    unless user.present?
      user = new(
        email: hash['email'],
        first_name: hash['first_name'],
        last_name: hash['last_name'],
        remote_avatar_url: hash['image']
      )
      user.save validate: false
    end
    user
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data["email"]).first
    unless user
      user = User.create(
        first_name: data['first_name'],
        last_name: data['last_name'],
        email: data["email"],
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

  def estimates
    jobs.with_status(:pending, :estimated)
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

  def socials
    # TODO: It must return collection of socials connections
    fake_socials
  end
end
