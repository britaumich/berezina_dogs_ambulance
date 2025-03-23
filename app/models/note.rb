# == Schema Information
#
# Table name: notes
#
#  id            :bigint           not null, primary key
#  noteable_type :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  noteable_id   :bigint           not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_notes_on_noteable  (noteable_type,noteable_id)
#  index_notes_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Note < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :user
  belongs_to :noteable, polymorphic: true

  has_rich_text :body

  validates :body, presence: true

  after_create_commit do
    broadcast_prepend_to [ noteable, :notes ], target: "#{dom_id(noteable)}_notes"
  end
  after_update_commit do
    broadcast_remove_to self
    broadcast_prepend_to [ noteable, :notes ], target: "#{dom_id(noteable)}_notes"
  end
  after_destroy_commit do
    broadcast_remove_to self
  end

 def self.ransackable_associations(auth_object = nil)
  [ 'noteable', 'rich_text_body_body' ]
end
end
