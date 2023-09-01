# frozen_string_literal: true

class ChannelPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user&.admin?
  end

  def update?
    user&.admin?
  end

  def destroy?
    user&.admin?
  end

  def act_on?
    user&.admin?
  end

  def deactivate?
    user&.admin?
  end

  def search?
    user&.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
