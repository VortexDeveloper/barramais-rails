class Brand < ApplicationRecord
  has_many :molds
  has_many :vessels
end
