class AddDeletedToSchemas < ActiveRecord::Migration
  def change
    add_column :schemas, :deleted, :boolean, default: false
  end
end
