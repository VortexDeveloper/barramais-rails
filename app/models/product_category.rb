class ProductCategory < ApplicationRecord
  has_many :product_sub_categories
  has_many :products
end
