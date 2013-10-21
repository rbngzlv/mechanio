class Symptom < ActiveRecord::Base

  belongs_to :symptom, foreign_key: :parent_id

  validates :description, presence: true

  def self.tree
    tree = {}
    symptoms = select(:id, :parent_id, :description).to_a
    symptoms.each do |s|
      next unless s.parent_id.nil?
      tree[s.id] = s.as_json(except: [:parent_id])
      tree[s.id]['symptoms'] = []
    end
    symptoms.each do |s|
      next if s.parent_id.nil?
      tree[s.parent_id]['symptoms'] << s.as_json(except: [:parent_id]) 
    end
    tree
  end
end
