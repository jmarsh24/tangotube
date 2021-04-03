require "rails_helper"

RSpec.describe "StaticPages", type: :request do
  describe "GET static pages" do
    it "gets terms page" do
      get terms_path
      expect(response).to have_http_status(:ok)
    end

    it "gets privacy page" do
      get privacy_path
      expect(response).to have_http_status(:ok)
    end

    it "gets about page" do
      get about_path
      expect(response).to have_http_status(:ok)
    end

    it "gets terms page" do
      get terms_path
      expect(response).to have_http_status(:ok)
    end
  end
end
