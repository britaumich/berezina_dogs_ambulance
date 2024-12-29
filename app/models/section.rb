class Section < ApplicationRecord
  include ActionView::RecordIdentifier
  belongs_to :aviary
  has_many :animals

end
