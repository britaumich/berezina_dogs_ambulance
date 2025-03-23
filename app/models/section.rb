# == Schema Information
#
# Table name: sections
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  aviary_id   :bigint           not null
#
# Indexes
#
#  index_sections_on_aviary_id  (aviary_id)
#
# Foreign Keys
#
#  fk_rails_...  (aviary_id => aviaries.id)
#
class Section < ApplicationRecord
  include ActionView::RecordIdentifier
  belongs_to :aviary
  has_many :animals, dependent: :restrict_with_exception

  before_save :strip_whitespace_and_capitalize

  validates :name, presence: true, uniqueness: { scope: :aviary, message: :is_already_in_this_aviary }

  private

  def strip_whitespace_and_capitalize
    if self.name.present?
      self.name = self.name.strip
      self.name[0] = self.name[0].capitalize
    end
  end

  after_destroy_commit do
    broadcast_remove_to self
  end
end
