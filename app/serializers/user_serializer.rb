class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :cellphone, :birthday, :sex,
             :nautical_professional, :academic_profile, :relationship, :about,
             :has_embarcation, :nautical_work, :naval_service

  has_one :user
end
