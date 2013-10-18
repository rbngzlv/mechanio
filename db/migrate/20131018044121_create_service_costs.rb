class CreateServiceCosts < ActiveRecord::Migration
  def change
    create_table :service_costs do |t|
      t.string :description
      t.decimal :cost, precision: 8, scale: 2
      t.integer :service_plan_id
    end
  end
end
