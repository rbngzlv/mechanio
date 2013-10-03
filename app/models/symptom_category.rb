class SymptomCategory < ActiveRecord::Base

  has_many :symptoms

  validates :description, presence: true
end
