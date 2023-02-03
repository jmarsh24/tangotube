# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include Yael::Publisher

  self.abstract_class = true
end
