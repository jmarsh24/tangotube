# frozen_string_literal: true

namespace :env do
  desc "Clears local storage (delete all files) and known temporary files"
  task clean: "tmp:clear" do
    sh "rm -rf storage"
    sh "mkdir storage"
    sh "touch storage/.keep"

    sh "rm -rf tmp/theme_extractor_unzip"
  end
end
