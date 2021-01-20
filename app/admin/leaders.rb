ActiveAdmin.register Leader do
  permit_params :name, :reviewed, :nickname

  config.sort_order = 'id_asc'

  scope :all
  scope :reviewed
  scope :not_reviewed

  filter :name
  filter :nickname
  filter :revised

  config.sort_order = 'id_asc'
  config.per_page = [100, 500, 1000]

  index do
    selectable_column
    id_column
    column :name
    column :first_name
    column :last_name
    column :nickname
    column :reviewed
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :first_name
      f.input :last_name
      f.input :nickname
      f.input :reviewed
    end
    f.actions
  end
end
