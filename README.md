## To create and seed database

rails db:create && rails db:migrate rails db:seed

## To import all videos to the app

Video.import_all_videos

## APIs

Youtube-data-api

ACR Cloud

## Software depedencies

youtube-dl must be installed locally on the computer

##Useful Methods... If you need to use any of the import steps seperately.

Video.import_channel(channel_id)

Video.match_dancers

Video.match_songs

Video.get_channel_video_ids(channel_id)
