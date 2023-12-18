# frozen_string_literal: true

# == Schema Information
#
# Table name: dancers
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  user_id         :bigint
#  bio             :text
#  slug            :string
#  reviewed        :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  videos_count    :integer          default(0), not null
#  gender          :enum
#  search_text     :text
#  match_terms     :text             default([]), is an Array
#  nickname        :string
#  normalized_name :string
#  use_trigram     :boolean          default(TRUE), not null
#
require "rails_helper"

RSpec.describe Dancer do
  fixtures :all

  describe ".search" do
    it "returns dancers that match the search term" do
      andrea = Dancer.create!(name: "Andrea Misse", videos_count: 1)
      gabriel = Dancer.create!(name: "Gabriel Missé", videos_count: 2)

      expect(Dancer.search("misse")).to match_array([andrea, gabriel])
    end
  end
end
