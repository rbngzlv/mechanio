class ServicePlan < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  belongs_to :make
  belongs_to :model
  belongs_to :model_variation

  before_save :set_make_and_model

  validates :quote, presence: true, numericality: true

  with_options if: :title_blank? do |service_plan|
    service_plan.validates :kms_travelled, :months, presence: true, numericality: { only_integer: true }
    service_plan.validates :kms_travelled, uniqueness: { scope: [:months, :model_variation_id] }
  end

  validates :title, presence: true, uniqueness: { scope: :model_variation_id }, unless: :title_blank?

  default_scope { order(:kms_travelled, :title) }
  scope :default, -> { where(model_variation_id: nil) }

  def display_title
    title_blank? ? "#{number_with_delimiter(kms_travelled)} kms / #{months} months" : title
  end

  def title_blank?
    title.blank?
  end

  def set_make_and_model
    self.make_id = model_variation.make_id if model_variation
    self.model_id = model_variation.model_id if model_variation
  end
end
