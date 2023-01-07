require "rails_helper"

RSpec.describe Playlist do
  it_behaves_like "an importable", :playlist
end
