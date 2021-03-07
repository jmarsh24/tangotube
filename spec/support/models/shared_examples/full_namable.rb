RSpec.shared_examples "a full nameable" do
  describe "#full_name" do
     it 'returns first name last name' do
      object = described_class.new(first_name: "John", last_name: "Doe")
      expect(object.full_name).to eq("John Doe")
    end
  end

  describe "#abrev_name" do
    it "returns first name initial and last name" do
      object = described_class.new(first_name: "John", last_name: "Doe")
      expect(object.abrev_name).to eq("J. Doe")
    end
  end

  describe "#abrev_name_nospace" do
    it "returns first name initial and last name without space" do
      object = described_class.new(first_name: "John", last_name: "Doe")
      expect(object.abrev_name_nospace).to eq("J.Doe")
    end
  end
end
