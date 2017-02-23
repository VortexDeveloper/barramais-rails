class Ad < ApplicationRecord
  has_one :area

  has_many :transactions
  has_many :advertisers, through: :transactions
end
