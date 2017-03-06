json.user_advertiser do
  json.extract! @user.advertiser, :id, :document_type, :document_number, :email, :website, :facebook, :instagram, :user_id, :landline, :cell_phone, :created_at, :updated_at
  json.address @user.advertiser.address
  json.state @user.advertiser.address.state
  json.city @user.advertiser.address.city

  json.ads do
    json.array!(@user.advertiser.ads) do |ad|
      json.extract! ad, :id, :description, :created_at, :updated_at
      json.photo_url ad.photo.url
    end
  end
end
