class AddChannelToDiscounts < ActiveRecord::Migration
  def change
    add_column :discounts, :channel, :string
    add_index :discounts, :channel
  end
end
