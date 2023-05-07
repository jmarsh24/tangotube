# frozen_string_literal: true

class DancerPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.present? && user.admin?
  end

  def update?
    user.present? && (user.admin? || record.user_id == user.id)
  end

  def destroy?
    user.present? && (user.admin? || record.user_id == user.id)
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
