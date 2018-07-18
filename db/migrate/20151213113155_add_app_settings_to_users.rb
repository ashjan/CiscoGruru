class AddAppSettingsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :app_settings, :string
  end
end
