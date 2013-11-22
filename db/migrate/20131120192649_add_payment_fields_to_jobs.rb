class AddPaymentFieldsToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :credit_card_id, :integer
    add_column :jobs, :transaction_id, :string
    add_column :jobs, :transaction_status, :string
    add_column :jobs, :transaction_errors, :text
  end
end
