# frozen_string_literal: true

class Watch < ApplicationRecord
  belongs_to :user
  belongs_to :video
end
