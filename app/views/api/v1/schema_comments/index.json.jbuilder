json.array!(@schema.schema_comments) do |schema_comment|
  json.(schema_comment, :id, :contents, :created_at)
  json.own_comment schema_comment.user == current_user
  json.commenter schema_comment.user.username
  json.avatar schema_comment.user.image
end

