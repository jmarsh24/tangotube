# frozen_string_literal: true

require "rails_helper"

RSpec.describe Spotify::API do
  it "returns an access token", :vcr do
    api = Spotify::API.new
    token = api.access_token
    expect(token).not_to be_nil
  end
end
