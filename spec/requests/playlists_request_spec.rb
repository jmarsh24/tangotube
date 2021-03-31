require "rails_helper"

RSpec.describe "Playlists", type: :request do
  describe "GET #index" do
    it "succesfully returns get request" do
      get channels_path
      expect(response).to have_http_status(:ok)
    end
  end
end
