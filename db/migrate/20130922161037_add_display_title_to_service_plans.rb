class AddDisplayTitleToServicePlans < ActiveRecord::Migration
  def change
    add_column :service_plans, :display_title, :string

    reversible do |dir|
      dir.up do
        ServicePlan.find_each do |s|
          s.set_display_title
          s.save(validate: false)
        end
      end
    end
  end
end
