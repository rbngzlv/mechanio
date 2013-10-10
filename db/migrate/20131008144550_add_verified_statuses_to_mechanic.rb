class AddVerifiedStatusesToMechanic < ActiveRecord::Migration
  def change
    add_column :mechanics, :phone_verified, :boolean, default: false
    add_column :mechanics, :super_mechanic, :boolean, default: false
    add_column :mechanics, :warranty_covered, :boolean, default: false
    add_column :mechanics, :qualification_verified, :boolean, default: false
  end
end
