class AddDisplayTitleToCars < ActiveRecord::Migration
  def change
    add_column :cars, :display_title, :string
  end
end
