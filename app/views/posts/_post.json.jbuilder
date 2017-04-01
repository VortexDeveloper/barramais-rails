json.extract! post, :id, :description, :created_at, :updated_at
json.sent_date_format post.sent_date_format
json.attached_image_url ""

json.user do
  json.user_id post.user.id
  json.name "#{post.user.first_name} #{post.user.last_name}"
  json.avatar_url asset_url(post.user.avatar.url)
end

json.comments do
  json.array! post.root_comments, partial: 'posts/comment', as: :comment
end

json.likes do
  json.size post.get_likes.size
  json.didILiked current_user.voted_for? post
end

json.post_images do
  if post.post_images.present?
    json.array!(post.post_images) do |post_image|
      json.post_image asset_url(post_image.image.url)
    end
  end
end

json.url post_url(post, format: :json)
