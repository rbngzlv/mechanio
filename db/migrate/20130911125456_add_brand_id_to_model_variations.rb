class AddBrandIdToModelVariations < ActiveRecord::Migration
  def change
    add_column :model_variations, :brand_id, :integer
  end
end
