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

  validates :name, presence: true, uniqueness: true
  
end
