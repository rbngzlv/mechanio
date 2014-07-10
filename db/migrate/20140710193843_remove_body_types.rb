class RemoveBodyTypes < ActiveRecord::Migration
  def change
    drop_table :body_types
    remove_column :model_variations, :body_type_id, :integer
    add_column :model_variations, :shape, :string
  end
end
