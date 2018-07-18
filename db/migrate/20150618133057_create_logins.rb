class CreateLogins < ActiveRecord::Migration
  def change
    create_table :logins do |t|
      t.references :user, index: true, foreign_key: true
      t.datetime :logintime
      t.string :user_agent
      t.string :ip
      t.references :oauth_profile, index: true, foreign_key: true
    end
  end
end
