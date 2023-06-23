# frozen_string_literal: true

require "rubygems"
require "sitemap_generator"

SitemapGenerator::Sitemap.default_host = default_host

SitemapGenerator::Sitemap.create do
  add root_path, changefreq: "daily", priority: 0.9
  add contact_path, changefreq: "weekly"

  # Adding static pages
  add privacy_path, changefreq: "monthly"
  add terms_path, changefreq: "monthly"
  add about_path, changefreq: "monthly"
  add contact_path, changefreq: "monthly"

  Video.find_each do |video|
    add watch_path(v: video.youtube_id), lastmod: video.updated_at
  end
end

SitemapGenerator::Sitemap.ping_search_engines
