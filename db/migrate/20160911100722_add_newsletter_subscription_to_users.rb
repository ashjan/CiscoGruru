class AddNewsletterSubscriptionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :newsletter_subscription, :boolean, default: false
  end
end
