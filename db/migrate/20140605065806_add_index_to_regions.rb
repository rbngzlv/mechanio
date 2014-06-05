class AddIndexToRegions < ActiveRecord::Migration
  def change
    change_table :regions do |t|
      t.index :name
      t.index :postcode
      t.index [:name, :postcode]
    end

    reversible do |dir|
      dir.up do
        execute "CREATE INDEX index_regions_name_vector ON regions USING gin(name gin_trgm_ops)"
      end

      dir.down do
        execute 'DROP INDEX index_regions_name_vector'
      end
    end
  end
end
