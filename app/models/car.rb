class Car < ActiveRecord::Base
  belongs_to :user
  belongs_to :model_variation

  has_many :jobs

  before_save :set_display_title

  validates :model_variation, :year, presence: true
  validates :user, presence: true, unless: :skip_user_validation
  validates :year, year: true
  validates :last_service_kms, numericality: true, allow_blank: true
  validates :vin, format: { with: /\A\d{17}\Z/, message: 'VIN should be 17-digit number' }, allow_blank: true
  validate :verify_last_service

  attr_accessor :skip_user_validation

  delegate :service_plans, to: :model_variation

  def set_display_title
    self.display_title = "#{year} #{model_variation.display_title}"
  end

  def verify_last_service
    errors[:last_service_kms] << 'Enter either kms or date' if last_service_kms.blank? && last_service_date.blank?
  end

  def destroy
    if check_jobs
      self.deleted_at = Time.now
      save
    end
  end

  private

  def check_jobs
    jobs.each do |job|
      if [:pending, :estimated, :assigned].include?(job.status.to_sym)
        errors[:active_jobs] << 'Cannot delete a car that has active jobs.'
        return false
      end
    end
  end
end
