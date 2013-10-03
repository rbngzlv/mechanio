class ServicePlansRenameQuoteToCost < ActiveRecord::Migration
  def change
    rename_column :service_plans, :quote, :cost
  end
end
