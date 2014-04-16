class Rating < ActiveRecord::Base

  MAX = 5

  belongs_to :user
  belongs_to :mechanic
  belongs_to :job

  validates :professional, :service_quality, :communication, :parts_quality, :convenience,
    presence: true, inclusion: { in: 1..MAX }

  default_scope { order created_at: :desc }

  def average
    (professional + service_quality + communication + parts_quality + convenience).to_f / MAX
  end
end
