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
require 'rails_helper'

RSpec.describe Aviary, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
