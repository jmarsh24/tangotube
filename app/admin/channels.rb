ActiveAdmin.register Channel do
  permit_params :title,
                :channel_id,
                :thumbnail_url,
                :imported,
                :imported_videos_count,
                :total_videos_count,
                :yt_api_pull_count

  config.sort_order = 'id_asc'
  config.per_page = [100, 500, 1000]

  scope :all
  scope :imported
  scope :not_imported

  filter :id
  filter :title
  filter :channel_id
  filter :imported_videos_count
  filter :total_videos_count

  index do
    selectable_column
    id_column
    column 'Image' do |channel|
      image_tag channel.thumbnail_url, size: '40x40' if channel.thumbnail_url.present?
    end
    column 'channel' do |channel|
      link_to(channel.title, "/admin/channels/#{channel.id}", target: :_blank) + ' ' +
        link_to('Youtube', "http://youtube.com/channel/#{channel.channel_id}", target: :_blank) + ' ' +
        link_to('Social Blade', "https://socialblade.com/youtube/channel/#{channel.channel_id}", target: :_blank)
    end
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
      f.input :channel_id, label: 'Channel ID'
      f.input :imported
    end
    f.actions
  end
end
