class Model < ActiveRecord::Base

  belongs_to :make

  has_many :model_variations

  validates :name, :make, presence: true

  default_scope { order(:name) }

  def self.to_options(params)
    return [] if params.empty?
    where(params).pluck(:id, :name).map { |i| ({ value: i[0], label: i[1] }) }
  end
end
