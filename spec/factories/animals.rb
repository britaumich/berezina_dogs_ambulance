# == Schema Information
#
# Table name: animals
#
#  id             :bigint           not null, primary key
#  arival_date    :date
#  birth_date     :date
#  color          :string
#  death_date     :date
#  description    :string
#  from_people    :string
#  from_place     :string
#  gender         :string
#  graduation     :string
#  history        :string
#  nickname       :string
#  surname        :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  animal_type_id :bigint           not null
#  aviary_id      :bigint
#  section_id     :bigint
#
# Indexes
#
#  index_animals_on_animal_type_id  (animal_type_id)
#  index_animals_on_aviary_id       (aviary_id)
#  index_animals_on_section_id      (section_id)
#
# Foreign Keys
#
#  fk_rails_...  (animal_type_id => animal_types.id)
#
FactoryBot.define do
  factory :animal do
    nickname { "MyString" }
    surname { "MyString" }
    gender { "MyString" }
    arival_date { "2024-12-23" }
    from_people { "MyString" }
    from_place { "MyString" }
    birth_date { "2024-12-23" }
    death_date { "2024-12-23" }
    color { "MyString" }
    aviary { "MyString" }
    description { "MyString" }
    history { "MyString" }
    graduation { "MyString" }
    animal_type { nil }
  end
end
