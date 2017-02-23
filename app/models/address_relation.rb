class AddressRelation < ApplicationRecord
  belongs_to :advertiser
  belongs_to :address
end
