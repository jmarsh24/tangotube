require "rails_helper"

RSpec.describe "Channels", type: :request do
  describe "GET #index" do
    it "succesfully returns get request" do
      get playlists_path
      expect(response).to have_http_status(:ok)
    end
  end
end
