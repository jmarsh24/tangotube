# frozen_string_literal: true

SitemapGenerator::Sitemap.public_path = "tmp/"
SitemapGenerator::Sitemap.adapter = Shimmer::SitemapAdapter.new

SitemapGenerator::Sitemap.default_host = "https://tangotube.tv"

SitemapGenerator::Sitemap.create do
  add new_contacts_path, changefreq: "weekly"

  # Adding static pages
  add privacy_path, changefreq: "monthly"
  add terms_path, changefreq: "monthly"
  add about_path, changefreq: "monthly"
  add new_contacts_path, changefreq: "monthly"

  Video.find_each do |video|
    add watch_path(v: video.youtube_id), lastmod: video.updated_at
  end
end

SitemapGenerator::Sitemap.ping_search_engines
