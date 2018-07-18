class AddTemplateToSchemas < ActiveRecord::Migration
  def change
    add_column :schemas, :template, :boolean, default: false
  end
end
