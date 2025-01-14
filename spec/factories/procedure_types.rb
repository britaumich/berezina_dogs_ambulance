# == Schema Information
#
# Table name: procedure_types
#
#  id          :bigint           not null, primary key
#  description :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :procedure_type do
    name { "MyString" }
    description { "MyString" }
  end
end
