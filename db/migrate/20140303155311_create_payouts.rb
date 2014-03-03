class CreatePayouts < ActiveRecord::Migration
  def change
    create_table :payouts do |t|
      t.string :account_name
      t.string :account_number
      t.string :bsb_number
      t.string :transaction_id
      t.decimal :amount, precision: 8, scale: 2
      t.references :job, index: true
      t.references :mechanic, index: true

      t.timestamps
    end
  end
end
