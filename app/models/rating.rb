class Rating < ActiveRecord::Base
  extend Searchable

  MAX = 5

  belongs_to :user
  belongs_to :mechanic
  belongs_to :job

  before_save :set_text_fields

  validates :user, :mechanic, :job, presence: true
  validates :professional, :service_quality, :communication, :cleanness, :convenience,
    presence: true, inclusion: { in: 1..MAX }

  default_scope { order created_at: :desc }
  scope :published, -> { where published: true }

  def self.search_fields
    [:user_name, :mechanic_name, :job_title]
  end

  def average
    (professional + service_quality + communication + cleanness + convenience).to_f / MAX
  end

  def set_text_fields
    self.user_name      = user.full_name
    self.mechanic_name  = mechanic.full_name
    self.job_title      = job.title
  end
end
