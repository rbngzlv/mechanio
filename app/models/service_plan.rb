class ServicePlan < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  belongs_to :make
  belongs_to :model
  belongs_to :model_variation
  has_many :tasks, dependent: :nullify

  before_save :set_make_and_model, :set_display_title

  validates :cost, presence: true, numericality: true

  with_options if: :title_blank? do |service_plan|
    service_plan.validates :kms_travelled, :months, presence: true, numericality: { only_integer: true }
    service_plan.validates :kms_travelled, uniqueness: { scope: [:months, :model_variation_id] }
  end

  validates :title, presence: true, uniqueness: { scope: :model_variation_id }, unless: :title_blank?

  default_scope { order(:kms_travelled, :title) }
  scope :default, -> { where(model_variation_id: nil) }

  def set_display_title
    self.display_title = title_blank? ? "#{number_with_delimiter(kms_travelled)} kms / #{months} months" : title
  end

  def title_blank?
    title.blank?
  end

  def set_make_and_model
    if model_variation
      self.make_id = model_variation.make_id
      self.model_id = model_variation.model_id
    end
  end

  def self.to_options(params)
    options = where(model_variation_id: params[:model_variation_id]).pluck(:id, :display_title).map do |s|
      { id: s[0], display_title: s[1] }
    end
  end
end
