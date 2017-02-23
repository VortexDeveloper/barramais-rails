class Advertiser < ApplicationRecord
  has_many :phonebooks
  has_many :phones, through: :phonebooks
  has_many :transactions
  has_many :ads, through: :transactions
end
