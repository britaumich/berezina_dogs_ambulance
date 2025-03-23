# == Schema Information
#
# Table name: animals
#
#  id                  :bigint           not null, primary key
#  arival_date         :date
#  birth_day           :date
#  birth_year          :date
#  color               :string
#  death_day           :date
#  death_year          :date
#  distinctive_feature :string
#  fake_parent         :boolean          default(FALSE)
#  from_people         :string
#  from_place          :string
#  gender              :string
#  graduation          :string
#  medical_history     :string
#  nickname            :string
#  sterilization       :boolean          default(FALSE)
#  surname             :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  animal_status_id    :bigint
#  animal_type_id      :bigint           not null
#  aviary_id           :bigint
#  fake_parent_id      :integer
#  parent_id           :integer
#  section_id          :bigint
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
require 'rails_helper'

RSpec.describe Animal, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
