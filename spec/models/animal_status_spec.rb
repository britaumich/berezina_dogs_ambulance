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
require 'rails_helper'

RSpec.describe AnimalStatus, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
