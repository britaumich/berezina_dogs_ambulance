# == Schema Information
#
# Table name: aviaries
#
#  id           :bigint           not null, primary key
#  description  :text
#  has_sections :boolean          default(FALSE)
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Aviary < ApplicationRecord
  has_many :sections
  has_many :animals

  before_save :strip_whitespace_and_capitalize
  validates :name, presence: true, uniqueness: true

  private

  def strip_whitespace_and_capitalize
    if self.name.present?
      self.name = self.name.strip
      self.name[0] = self.name[0].capitalize
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["animals"]
  end
  
end
