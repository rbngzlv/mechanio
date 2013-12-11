class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.integer :user_id
      t.string :last_4, limit: 4
      t.string :token
      t.string :braintree_customer_id

      t.index :user_id
    end
  end
end
