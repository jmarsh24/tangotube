# tangotube

## What is TangoTube?

A video platform for dancers by dancers. Searching for tango videos across the web can be a mess. TangoTube fixes this issue by curating, enriching, and organizing all the tango videos across youtube. Making it easier to search, discover and enjoy more tango content.

### How does it work?

TangoTube scans for new tango videos across the web and recognizes the dancers in the video, the performance song, event and location. This information is organized and reformatted so the viewer can see the critical information right up front when choosing which video to watch.

We apply a music recognition system which identifies the song in each tango video and categorizes it with our tango music database. This allows us to identify the correct genre of the music.

By having a platform dedicated to tango specifically, we are able to better analyze the content viewers are interested in to make better recommendations to new videos.

### How did it start?

The project during the COVID outbreak in March of 2020. A dancer started curating his own tango music library and started to discover a learn about tango music. He realized that the same level of organization would be great to have for youtube videos. Since then, this project has been a solo endeavor in order to create a better viewing experience for dancers across the world.

## Shortcomings of YouTube

- Youtube recommends generic popular tango videos each time because it doesn't know any better. This causes the viewer to watch the same videos over and over without discovering new content.
- No consistency to the labeling and categorization of tango videos.
- Missing information in the title or description (song information, complete leader or follower name, or event info)
- Low display density of videos (4 videos/page). Many maestros can have hundreds of videos which can take forever to actually search through.
- Search results are polluted with unrelated content.
- Search results show videos you have already watched first.
- Search results have too much of a priority for newer results.
- Sorting is severely limited. It's not possible to sort by oldest video.
- Limited to search by keywords
- All results mixed in with all of the other videos across the web.

## TangoTube Features

- Column Browser ( Filtering by genre, leader, follower, orchestra, song title)
- Recommendations to new discover new videos you haven't watched before
- Tango specific autocomplete results
- Standardized way of presenting video information
- High density of video results
- Ability to view song lyrics from the viewing area

## Feature TangoTube Features

- Ability to create highlights of your favorite performance moments.
- Searchable practice library
- Share your highlight snippets with other's
- Search for practice content by tag name (walking, giros, sacadas, barridas, chains)
- Ability to search by performance at a specific event and year
- Plug in with Spotify and other major music platforms


# Development
## Index and Search

Some models (ex: Videos) are indexed in an optimized fashion, requiring a SQL statement to be executed on creation and update.
When a model's `index_query` is modified (ex: new field to search on), it will only affect data being added or modified from
this point on. After deploying, it's important to perform a re-indexing of the affected model by connecting to the specified
environment (ex: `heroku run rails c --app=tangotube-staging`) and performing the following command (here Videos as an example).

```ruby
Video.find_in_batches.each { |e| Video.index!(e.map(&:id), now: false) }
```

Hint: Change to `now: true` for a synchronous action and be aware of when the process has completed. Otherwise, it will be
enqueued to _Sidekiq_ and run asynchronously.

## Skylight

When configured, _Skylight_ is normally automatically enabled. To prevent this behavior, it's now
needed to set ENV `SKYLIGHT_EXPLICIT_ENABLED` to `true`

When disabled, this confusing warning appears in the log. It is simply what _Skylight_ outputs when
either `SKYLIGHT_ENABLED` is set to `false`, or when `SKYLIGHT_EXPLICIT_ENABLED` is not explicitly
set to `true`.

> WARN -- Skylight: [SKYLIGHT] [5.3.4] You are running in the production environment but haven't added it to config.skylight.environments, so no data will be sent to Skylight servers.

### Caching in Development

Run `rails cache:dev` to toggle caching.
