# frozen_string_literal: true

class AnimalPolicy  < ApplicationPolicy
  attr_reader :user, :role, :record

  def index?
    employee_user? || admin_user?
  end

  def show?
    employee_user? || admin_user?
  end

  def duplicate?
    create?
  end

  def create?
    employee_user? || admin_user?
  end

  def new?
    create?
  end

  def update?
    employee_user? || admin_user?
  end

  def edit?
    update?
  end

  def destroy?
    employee_user? || admin_user?
  end

  def upload_pictures?
    employee_user? || admin_user?
  end

  def delete_picture?
    employee_user? || admin_user?
  end

  def delete_medical_procedure?
    employee_user? || admin_user?
  end

  def set_main_picture?
    employee_user? || admin_user?
  end

  class Scope
    def initialize(context, scope)
      @user = context[:user]
      @role = context[:role]
      @scope = scope
    end

    def resolve
      raise NoMethodError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :role, :scope
  end
end
