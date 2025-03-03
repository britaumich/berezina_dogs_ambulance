# == Schema Information
#
# Table name: animal_statuses
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class AnimalStatus < ApplicationRecord
  has_many :animals

  before_save :strip_whitespace_and_downcase
  validates :name, presence: true, uniqueness: true

  private 

  def strip_whitespace_and_downcase
    if self.name.present?
      self.name = self.name.strip.downcase
    end
  end
  
end
