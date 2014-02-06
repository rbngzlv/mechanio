class Authentication < ActiveRecord::Base
  PROVIDERS = { 'facebook' => 'Facebook', 'google_oauth2' => 'Gmail'}

  belongs_to :user
  validates :user_id, :uid, :provider, presence: true
  validates :uid, uniqueness: { scope: :provider }

  attr_accessor :error

  def self.connect(data, current_user)
    auth = find_auth(data)

    if auth && current_user
      auth.error = :already_connected
      return auth
    end

    unless auth
      user = current_user || find_user(data) || create_user(data)
      auth = create_auth(data, user)
    end

    unless auth.user.persisted?
      auth.error = :user_invalid
    end

    auth
  end

  def provider_name
    self.class.provider_name(provider)
  end

  def self.provider_name(provider)
    PROVIDERS[provider]
  end

  def self.find_auth(data)
    find_by(
      uid: data['uid'],
      provider: data['provider']
    )
  end

  def self.create_auth(data, user)
    create(
      user: user,
      uid: data['uid'],
      provider: data['provider'],
      email: data['info']['email']
    )
  end

  def self.find_user(data)
    User.find_by(email: data['info']['email'])
  end

  def self.create_user(data)
    User.create(
      email: data['info']['email'],
      first_name: data['info']['first_name'],
      last_name: data['info']['last_name'],
      remote_avatar_url: data['info']['image'],
      password: Devise.friendly_token[0, 20]
    )
  end
end
