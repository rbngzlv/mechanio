class MoveRegionsUnderRoot < ActiveRecord::Migration
  def up
    roots = Region.roots.to_a
    root = Region.create(name: 'Root', parent: nil)
    roots.each do |r|
      r.update_attribute(:parent, root)
    end
  end

  def down
    root = Region.find_by(name: 'Root')
    root.children.each do |r|
      r.update_attribute(:parent, nil)
    end
    root.destroy
  end
end
