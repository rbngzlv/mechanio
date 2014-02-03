class Authentication < ActiveRecord::Base
  belongs_to :user
  validates :user_id, :uid, :provider, presence: true
  validates :uid, uniqueness: { scope: :provider }

  def self.find_or_create_from_oauth(hash)
    unless auth = find_by(provider: hash['provider'], uid: hash['uid'])
      user = User.find_or_create_from_oauth(hash['info'])
      auth = Authentication.create(user: user, uid: hash['uid'], provider: hash['provider'])
    end
    auth
  end
end
