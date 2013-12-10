class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :cars, -> { where deleted_at: nil }
  has_many :jobs
  has_many :credit_cards

  mount_uploader :avatar, ImgUploader

  validates :first_name, :last_name, :email, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def estimates
    jobs.with_status(:pending, :estimated)
  end

  def add_credit_card(params)
    @result = if braintree_customer_id
      braintree_client.create_card(params, braintree_customer_id)
    else
      customer_params = { first_name: first_name, last_name: last_name, email: email }
      braintree_client.create_customer_with_card(customer_params, params)
    end

    if @result.success?
      card = @result.respond_to?(:customer) ? @result.customer.credit_cards.last : @result.credit_card
      update_attribute(:braintree_customer_id, card.customer_id)
      credit_cards.create(last_4: card.last_4, token: card.token, braintree_customer_id: card.customer_id)
    else
      false
    end
  end

  def braintree_client
    @client ||= BraintreeClient.new
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
