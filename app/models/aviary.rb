class Aviary < ApplicationRecord
  has_many :sections
  has_many :animals
end
