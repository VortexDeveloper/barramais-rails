class ProductSubCategory < ApplicationRecord
  belongs_to :product_category

  has_many :products
end
