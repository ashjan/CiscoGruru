class AddBrowserInfoToLogins < ActiveRecord::Migration
  def change
    add_column :logins, :browser, :string
    add_column :logins, :version, :string
    add_column :logins, :platform, :string
  end
end
