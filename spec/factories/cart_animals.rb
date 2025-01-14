# == Schema Information
#
# Table name: cart_animals
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  animal_id  :bigint           not null
#  cart_id    :bigint           not null
#
# Indexes
#
#  index_cart_animals_on_animal_id  (animal_id)
#  index_cart_animals_on_cart_id    (cart_id)
#
# Foreign Keys
#
#  fk_rails_...  (animal_id => animals.id)
#  fk_rails_...  (cart_id => carts.id)
#
FactoryBot.define do
  factory :cart_animal do
    animal { nil }
    cart { nil }
  end
end
