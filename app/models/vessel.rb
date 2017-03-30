class Vessel < ApplicationRecord
  belongs_to :classified
  belongs_to :brand
  belongs_to :mold

  has_many :vessel_accessories, dependent: :destroy
  has_many :accessories, through: :vessel_accessories
end
