ActiveAdmin.register Videotype do
  permit_params :name, :related_keywords
  config.sort_order = 'id_asc'
end
