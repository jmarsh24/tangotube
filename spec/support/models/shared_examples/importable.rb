# frozen_string_literal: true

RSpec.shared_examples "an importable" do |factory_name|
  describe ".imported" do
    it "includes objects with imported flagged" do
      imported = create(factory_name, imported: true)
      not_imported = create(factory_name, imported: false)
      expect(described_class.imported).to include(imported)
      expect(described_class.imported).not_to include(not_imported)
    end
  end
end
