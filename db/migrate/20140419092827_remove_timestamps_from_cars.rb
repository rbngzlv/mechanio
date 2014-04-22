class RemoveTimestampsFromCars < ActiveRecord::Migration
  def change
    %w(makes models model_variations service_plans body_types).each do |table|
      remove_column table, :created_at, :timestamp
      remove_column table, :updated_at, :timestamp
    end
  end
end
