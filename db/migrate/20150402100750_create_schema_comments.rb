class CreateSchemaComments < ActiveRecord::Migration
  def change
    create_table :schema_comments do |t|
      t.references :user, index: true
      t.references :schema, index: true
      t.text :contents

      t.timestamps null: false
    end
    add_foreign_key :schema_comments, :users
    add_foreign_key :schema_comments, :schemas
  end
end
