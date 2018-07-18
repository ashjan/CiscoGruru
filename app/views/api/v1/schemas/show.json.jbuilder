json.(@schema, :id, :title, :schema_data, :template, :db)
json.is_owner @schema.owner == current_user
json.versions @schema.schema_versions.order(id: :desc).limit(10).each do |version|
  json.(version, :id)
  json.created_at version.created_at.to_i
end