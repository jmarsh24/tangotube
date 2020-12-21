ActiveAdmin.register Follower do
  permit_params :name, :reviewed

  index do
    selectable_column
    id_column
    column :name
    column :reviewed
    actions
  end
end
