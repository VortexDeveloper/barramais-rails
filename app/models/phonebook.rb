class Phonebook < ApplicationRecord
  belongs_to :advertiser
  belongs_to :phone
end
