class AddSchemasCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :schemas_count, :integer, default: 0
  end
end
