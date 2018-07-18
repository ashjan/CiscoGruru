class CreateUserSchemas < ActiveRecord::Migration
  def change
    create_table :user_schemas do |t|
      t.references :user, index: true
      t.references :schema, index: true
      t.integer :access_mode, default: 0

      t.timestamps null: false
    end
    add_foreign_key :user_schemas, :users
    add_foreign_key :user_schemas, :schemas
  end
end
