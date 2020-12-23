ActiveAdmin.register Follower do
  permit_params :name, :reviewed, :nickname
  index do
    selectable_column
    id_column
    column :name
    column :nickname
    column :reviewed
    default_actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :nickname
      f.input :reviewed
    end
    f.default_actions
  end

end
