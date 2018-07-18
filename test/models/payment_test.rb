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

require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
