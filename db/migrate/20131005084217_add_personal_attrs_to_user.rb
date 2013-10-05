class AddPersonalAttrsToUser < ActiveRecord::Migration
  def change
    add_column :users, :dob, :date
    add_column :users, :mobile_number, :string
    add_column :users, :description, :text
    add_column :users, :avatar, :string
  end
end
