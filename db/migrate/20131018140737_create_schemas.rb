class CreateSchemas < ActiveRecord::Migration
  def change
    create_table :schemas do |t|
      t.string :title
      t.string :schema_data
      t.integer :owner_id

      t.timestamps null: true
    end
    add_foreign_key :schemas, :users, column: :owner_id
  end
end
