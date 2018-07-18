json.array!(@schemas) do |schema|
  json.(schema, :id, :title, :schema_data, :updated_at, :description, :db)
end
