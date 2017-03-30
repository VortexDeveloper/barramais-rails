class OwnVessel < ApplicationRecord
  belongs_to :user
  belongs_to :vessel_type
end
