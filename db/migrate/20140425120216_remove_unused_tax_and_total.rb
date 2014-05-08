class RemoveUnusedTaxAndTotal < ActiveRecord::Migration
  def change
    %w(jobs fixed_amounts labours parts tasks).each do |t|
      remove_column t, :tax, :decimal, precision: 8, scale: 2
      remove_column t, :total, :decimal, precision: 8, scale: 2
    end
  end
end
