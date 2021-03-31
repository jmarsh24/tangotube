require "rails_helper"

RSpec.describe "Channels", type: :request do
  describe "GET #index" do
    it "succesfully returns get request" do
      get playlists_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #create" do
    it "succesfully accepts post request" do
      post channels_path, params: { channel: { channel_id: "test" } }
      expect(response).to have_http_status(:found)
    end
  end
end
