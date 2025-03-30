# frozen_string_literal: true

class AnimalPolicy  < ApplicationPolicy
  attr_reader :user, :record

  def index?
    true
  end

  def show?
    true
  end

  def duplicate?
    create?
  end

  def create?
    authenticated?
  end

  def new?
    create?
  end

  def update?
    authenticated?
  end

  def edit?
    update?
  end

  def destroy?
    authenticated?
  end

  def upload_pictures?
    authenticated?
  end

  def delete_picture?
    authenticated?
  end

  def delete_medical_procedure?
    authenticated?
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NoMethodError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end
end
