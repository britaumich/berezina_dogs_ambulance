# frozen_string_literal: true

class CartPolicy < ApplicationPolicy
  attr_reader :user, :role, :record

  def show?
    admin_user? || employee_user?
  end

  def add?
    admin_user? || employee_user?
  end

  def remove?
    admin_user? || employee_user?
  end

  def add_medical_procedure?
    admin_user? || employee_user?
  end

  def add_completed_medical_procedure?
    admin_user? || employee_user?
  end

  def add_to_aviary?
    admin_user? || employee_user?
  end

  def add_sterilization_to_animals?
    admin_user? || employee_user?
  end

  def empty_cart?
    admin_user? || employee_user?
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
