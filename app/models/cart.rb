class Cart < ApplicationRecord
  has_many :cart_animals, dependent: :delete_all
  has_many :animals, through: :cart_animals
end
