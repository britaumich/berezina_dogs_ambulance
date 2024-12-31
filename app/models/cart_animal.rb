class CartAnimal < ApplicationRecord
  belongs_to :animal
  belongs_to :cart
end
