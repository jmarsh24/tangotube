RSpec.shared_examples "reviewable" do
    describe "#reviewed"
    it "includes leaders with reviewed flagged" do
      object = described_class.create(name: 'John Doe', first_name: 'John', last_name: 'Doe', reviewed: true)
      expect(described_class.reviewed).to include(object)
    end

    describe "#not_reviewed"
    it "includes leaders without reviewed flagged" do
      object = described_class.create(name: 'John Doe', first_name: 'John', last_name: 'Doe', reviewed: false)
      expect(described_class.not_reviewed).to include(object)
    end
end
