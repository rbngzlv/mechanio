class RenameBrandToMake < ActiveRecord::Migration
  def change
    rename_table :brands, :makes
    rename_column :models, :brand_id, :make_id
    rename_column :model_variations, :brand_id, :make_id
  end
end
