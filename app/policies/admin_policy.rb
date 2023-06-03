class AdminPolicy < ApplicationPolicy
  def access?(record)
    user&.admin?
  end

  def create?
    access?(record)
  end

  def update?
    access?(record)
  end

  def destroy?
    access?(record)
  end
end
