class Address < ApplicationRecord
  belongs_to :city
  belongs_to :state
  belongs_to :country

  has_many :address_relations
  has_many :advertisers, through: :address_relations
end
