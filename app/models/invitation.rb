class Invitation < ActiveRecord::Base

  belongs_to :user

  validates :email, :user, presence: true
end
