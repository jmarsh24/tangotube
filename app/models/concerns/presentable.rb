module Presentable
  def decorate
    "#{self.class}Presenter".constantize.new(self)
  end
end
