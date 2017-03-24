  json.extract! user, :id, :first_name, :last_name, :cellphone, :birthday, :sex,
                :nautical_professional, :academic_profile, :relationship,
                :about, :has_embarcation, :nautical_profession_description,
                :naval_service, :naval_service_patent, :created_at, :updated_at, :advertiser,
                :nautical_license, :has_nautical_license, :work
  json.isFriend current_user.friend_of? user
