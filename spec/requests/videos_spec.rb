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

  describe "GET #new" do
    it "succesfully returns get request" do
      get new_video_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #watch" do
    it "succesfully returns get request" do
      get watch_path, params: { v: "btQ5cluaCQM" }
      expect(response).to have_http_status(:ok)
    end
  end
end
