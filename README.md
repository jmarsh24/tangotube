Seeding information

In order to properly load the database into your system, you will need to comment out the belongs_to relations in the video.rb file.

Lines 41-45 in video.rb

belongs_to :leader

belongs_to :follower

belongs_to :song

belongs_to :videotype

belongs_to :event

Then seed the database normally. After these will need to be uncommented in order for the application to function.
