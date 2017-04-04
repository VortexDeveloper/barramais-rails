json.pending_friendships do
  json.array!(@pending_friendships) do |user|
    json.extract! user, :id, :first_name, :last_name, :cellphone, :birthday, :sex,
                  :nautical_professional, :academic_profile, :relationship,
                  :about, :has_embarcation, :nautical_profession_description,
                  :naval_service, :naval_service_patent, :created_at, :updated_at, :advertiser,
                  :nautical_license, :has_nautical_license, :work
  end
end