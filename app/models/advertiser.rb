class Advertiser < ApplicationRecord
  has_many :phonebooks
  has_many :phones, through: :phonebooks
  has_many :transactions
  has_many :ads, through: :transactions
  has_many :address_relations
  has_many :addresses, through: :address_relations

  enum document_type: [:cpf, :cnpj]
end
