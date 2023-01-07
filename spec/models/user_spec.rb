require "rails_helper"

RSpec.describe User do
  context "validation tests" do
    let(:user) { build(:user) }

    it "is valid with valid attributes" do
      user.first_name = "John"
      user.last_name = "Doe"
      user.email = "sample@example.com"
      user.password = "password"
      expect(user.save).to be(true)
    end

    it "is not valid without a password" do
      user.password = nil
      expect(user.save).to be(false)
    end

    it "is not valid without an email" do
      user.email = nil
      expect(user.save).to be(false)
    end

    it "ensures last name presence" do
      user = described_class.new(first_name: "First", email: "sample@example.com", password: "password").save
      expect(user).to be(false)
    end

    it "ensures last name presence" do
      user = described_class.new(first_name: "First", last_name: "Last", password: "password").save
      expect(user).to be(false)
    end

    it "ensures last name presence" do
      user = described_class.new(first_name: "First", last_name: "Last", email: "sample@example.com", password: "password").save
      expect(user).to be(true)
    end

    # context "scope tests" do
    #   let(:params) { { first_name: "First", last_name: "Last", email: "sample@example.com" } }

    #   before do
    #     User.new(params).save
    #     User.new(params).save
    #     User.new((params).merge(active: true)).save
    #     User.new((params).merge(active: false)).save
    #     User.new((params).merge(active: false)).save
    #   end
    # end
      # it 'should return active users' do
      #   expect(User.active_users.size).to eq(3)
      # end
      # it 'should return inactive users' do
      #   expect(User.inactive_users.size).to eq(2)
      # end
  end
end
