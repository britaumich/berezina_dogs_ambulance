# frozen_string_literal: true

class CartPolicy < ApplicationPolicy
  attr_reader :user, :record

  def show?
    authenticated?
  end

  def add?
    authenticated?
  end

  def remove?
    authenticated?
  end

  def add_medical_procedure?
    authenticated?
  end

  def add_completed_medical_procedure?
    authenticated?
  end

  def add_to_aviary?
    authenticated?
  end

  def add_sterilization_to_animals?
    authenticated?
  end

  def empty_cart?
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
