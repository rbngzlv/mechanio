class AddTextFieldsToRatings < ActiveRecord::Migration
  def change
    add_column :ratings, :user_name, :string
    add_column :ratings, :mechanic_name, :string
    add_column :ratings, :job_title, :string

    reversible do |dir|
      dir.up do
        Rating.all.each do |r|
          # trigger set_text_fields before_save hook
          r.save
        end
      end
    end
  end
end
