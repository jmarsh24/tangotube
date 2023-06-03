class VideoPolicy < ApplicationPolicy
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

  def like?
    user.present? 
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end