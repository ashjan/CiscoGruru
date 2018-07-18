class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :account_type, default: 0
      t.datetime :next_payment_date

      t.timestamps null: false
    end
  end
end
