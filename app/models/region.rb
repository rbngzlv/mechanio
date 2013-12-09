class Region < ActiveRecord::Base

  has_ancestry cache_depth: true

  default_scope { order(:name) }

  def self.arrange_serializable nodes = arrange
    nodes.map do |parent, children|
      parent.serializable_hash.merge 'children' => arrange_serializable(children)
    end
  end
end
