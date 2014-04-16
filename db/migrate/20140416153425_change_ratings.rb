class ChangeRatings < ActiveRecord::Migration
  def change
    rename_column :ratings, :parts_quality, :cleanness
  end
end
