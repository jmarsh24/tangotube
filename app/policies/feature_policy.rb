class FeaturePolicy < ApplicationPolicy
  def create?
    user_is_admin?
  end

  def destroy?
    user_is_admin?
  end

  private

  def user_is_admin?
    user.present? && user.admin?
  end
end
