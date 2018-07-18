class CreateSchemaVersions < ActiveRecord::Migration
  def change
    create_table :schema_versions do |t|
      t.references :schema, index: true
      t.text :schema_data
      t.references :user, index: true
      t.boolean :autosave, default: false

      t.timestamps null: false
    end
    add_foreign_key :schema_versions, :schemas
    add_foreign_key :schema_versions, :users
  end
end
