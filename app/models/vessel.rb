class Vessel < ApplicationRecord
  belongs_to :classified
  belongs_to :brand
  belongs_to :mold

  has_many :accessories
end
