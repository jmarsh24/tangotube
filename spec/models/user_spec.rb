require "rails_helper"

RSpec.describe User, type: :model do
  # context "validation tests" do

    # it "is valid with valid attributes" do
    #   expect(user.save).to eq(true)
    # end

    # it "is not valid without a password" do
    #   user.password = nil
    #   expect(user.save).to eq(false)
    # end

    # it "is not valid without an email" do
    #   user.email = nil
    #   expect(user.save).to eq(false)
    # end

    # it 'ensures last name presence' do
    #   user = User.new(first_name: 'First', email: 'sample@example.com').save
    #   expect(user).to eq(false)
    # end

    # it 'ensures last name presence' do
    #   user = User.new(first_name: 'First', last_name: 'Last').save
    #   expect(user).to eq(false)
    # end

    # it 'ensures last name presence' do
    #   user = User.new(first_name: 'First', last_name: 'Last', email: 'sample@example.com').save
    #   expect(user).to eq(true)
    # end

    # context 'scope tests' do
    #   let(:params) { { first_name: 'First', last_name: 'Last', email: 'sample@example.com' } }
    #   before(:each) do
    #     User.new(params).save
    #     User.new(params).save
    #     User.new((params).merge(active: true)).save
    #     User.new((params).merge(active: false)).save
    #     User.new((params).merge(active: false)).save
    #   end

    #   it 'should return active users' do
    #     expect(User.active_users.size).to eq(3)
    #   end
    #   it 'should return inactive users' do
    #     expect(User.inactive_users.size).to eq(2)
    #   end
  # end
end
