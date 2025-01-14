# == Schema Information
#
# Table name: notes
#
#  id            :bigint           not null, primary key
#  noteable_type :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  noteable_id   :bigint           not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_notes_on_noteable  (noteable_type,noteable_id)
#  index_notes_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :note do
    
  end
end
