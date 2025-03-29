# == Schema Information
#
# Table name: animal_types
#
#  id          :bigint           not null, primary key
#  name        :string
#  plural_name :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_animal_types_on_name  (name) UNIQUE
#
FactoryBot.define do
  factory :animal_type do
    name { "кот" }
    plural_name { "коты" }
  end
end
