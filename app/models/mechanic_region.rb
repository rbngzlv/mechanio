class MechanicRegion < ActiveRecord::Base
  belongs_to :mechanic
  belongs_to :region

  def self.bulk_insert(mechanic_id, region_ids)
    MechanicRegion.connection.execute(
      "INSERT INTO #{self.table_name} (region_id, postcode, mechanic_id) " +
      Region.unscoped.select(:id, :postcode, mechanic_id.to_s).where(id: region_ids).to_sql
    )
  end
end
