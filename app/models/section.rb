class Section < ApplicationRecord
  include ActionView::RecordIdentifier
  belongs_to :aviary
  has_many :animals

  after_destroy_commit do
    broadcast_remove_to self
  end

end
