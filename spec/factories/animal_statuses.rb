# == Schema Information
#
# Table name: animal_statuses
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_animal_statuses_on_name  (name) UNIQUE
#
FactoryBot.define do
  factory :animal_status do
    name { "в приюте" }
  end
end
