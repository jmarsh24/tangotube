# TangoTube

A video platform for dancers by dancers, curating, enriching, and organizing tango videos across YouTube.

## Table of Contents

- [TangoTube](#tangotube)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
    - [What is TangoTube?](#what-is-tangotube)
    - [How does it work?](#how-does-it-work)
    - [How did it start?](#how-did-it-start)
  - [Shortcomings of YouTube](#shortcomings-of-youtube)
  - [TangoTube Features](#tangotube-features)
    - [Current Features](#current-features)
    - [Future Features](#future-features)
  - [Development](#development)
    - [Index and Search](#index-and-search)

## Introduction

### What is TangoTube?

TangoTube is a video platform created by dancers, for dancers. Searching for tango videos across the web can be a mess. TangoTube fixes this issue by curating, enriching, and organizing all the tango videos on YouTube, making it easier to search, discover, and enjoy more tango content.

### How does it work?

TangoTube scans for new tango videos across the web, recognizing the dancers in the video, the performance song, event, and location. This information is organized and reformatted so the viewer can see the critical information upfront when choosing which video to watch.

We apply a music recognition system that identifies the song in each tango video and categorizes it with our tango music database. This allows us to identify the correct genre of the music.

By having a platform dedicated specifically to tango, we can better analyze the content viewers are interested in, making better recommendations for new videos.

### How did it start?

The project began during the COVID outbreak in March 2020. A dancer started curating his own tango music library and began discovering and learning about tango music. He realized that the same level of organization would be great to have for YouTube videos. Since then, this project has been a solo endeavor to create a better viewing experience for dancers across the world.

## Shortcomings of YouTube

- YouTube recommends generic, popular tango videos each time because it doesn't know any better. This causes the viewer to watch the same videos over and over without discovering new content.
- No consistency in the labeling and categorization of tango videos.
- Missing information in the title or description (song information, complete leader or follower name, or event info).
- Low display density of videos (4 videos/page). Many maestros can have hundreds of videos, which can take forever to search through.
- Search results are polluted with unrelated content.
- Search results show videos you have already watched first.
- Search results have too much of a priority for newer results.
- Sorting is severely limited. It's not possible to sort by the oldest video.
- Limited to search by keywords.
- All results mixed in with all of the other videos across the web.

## TangoTube Features

### Current Features

- Column Browser (Filtering by genre, leader, follower, orchestra, song title).
- Recommendations to discover new videos you haven't watched before.
- Tango-specific autocomplete results.
- Standardized way of presenting video information.
- High density of video results.
- Ability to view song lyrics from the viewing area.

### Future Features

- Ability to create highlights of your favorite performance moments.
- Searchable practice library.
- Share your highlight snippets with others.
- Search forpractice content by tag name (walking, giros, sacadas, barridas, chains).
- Ability to search by performance at a specific event and year.
- Integration with Spotify and other major music platforms.

## Development

### Index and Search

Some models (e.g., Videos) are indexed in an optimized fashion, requiring a SQL statement to be executed on creation and update. When a model's `index_query` is modified (e.g., new field to search on), it will only affect data being added or modified from this point on. After deploying, it's essential to perform a re-indexing of the affected model by connecting to the specified environment (e.g., `heroku run rails c --app=tangotube-staging`) and performing the following command (using Videos as an example).

```ruby
Video.find_in_batches.each { |e| Video.index!(e.map(&:id), now: false) }
```

Hint: Change to `now: true` for a synchronous action and be aware of when the process has completed. Otherwise, it will be enqueued to _Sidekiq_ and run asynchronously.
