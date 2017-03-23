class Vessel < ApplicationRecord
  belongs_to :classified

  has_one :mold
  has_many :accessories
end
