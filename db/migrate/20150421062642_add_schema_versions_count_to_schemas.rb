class AddSchemaVersionsCountToSchemas < ActiveRecord::Migration
  def up
    add_column :schemas, :schema_versions_count, :integer, default: 0
    Schema.find_each do |schema|
      Schema.reset_counters schema.id, :schema_versions
    end
  end

  def down
    remove_column :schemas, :schema_versions_count
  end
end
