json.user_advertiser do
  json.extract! @user.advertiser, :id, :document_type, :document_number, :email, :website, :facebook, :instagram, :user_id, :landline, :cell_phone, :created_at, :updated_at, :address
  json.id @user.advertiser.id
  json.document_type @user.advertiser.document_type
  json.document_number @user.advertiser.document_number
  json.email @user.advertiser.email
  json.website @user.advertiser.website
  json.facebook @user.advertiser.facebook
  json.instagram @user.advertiser.instagram
  json.user_id @user.advertiser.user_id
  json.landline @user.advertiser.landline
  json.cell_phone @user.advertiser.cell_phone
  json.address @user.advertiser.address
  json.state @user.advertiser.address.state
  json.city @user.advertiser.address.city
end
