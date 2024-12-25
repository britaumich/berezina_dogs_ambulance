class Animal < ApplicationRecord
  belongs_to :animal_type

  has_many_attached :pictures do |attachable|
    attachable.variant :thumb, resize_to_limit: [640, 480]
  end
  include AppendToHasManyAttached['pictures']

end
