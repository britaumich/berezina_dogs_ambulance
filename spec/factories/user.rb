# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email_address   :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
FactoryBot.define do
  admin_user = FactoryBot.create(:admin_user)
  factory :user do
    email_address { admin_user.email }
    password { "password" }
  end

end
