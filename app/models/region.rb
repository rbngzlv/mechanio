class Region < ActiveRecord::Base

  has_ancestry cache_depth: true

  default_scope      { order(:name) }
  scope :suburbs, -> { where.not(postcode: nil) }

  def self.arrange_serializable(nodes = arrange)
    nodes.map do |parent, children|
      parent.serializable_hash.merge 'children' => arrange_serializable(children)
    end
  end

  def self.search(name)
    return none if name.blank?
    where("name ILIKE ?", "#{name}%").limit(10)
  end
end
