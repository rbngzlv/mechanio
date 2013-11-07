class AddPointIndexToLocations < ActiveRecord::Migration
  def up
    execute %{
      create index index_on_locations_location ON locations using gist (
        ST_GeographyFromText(
          'SRID=4326;POINT(' || locations.longitude || ' ' || locations.latitude || ')'
        )
      )
    }
  end

  def down
    execute %{drop index index_on_locations_location}
  end
end
