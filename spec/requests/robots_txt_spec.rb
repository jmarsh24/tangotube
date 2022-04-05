require "rails_helper"

describe "robots.txt" do
  context "when not blocking all web crawlers" do
    it "allows all crawlers" do
      get "/robots.txt"

      expect(response.code).to eq "404"
      expect(response.headers["X-Robots-Tag"]).to be_nil
    end
  end

  context "when blocking all web crawlers" do
    it "blocks all crawlers" do
      ClimateControl.modify "DISALLOW_ALL_WEB_CRAWLERS" => "true" do
        get "/robots.txt"
      end

      expect(response).to render_template "disallow_all"
      expect(response.headers["X-Robots-Tag"]).to eq "none"
    end
  end
end
