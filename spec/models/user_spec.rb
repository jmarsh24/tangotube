# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#  first_name             :string
#  last_name              :string
#  image                  :string
#  uid                    :string
#  provider               :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  role                   :integer
#
require "rails_helper"

RSpec.describe User do
  fixtures :all

  let(:admin_user) { users(:admin) }
  let(:user) { users(:normal_user) }

  context "validation tests" do
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
