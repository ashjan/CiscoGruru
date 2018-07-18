json.array!(@collaborators) do |collaborator|
  json.(collaborator, :id, :username, :email, :access_mode)
  json.avatar collaborator[:image]
end
