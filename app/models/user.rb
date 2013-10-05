class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :cars
  has_many :jobs

  validates :first_name, presence: true
  validates :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def reviews
    # TODO: It must return count of comments which this user left
    15
  end

  def comments
    # TODO: It must return collection of all users comments
    [
      [
        'Mosaddek',
        'at Apr 14, 2013',
        'Ford Faicon',
        '1020',
        'Replace the engine',
        2,
        'Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam
        nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat
        volutpat. dolore magna aliquam erat volutpat. dolore magna aliquam erat
        volutpat.'
      ],
      [
        'Mosaddek',
        'at Apr 14, 2013',
        'Ford Faicon',
        '1020',
        'Replace the engine',
        2,
        'Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam
        nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat
        volutpat. dolore magna aliquam erat volutpat. dolore magna aliquam erat
        volutpat.'
      ]
    ]
  end
end
