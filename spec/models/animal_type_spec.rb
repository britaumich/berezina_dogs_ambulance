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
require 'rails_helper'

RSpec.describe AnimalType, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
