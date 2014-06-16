class AddDisplayNameToRegions < ActiveRecord::Migration
  def change
    add_column :regions, :display_name, :string

    reversible do |dir|
      dir.up do
        Region.suburbs.each do |suburb|
          state = suburb.ancestors[1]
          suburb.display_name = "#{suburb.name}, #{state.name} #{suburb.postcode}"
          suburb.save
        end
      end
    end
  end
end
