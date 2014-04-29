class Make < ActiveRecord::Base

  has_many :models

  validates :name, presence: true

  default_scope { order(:name) }
end
