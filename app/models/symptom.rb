class Symptom < ActiveRecord::Base

  has_many :symptom_hierarchies
  has_many :children, through: :symptom_hierarchies

  has_many :parent_hierarchies, class_name: 'SymptomHierarchy', foreign_key: :child_id
  has_many :parents, through: :parent_hierarchies

  validates :description, presence: true

  def self.graph
    includes(:symptom_hierarchies).to_json(only: [:id, :description, :comment], methods: [:parent_ids])
  end
end
