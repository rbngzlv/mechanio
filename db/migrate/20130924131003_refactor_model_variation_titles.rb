class RefactorModelVariationTitles < ActiveRecord::Migration
  def change
    add_column :model_variations, :detailed_title, :string

    reversible do |dir|
      dir.up do
        ModelVariation.find_each do |m|
          m.save(validate: false)
        end
      end
    end
  end
end
