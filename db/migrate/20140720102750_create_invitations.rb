class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :user_id
      t.integer :sender_id
      t.integer :give_discount_id
      t.integer :get_discount_id
      t.string :email
      t.datetime :created_at
      t.datetime :accepted_at

      t.index :user_id
      t.index :sender_id
    end
  end
end
