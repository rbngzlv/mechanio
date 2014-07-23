class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :user_id
      t.string :email
      t.datetime :created_at
      t.datetime :accepted_at
    end
  end
end
