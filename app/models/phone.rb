class Phone < ApplicationRecord
  has_many :phonebooks
  has_many :advertisers, through: :phonebooks

  enum phone_type: [:landline, :cell_phone]
end
