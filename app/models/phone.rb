class Phone < ApplicationRecord
  has_many :phonebooks
  has_many :advertisers, through: :phonebooks
end
