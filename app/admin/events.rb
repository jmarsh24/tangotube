ActiveAdmin.register Event do
  permit_params :name, :city, :country, :date
  config.sort_order = 'id_asc'
end
