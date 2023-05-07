# frozen_string_literal: true

module Presentable
  def decorate
    "#{self.class}Presenter".constantize.new(self)
  end
end
