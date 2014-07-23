class Invitation < ActiveRecord::Base

  belongs_to :user
  belongs_to :sender, class_name: 'User', foreign_key: :sender_id

  validates :email, presence: true
  validates :user, presence: true, if: :completed?


  def completed?
    accepted_at.present?
  end
end
