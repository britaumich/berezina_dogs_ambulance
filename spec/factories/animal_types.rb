# == Schema Information
#
# Table name: animal_types
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :animal_type do
    name { "MyString" }
  end
end
