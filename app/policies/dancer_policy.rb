# frozen_string_literal: true

class DancerPolicy < ApplicationPolicy
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

  def search?
    true
  end

  def act_on?
    user&.admin?
  end

  def search?
    true
  end

  def upload_profile_image?
    user&.admin?
  end

  def remove_profile_image?
    user&.admin?
  end

  def download_profile_image?
    user&.admin?
  end

  def upload_cover_image?
    user&.admin?
  end

  def remove_cover_image?
    user&.admin?
  end

  def download_cover_image?
    user&.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
