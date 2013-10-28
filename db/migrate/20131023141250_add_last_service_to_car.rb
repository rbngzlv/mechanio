class AddLastServiceToCar < ActiveRecord::Migration
  def change
    add_column :cars, :last_service_kms, :integer
    add_column :cars, :last_service_date, :date
  end
end
