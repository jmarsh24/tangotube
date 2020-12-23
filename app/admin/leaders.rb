ActiveAdmin.register Leader do
  permit_params :name, :reviewed

  index do
    selectable_column
    id_column
    column :name
    column :nickname
    column :reviewed
    actions
  end

end
