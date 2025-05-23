# frozen_string_literal: true

class AviaryPolicy  < ApplicationPolicy
  attr_reader :user, :record

  def index?
    authenticated?
  end

  def show?
    authenticated?
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
