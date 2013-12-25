class RenameAuthorizationsToAuthentications < ActiveRecord::Migration
  def change
    rename_table :authorizations, :authentications
  end
end
