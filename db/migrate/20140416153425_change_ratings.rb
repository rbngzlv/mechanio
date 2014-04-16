class ChangeRatings < ActiveRecord::Migration
  def change
    rename_column :ratings, :cleanness, :cleanness
  end
end
