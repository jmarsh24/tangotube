# frozen_string_literal: true

class ClipPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def new?
    create?
  end

  def create?
    user.present?
  end

  def edit?
    update?
  end

  def update?
    user.present? && user == record.user
  end

  def destroy?
    user.present? && user == record.user
  end
end
