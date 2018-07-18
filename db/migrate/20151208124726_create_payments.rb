class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :user, index: true, foreign_key: true
      t.references :account, index: true, foreign_key: true
      t.float :sale_gross
      t.float :fee
      t.float :earnings
      t.float :payment_tax
      t.string :country
      t.string :currency
      t.integer :paddle_order_id
      t.string :next_bill_date
      t.integer :paddle_subscription_id
      t.string :email
      t.integer :paddle_subscription_plan_id
      t.string :status

      t.timestamps null: false
    end
  end
end
