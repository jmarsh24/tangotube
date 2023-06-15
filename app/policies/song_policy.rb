# frozen_string_literal: true

class SongPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def new?
    user&.admin?
  end

  def create?
    user&.admin?
  end

  def edit?
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

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
