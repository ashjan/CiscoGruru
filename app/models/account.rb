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

class Account < ActiveRecord::Base
  has_many :users
  has_many :payments

  enum account_type: [:free, :pro, :translator, :temp_pro]

  # Upgrades account to the Pro Plan
  def upgrade_to_pro_plan
    ActiveRecord::Base.transaction do
      update({
        account_type: "pro",
        next_payment_date: 1.month.from_now
        })
    end
  end

  # Downgrades account to free plan
  def downgrade_to_free_plan
    ActiveRecord::Base.transaction do
      update({
        account_type: "free",
        next_payment_date: nil
        })
    end
  end

  def has_payment_options?
    !translator? && !temp_pro?
  end

  def name
    if pro?
      "Pro"
    elsif translator?
      "Translator"
    elsif free?
      "Free"
    elsif temp_pro?
      "Pro"
    else
      "N/A"
    end
  end

  def schemata_limit
    if pro?
      25
    elsif free?
      10
    else
      0
    end
  end
end
