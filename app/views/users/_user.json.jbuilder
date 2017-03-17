json.extract! user, :id, :first_name, :last_name, :cellphone, :birthday, :sex,
              :nautical_professional, :academic_profile, :relationship,
              :user_id, :about, :has_embarcation, :nautical_work,
              :naval_service, :naval_service_patent, :created_at, :updated_at, :advertiser,
              :nautical_license, :has_nautical_license, :work
json.advertiser user.advertiser
json.url user_url(user, format: :json)
