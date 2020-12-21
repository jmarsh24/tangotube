ActiveAdmin.register Channel do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :title, :channel_id, :thumbnail_url, :imported, :imported_videos_count, :total_videos_count,
                :yt_api_pull_count

  index do
    selectable_column
    id_column
    column :title
    column :channel_id
    column :imported
    column :imported_videos_count
    column :total_videos_count
    actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :channel_id
      f.input :imported
    end
    f.actions
  end

end
