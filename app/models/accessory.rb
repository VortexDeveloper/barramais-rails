class Accessory < ApplicationRecord
  belongs_to :classified
  belongs_to :vessel

  def accessory_price
    classified.price
  end
end
