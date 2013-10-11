class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :cars
  has_many :jobs

  mount_uploader :avatar, ImgUploader

  validates :first_name, :last_name, :email, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def estimates
    jobs.with_status(:pending, :estimated)
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
