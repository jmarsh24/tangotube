ActiveAdmin.register Song do

  permit_params :genre, :title, :artist

  config.sort_order = 'id_asc'

  index do
    selectable_column
    id_column
    column :genre
    column :title
    column :artist
    column :artist_2
    actions
  end
end
