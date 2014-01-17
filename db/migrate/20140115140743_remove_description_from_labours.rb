class RemoveDescriptionFromLabours < ActiveRecord::Migration
  def up
    remove_column :labours, :description
  end

  def down
    add_column :labours, :description, :text
  end
end
