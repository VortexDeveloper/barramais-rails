json.extract! post, :id, :description, :created_at, :updated_at
json.sent_date_format post.sent_date_format
json.attached_image_url ""

json.user do post.user
  json.user_id post.user.id
  json.name "#{post.user.first_name} #{post.user.last_name}"
  json.avatar_url asset_url(post.user.avatar.url)
end

json.comments post.root_comments
json.likes do
  json.size post.get_likes.size
  json.didILiked current_user.voted_for? post
end

json.url post_url(post, format: :json)
