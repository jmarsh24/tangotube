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
  describe "#full_name_search" do
    it "finds a searched follower by name" do
      object = described_class.create(name: "John Doe", first_name: "John", last_name: "Doe")
      @result = described_class.full_name_search("John Doe")
      expect(@result).to include(object)
    end
  end
  describe "#full_name_search" do
    it "finds a searched follower by ending of name" do
      object = described_class.create(name: "John Doe", first_name: "John", last_name: "Doe")
      @result = described_class.full_name_search("ohn Doe")
      expect(@result).to include(object)
    end
  end
  describe "#full_name_search" do
    it "finds a searched follower by beginning of name" do
      object = described_class.create(name: "John Doe", first_name: "John", last_name: "Doe")
      @result = described_class.full_name_search("John D")
      expect(@result).to include(object)
    end
  end
  describe "#full_name_search" do
    it "finds a searched follower by with case insensitivity" do
      object = described_class.create(name: "John Doe", first_name: "John", last_name: "Doe")
      @result = described_class.full_name_search("John Doe")
      expect(@result).to include(object)
      @result = described_class.full_name_search("John Doe")
      expect(@result).to include(object)
    end
  end
end
