class AddDescriptionToSchemas < ActiveRecord::Migration
  def change
    add_column :schemas, :description, :text
  end
end
