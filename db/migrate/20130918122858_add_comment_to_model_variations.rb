class AddCommentToModelVariations < ActiveRecord::Migration
  def change
    add_column :model_variations, :comment, :text
  end
end
