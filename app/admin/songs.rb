ActiveAdmin.register Song do
  permit_params :genre,
                :title,
                :artist,
                :artist_2,
                :active,
                :last_name_search,
                :date
  actions :all

  config.sort_order = "id_asc"

  config.per_page = [100, 500, 1000]

  scope :filter_by_active
  scope :filter_by_not_active
  scope :filter_by_popularity

  filter :genre, as: :select, multiple: true
  filter :title
  filter :artist
  filter :artist_2
  filter :last_name_search
  filter :active

  index do
    selectable_column
    id_column
    column :genre
    column :title
    column :artist
    column :artist_2
    column :last_name_search
    column :date
    column :active
    column :popularity
    actions
  end
end
