# == Schema Information
#
# Table name: admin_users
#
#  id         :bigint           not null, primary key
#  email      :string           not null
#  role       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class AdminUser < ApplicationRecord
  before_destroy :one_admin_user_should_exist
  before_update :prevent_demoting_last_admin
  enum :role, [:admin, :employee], prefix: true, scopes: true

  normalizes :email, with: ->(e) { e.strip.downcase }
  
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true

  private

  def one_admin_user_should_exist
    if role_admin? && AdminUser.role_admin.count == 1
      errors.add(:base, I18n.t("activerecord.errors.models.admin_user.one_admin_user_must_exist"))
      throw(:abort)
    end
  end

  def prevent_demoting_last_admin
     # Only relevant if this record is currently the last admin and is being demoted.
     role_changing_from_admin_to_non_admin =
       if respond_to?(:will_save_change_to_role?)
         will_save_change_to_role? && role_was == "admin" && !role_admin?
       else
         respond_to?(:role_changed?) && role_changed? && role_was == "admin" && !role_admin?
       end
     if role_changing_from_admin_to_non_admin && AdminUser.role_admin.count == 1
       errors.add(:base, I18n.t("activerecord.errors.models.admin_user.one_admin_user_must_exist"))
       throw(:abort)
     end
   end
end 
