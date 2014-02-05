class Authentication < ActiveRecord::Base
  PROVIDERS = { 'facebook' => 'Facebook', 'google_oauth2' => 'Gmail'}

  belongs_to :user
  validates :user_id, :uid, :provider, presence: true
  validates :uid, uniqueness: { scope: :provider }

  def self.find_or_create_from_oauth(hash, signed_in_resource = nil)
    unless auth = find_by(provider: hash['provider'], uid: hash['uid'])
      user = signed_in_resource || User.find_or_create_from_oauth(hash['info'])
      auth = create(user: user, uid: hash['uid'], provider: hash['provider'], email: hash['info']['email'])
    else
      return false if signed_in_resource
    end
    auth
  end

  def provider_name
    self.class.provider_name(provider)
  end

  def self.provider_name(provider)
    PROVIDERS[provider]
  end
end
