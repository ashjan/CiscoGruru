class CreateOldSchemas < ActiveRecord::Migration
  def change
    create_table :old_schemas do |t|
      t.integer :oldid
      t.references :schema, index: true
      t.datetime :import_date
      t.string :username
      t.string :name
      t.boolean :template, default: false
      t.string :db
      t.string :schema_data
      t.boolean :imported, default: false

      t.timestamps null: false
    end
    add_foreign_key :old_schemas, :schemas
  end
end
