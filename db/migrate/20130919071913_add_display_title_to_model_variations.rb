class AddDisplayTitleToModelVariations < ActiveRecord::Migration
  def change
    add_column :model_variations, :display_title, :string
  end
end
