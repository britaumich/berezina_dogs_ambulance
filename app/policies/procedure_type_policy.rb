# frozen_string_literal: true

class ProcedureTypePolicy  < ApplicationPolicy
  attr_reader :user, :role, :record

  def index?
    admin_user? || employee_user?
  end

  def create?
    admin_user? || employee_user?
  end

  def new?
    create?
  end

  def update?
    admin_user? || employee_user?
  end

  def edit?
    update?
  end

  def destroy?
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
