class AddReferralToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :referral_code, :string
  	add_column :users, :referred_by, :integer
  	add_index :users, :referral_code
  	add_index :users, :referred_by

    User.reset_column_information

    User.all.each do |u|
      u.generate_referral_code
      u.save
    end
  end
end
