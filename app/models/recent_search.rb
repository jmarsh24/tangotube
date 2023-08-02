class RecentSearch < ApplicationRecord
  belongs_to :user
  belongs_to :searchable, polymorphic: true
end
