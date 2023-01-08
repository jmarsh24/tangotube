# frozen_string_literal: true

# == Schema Information
#
# Table name: performances
#
#  id           :bigint           not null, primary key
#  date         :date
#  videos_count :integer
#  slug         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require "rails_helper"

RSpec.describe Performance do
  pending "add some examples to (or delete) #{__FILE__}"
end
