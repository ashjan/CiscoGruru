class PaymentInfoForAccounts < ActiveRecord::Migration
  def change
  	add_column :accounts, :update_url, :string
  	add_column :accounts, :cancel_url, :string
  	add_column :accounts, :subscription_status, :string
  	add_column :accounts, :next_bill_date, :string
  	add_column :accounts, :paddle_subscription_id, :integer
  	add_column :accounts, :paddle_subscription_plan_id, :integer
  end
end
