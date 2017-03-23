class Accessory < ApplicationRecord
  belongs_to :classified
  belongs_to :vessel
end
