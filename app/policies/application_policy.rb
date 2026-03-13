# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :role, :record

  def initialize(context, record)
    @user = context[:user]
    @role = context[:role]
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  private
  
  def authenticated?
    user.present?
  end

  def admin_user?
    authenticated? && role == 'admin'
  end

  def employee_user?
    authenticated? && role == 'employee'
  end

end
