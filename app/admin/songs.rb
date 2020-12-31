ActiveAdmin.register Song do
  permit_params :genre, :title, :artist, :artist_2, :active, :last_name_search, :date

  config.sort_order = 'id_asc'

  index do
    selectable_column
    id_column
    column :genre
    column :title
    column :artist
    column :artist_2
    column :last_name_search
    toggle_bool_column :active
    column :date
    actions
  end
end
