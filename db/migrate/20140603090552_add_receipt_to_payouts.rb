class AddReceiptToPayouts < ActiveRecord::Migration
  def change
    add_column :payouts, :receipt, :string
  end
end
