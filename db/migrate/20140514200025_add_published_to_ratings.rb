class AddPublishedToRatings < ActiveRecord::Migration
  def change
    add_column :ratings, :published, :boolean
  end
end
