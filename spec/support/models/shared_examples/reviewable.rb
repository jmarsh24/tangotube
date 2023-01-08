# frozen_string_literal: true

RSpec.shared_examples "a reviewable" do |factory_name|
  describe ".reviewed" do
    it "includes objects with reviewed flagged" do
      reviewed = create(factory_name, reviewed: true)
      unreviewed = create(factory_name, reviewed: false)
      expect(described_class.reviewed).to include(reviewed)
      expect(described_class.reviewed).not_to include(unreviewed)
    end
  end
end
