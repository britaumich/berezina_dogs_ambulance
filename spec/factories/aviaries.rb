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
FactoryBot.define do
  factory :aviary do
    has_sections { false }
    name { Faker::Alphanumeric.alpha(number: 8) }
  end
end
