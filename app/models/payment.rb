# == Schema Information
#
# Table name: payments
#
#  id                          :integer          not null, primary key
#  user_id                     :integer
#  account_id                  :integer
#  sale_gross                  :float
#  fee                         :float
#  earnings                    :float
#  payment_tax                 :float
#  country                     :string
#  currency                    :string
#  paddle_order_id             :integer
#  next_bill_date              :string
#  paddle_subscription_id      :integer
#  email                       :string
#  paddle_subscription_plan_id :integer
#  status                      :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#

class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :account

  def self.get_totals
  	{
  		sale_gross: Payment.sum(:sale_gross),
  		fee: Payment.sum(:fee),
  		payment_tax: Payment.sum(:payment_tax),
  		earnings: Payment.sum(:earnings)
  	}
  end
end
