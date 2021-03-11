## About the Project

Tangotube.tv

The basic premise of the app is to collect all the tango videos on youtube into one place and provide a tailored search/website which allow users to discover new/good content and to build a community around that.

### The key features are:
clean/consistent formatting of the titles

interactive filtering from the titles in order to promote discovering other videos by clicking on the event or song

dense search results compared to youtube’s 4.

Displaying detailed song information

Advanced tailored filtering/search/autocomplete

Search results tailored toward performances (solves a problem where if you search for a song on youtube you get a lot of album art)

Incorporating an audio content recognition system which detects the song and compares it with an internal song database which allows more correct information such as genre, publication date, singer, author etc.

Lyrics education which allows people to more easily read the lyrics of the performances
wikipedia style community driven corrections to improve the database for videos which aren’t able to be recognized by the acr system or string matching

### Future features
Education system for creating slo motion playback of specific movements and creating a library/categorizing system that would be shared amongst dancers

Community interactions such as comments, social interaction, and sharing

Creating playlists

Dancer specific pages

## To create and seed database

rails db:create && rails db:migrate rails db:seed

## To Allow global search

rake refreshers:videos_searches

## APIs

Youtube-data-api

ACR Cloud

Spotify

## Software depedencies

youtube-dl must be installed locally on the computer for certain import functionality

