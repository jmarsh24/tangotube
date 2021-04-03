require "rails_helper"

RSpec.describe "Videos", type: :request do
  describe "GET #index" do
    it "succesfully returns get request" do
      get videos_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #new" do
    it "succesfully returns get request" do
      get new_video_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #create" do
    it "succesfully accepts post request" do
      post videos_path, params: { video: { youtube_id: "test" } }
      expect(response).to have_http_status(:found)
    end
  end
end
