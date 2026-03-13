# frozen_string_literal: true

class NotePolicy  < ApplicationPolicy
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

end
