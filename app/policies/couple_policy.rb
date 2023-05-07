# frozen_string_literal: true

class CouplesPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.present?
  end

  def update?
    user.present? && user == couple.dancer.user
  end

  def destroy?
    user.present? && user == couple.dancer.user
  end

  private

  def couple
    record
  end
end
