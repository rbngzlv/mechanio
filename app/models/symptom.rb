class Symptom < ActiveRecord::Base

  has_ancestry

  belongs_to :symptom, foreign_key: :parent_id

  validates :description, presence: true

  def self.tree
    Symptom.roots.first.descendants.arrange
  end
end
