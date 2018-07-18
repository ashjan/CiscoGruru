class AddDbToSchemas < ActiveRecord::Migration
  def change
    add_column :schemas, :db, :string
  end
end
