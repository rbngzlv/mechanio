class Symptom < ActiveRecord::Base

  belongs_to :symptom_category

  validates :description, presence: true
end
