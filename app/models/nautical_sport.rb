class NauticalSport < ApplicationRecord
  has_many :user_nautical_sports, dependent: :destroy
  has_many :users, :through => :user_nautical_sports
end
