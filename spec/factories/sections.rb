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
FactoryBot.define do
  factory :section do
    name { Faker::Alphanumeric.alpha(number: 8) }
    aviary { nil }
  end
end
