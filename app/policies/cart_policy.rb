# frozen_string_literal: true

class CartPolicy < ApplicationPolicy
  attr_reader :user, :record

  def add?
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
