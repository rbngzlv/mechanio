class AddIndexesForAuthentications < ActiveRecord::Migration
  def change
    add_index :authentications, [:uid, :provider]
    add_index :authentications, :user_id
  end
end
