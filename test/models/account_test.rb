# == Schema Information
#
# Table name: accounts
#
#  id                          :integer          not null, primary key
#  account_type                :integer          default(0)
#  next_payment_date           :datetime
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  update_url                  :string
#  cancel_url                  :string
#  subscription_status         :string
#  next_bill_date              :string
#  paddle_subscription_id      :integer
#  paddle_subscription_plan_id :integer
#

require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  should have_many(:users)
  # should have_many(:payments)
end
