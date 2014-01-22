class Symptom < ActiveRecord::Base

  has_ancestry

  belongs_to :symptom, foreign_key: :parent_id

  validates :description, presence: true

  before_save :check_parent_id


  def self.top
    roots.first
  end

  def self.tree
    top ? top.descendants.arrange : {}
  end

  def self.json_tree
    traverse(tree).to_json
  end

  def self.traverse(subtree)
    subtree.map do |parent, children|
      json = parent.as_json(only: [:id, :description])
      json['children'] = traverse(children) if children
      json
    end
  end

  def check_parent_id
    self.parent_id ||= self.class.top.id unless self.description == 'Root'
  end
end
