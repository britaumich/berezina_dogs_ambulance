class Section < ApplicationRecord
  belongs_to :aviary
  has_nmany :animals
end
