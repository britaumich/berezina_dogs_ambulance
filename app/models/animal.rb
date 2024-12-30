class Animal < ApplicationRecord
  belongs_to :animal_type
  belongs_to :aviary, optional: true
  belongs_to :section, optional: true

  has_many :notes, as: :noteable

  has_many_attached :pictures do |attachable|
    attachable.variant :thumb, resize_to_limit: [640, 480]
  end
  include AppendToHasManyAttached['pictures']

  has_many :medical_procedures

  def self.ransackable_attributes(auth_object = nil)
    ["animal_type_id", "nickname", "surname", "gender", "arival_date", "aviary_id", "description", "history"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["animal_type"]
  end

end
