# frozen_string_literal: true

class ChannelPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user_signed_in?
  end

  def update?
    user_signed_in? && @record.user == current_user
  end

  def destroy?
    user_signed_in? && @record.user == current_user
  end

  def deactivate?
    user_signed_in? && @record.user == current_user
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
