class Aviary < ApplicationRecord
  has_many :sections
  has_nmany :animals
end
