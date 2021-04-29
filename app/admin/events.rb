ActiveAdmin.register Event do
  permit_params :title,
                :city,
                :country,
                :category,
                :start_date,
                :end_date,
                :active,
                :reviewed
  actions :all

  config.sort_order = 'id_asc'

  config.per_page = [100, 500, 1000]

  filter :title
  filter :city
  filter :country
  filter :category
  filter :start_date
  filter :end_date

  index do
    selectable_column
    id_column
    column :title
    column :city
    column :country
    column :category
    column :start_date
    column :end_date
    column :active
    actions
  end
end
