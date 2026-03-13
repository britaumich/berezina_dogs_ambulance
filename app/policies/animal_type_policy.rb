# frozen_string_literal: true

class AnimalTypePolicy  < ApplicationPolicy
  attr_reader :user, :role, :record

  def index?
    admin_user? || employee_user?
  end

  def create?
    admin_user?
  end

  def new?
    create?
  end

  def update?
    admin_user?
  end

  def edit?
    update?
  end

  def destroy?
    admin_user?
  end

end
