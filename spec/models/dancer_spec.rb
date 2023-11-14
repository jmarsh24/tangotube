# frozen_string_literal: true

# == Schema Information
#
# Table name: dancers
#
#  id           :bigint           not null, primary key
#  name         :string           not null
#  user_id      :bigint
#  bio          :text
#  slug         :string
#  reviewed     :boolean          default(FALSE), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  videos_count :integer          default(0), not null
#  gender       :enum
#  search_text  :text
#  match_terms  :text             default([]), is an Array
#  nickname     :string
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

  describe ".match_by_name" do
    it "returns dancers that match the name" do
      text = "Performance by Carlitos Espinoza & Noelia Hurtado - Sobre el Pucho - MSTF 2022 "
      expect(Dancer.match_by_name(text:).map(&:name)).to match_array(["Carlitos Espinoza", "Noelia Hurtado"])
    end
  end

  describe ".match_by_terms" do
    it "returns dancers that match the terms" do
      text = "Performance by Matching Term & Noelia Hurtado - Sobre el Pucho - MSTF 2022 "
      dancers(:carlitos).update!(match_terms: ["matching term"])
      expect(Dancer.match_by_terms(text:).map(&:name)).to match_array(["Carlitos Espinoza"])
    end
  end
end
