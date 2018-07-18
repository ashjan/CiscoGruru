class CreateOAuthProfiles < ActiveRecord::Migration
  def change
    create_table :oauth_profiles do |t|
      t.references :user, index: true
      t.string :provider
      t.string :uid
      t.string :token
      t.string :secret
      t.string :username
      t.string :email
      t.string :firstname
      t.string :lastname
      t.string :image_url
      t.text :data

      t.timestamps null: false
    end
    add_foreign_key :oauth_profiles, :users
  end
end
