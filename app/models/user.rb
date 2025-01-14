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
# Indexes
#
#  index_users_on_email_address  (email_address) UNIQUE
#
class User < ApplicationRecord
  has_secure_password
  # has_secure_token :confirmation_token
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  # def confirm!
  #   update!(confirmed_at: Time.current, confirmation_token: nil)
  # end

  # def confirmed?
  #   confirmed_at.present?
  # end

  # def send_confirmation_instructions
  #   regenerate_confirmation_token
  #   UserMailer.confirmation_instructions(self).deliver_now
  # end

  # Email Confirmation
end
