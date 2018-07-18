json.own_schemas @own_schemas do |schema|
  json.(schema, :id, :title, :db)
  json.updated_at schema.updated_at.to_i
end
json.shared_schemas @shared_schemas do |schema|
  json.(schema, :id, :title, :db)
  json.updated_at schema.updated_at.to_i
  json.owner schema.owner.email
end
