# == Schema Information
#
# Table name: animals
#
#  id               :bigint           not null, primary key
#  arival_date      :date
#  birth_day        :date
#  birth_year       :date
#  color            :string
#  death_day        :date
#  death_year       :date
#  description      :string
#  from_people      :string
#  from_place       :string
#  gender           :string
#  graduation       :string
#  history          :string
#  nickname         :string
#  sterilization    :boolean          default(FALSE)
#  surname          :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  animal_status_id :bigint
#  animal_type_id   :bigint           not null
#  aviary_id        :bigint
#  parent_id        :integer
#  section_id       :bigint
#
# Indexes
#
#  index_animals_on_animal_status_id  (animal_status_id)
#  index_animals_on_animal_type_id    (animal_type_id)
#  index_animals_on_aviary_id         (aviary_id)
#  index_animals_on_section_id        (section_id)
#
# Foreign Keys
#
#  fk_rails_...  (animal_type_id => animal_types.id)
#
FactoryBot.define do
  factory :animal do
    nickname { Faker::Creature::Animal.name }
    surname { Faker::Name.last_name }
    gender { Faker::Gender.binary_type }
    arival_date { Faker::Date.backward(days: 365) }
    from_people { Faker::Name.name }
    from_place { Faker::Address.city }
    birth_year { Faker::Date.backward(days: 365 * 5) }
    death_year { nil }
    birth_day { nil }
    death_day { nil }
    color { Faker::Color.color_name }
    description { Faker::Lorem.sentence }
    history { Faker::Lorem.paragraph }
    graduation { Faker::Educator.degree }
    sterilization { Faker::Boolean.boolean }
    association :aviary
    association :animal_type
    association :animal_status
  end
end
