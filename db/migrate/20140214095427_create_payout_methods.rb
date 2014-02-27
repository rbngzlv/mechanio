class CreatePayoutMethods < ActiveRecord::Migration
  def change
    create_table :payout_methods do |t|
      t.string :account_name
      t.string :bsb_number
      t.string :account_number
      t.references :mechanic, index: true

      t.timestamps
    end
  end
end
