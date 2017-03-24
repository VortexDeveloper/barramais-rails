json.extract! comment, :body, :parent_id, :created_at, :updated_at

json.commentator do
  json.user_id comment.user.id
  json.name "#{comment.user.first_name} #{comment.user.last_name}"
  json.avatar_url asset_url(comment.user.avatar.url)
end
