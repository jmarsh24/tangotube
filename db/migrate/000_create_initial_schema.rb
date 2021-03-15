class CreateInitialSchema < ActiveRecord::Migration[6.1]
  def up
    statements = <<-eos
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;
SET default_tablespace = '';
SET default_table_access_method = heap;
CREATE TABLE public.admin_users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.admin_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.admin_users_id_seq OWNED BY public.admin_users.id;
CREATE TABLE public.ahoy_events (
    id bigint NOT NULL,
    visit_id bigint,
    user_id bigint,
    name character varying,
    properties jsonb,
    "time" timestamp without time zone
);
CREATE SEQUENCE public.ahoy_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.ahoy_events_id_seq OWNED BY public.ahoy_events.id;
CREATE TABLE public.ahoy_visits (
    id bigint NOT NULL,
    visit_token character varying,
    visitor_token character varying,
    user_id bigint,
    ip character varying,
    user_agent text,
    referrer text,
    referring_domain character varying,
    landing_page text,
    browser character varying,
    os character varying,
    device_type character varying,
    country character varying,
    region character varying,
    city character varying,
    latitude double precision,
    longitude double precision,
    utm_source character varying,
    utm_medium character varying,
    utm_term character varying,
    utm_content character varying,
    utm_campaign character varying,
    app_version character varying,
    os_version character varying,
    platform character varying,
    started_at timestamp without time zone
);
CREATE SEQUENCE public.ahoy_visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.ahoy_visits_id_seq OWNED BY public.ahoy_visits.id;
CREATE TABLE public.channels (
    id bigint NOT NULL,
    title character varying,
    channel_id character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    thumbnail_url character varying,
    imported boolean DEFAULT false,
    imported_videos_count integer DEFAULT 0,
    total_videos_count integer DEFAULT 0,
    yt_api_pull_count integer DEFAULT 0,
    reviewed boolean DEFAULT false
);
CREATE SEQUENCE public.channels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.channels_id_seq OWNED BY public.channels.id;
CREATE TABLE public.events (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    title character varying,
    city character varying,
    country character varying,
    category character varying,
    start_date date,
    end_date date,
    active boolean DEFAULT true,
    reviewed boolean DEFAULT false
);
CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;
CREATE TABLE public.followers (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    reviewed boolean,
    nickname character varying,
    first_name character varying,
    last_name character varying
);
CREATE SEQUENCE public.followers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.followers_id_seq OWNED BY public.followers.id;
CREATE TABLE public.leaders (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    reviewed boolean,
    nickname character varying,
    first_name character varying,
    last_name character varying
);
CREATE SEQUENCE public.leaders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.leaders_id_seq OWNED BY public.leaders.id;
CREATE TABLE public.playlists (
    id bigint NOT NULL,
    slug character varying,
    title character varying,
    description character varying,
    channel_title character varying,
    channel_id character varying,
    video_count character varying,
    imported boolean DEFAULT false,
    videos_id bigint,
    user_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.playlists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.playlists_id_seq OWNED BY public.playlists.id;
CREATE TABLE public.search_suggestions (
    id bigint NOT NULL,
    term character varying,
    popularity integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.search_suggestions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.search_suggestions_id_seq OWNED BY public.search_suggestions.id;
CREATE TABLE public.songs (
    id bigint NOT NULL,
    genre character varying,
    title character varying,
    artist character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    artist_2 character varying,
    composer character varying,
    author character varying,
    date date,
    last_name_search character varying,
    occur_count integer DEFAULT 0,
    popularity integer DEFAULT 0,
    active boolean DEFAULT true,
    lyrics text
);
CREATE SEQUENCE public.songs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.songs_id_seq OWNED BY public.songs.id;
CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);
CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
CREATE TABLE public.videos (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    title text,
    youtube_id character varying,
    leader_id bigint,
    follower_id bigint,
    description character varying,
    duration integer,
    upload_date date,
    view_count integer,
    tags character varying,
    song_id bigint,
    youtube_song character varying,
    youtube_artist character varying,
    acrid character varying,
    spotify_album_id character varying,
    spotify_album_name character varying,
    spotify_artist_id character varying,
    spotify_artist_id_2 character varying,
    spotify_artist_name character varying,
    spotify_artist_name_2 character varying,
    spotify_track_id character varying,
    spotify_track_name character varying,
    youtube_song_id character varying,
    isrc character varying,
    acr_response_code integer,
    channel_id bigint,
    scanned_song boolean DEFAULT false,
    hidden boolean DEFAULT false,
    hd boolean DEFAULT false,
    popularity integer DEFAULT 0,
    like_count integer DEFAULT 0,
    dislike_count integer DEFAULT 0,
    favorite_count integer DEFAULT 0,
    comment_count integer DEFAULT 0,
    event_id bigint,
    scanned_youtube_music boolean DEFAULT false,
    click_count integer DEFAULT 0,
    spotify_artist_id_1 character varying,
    spotify_artist_name_1 character varying
);
CREATE SEQUENCE public.videos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.videos_id_seq OWNED BY public.videos.id;
CREATE MATERIALIZED VIEW public.videos_searches AS
 SELECT videos.id AS video_id,
    (((((((((((((((to_tsvector('english'::regconfig, COALESCE(videos.title, ''::text)) || to_tsvector('english'::regconfig, (COALESCE(videos.description, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(videos.youtube_id, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(videos.youtube_artist, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(videos.youtube_song, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(videos.spotify_track_name, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(videos.spotify_artist_name, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(channels.title, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(channels.channel_id, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(leaders.name, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(leaders.nickname, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(followers.name, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(followers.nickname, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(songs.genre, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(songs.title, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(songs.artist, ''::character varying))::text)) AS tsv_document
   FROM ((((public.videos
     LEFT JOIN public.channels ON ((channels.id = videos.channel_id)))
     LEFT JOIN public.followers ON ((followers.id = videos.follower_id)))
     LEFT JOIN public.leaders ON ((leaders.id = videos.leader_id)))
     LEFT JOIN public.songs ON ((songs.id = videos.song_id)))
  WITH NO DATA;
ALTER TABLE ONLY public.admin_users ALTER COLUMN id SET DEFAULT nextval('public.admin_users_id_seq'::regclass);
ALTER TABLE ONLY public.ahoy_events ALTER COLUMN id SET DEFAULT nextval('public.ahoy_events_id_seq'::regclass);
ALTER TABLE ONLY public.ahoy_visits ALTER COLUMN id SET DEFAULT nextval('public.ahoy_visits_id_seq'::regclass);
ALTER TABLE ONLY public.channels ALTER COLUMN id SET DEFAULT nextval('public.channels_id_seq'::regclass);
ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);
ALTER TABLE ONLY public.followers ALTER COLUMN id SET DEFAULT nextval('public.followers_id_seq'::regclass);
ALTER TABLE ONLY public.leaders ALTER COLUMN id SET DEFAULT nextval('public.leaders_id_seq'::regclass);
ALTER TABLE ONLY public.playlists ALTER COLUMN id SET DEFAULT nextval('public.playlists_id_seq'::regclass);
ALTER TABLE ONLY public.search_suggestions ALTER COLUMN id SET DEFAULT nextval('public.search_suggestions_id_seq'::regclass);
ALTER TABLE ONLY public.songs ALTER COLUMN id SET DEFAULT nextval('public.songs_id_seq'::regclass);
ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
ALTER TABLE ONLY public.videos ALTER COLUMN id SET DEFAULT nextval('public.videos_id_seq'::regclass);
ALTER TABLE ONLY public.channels
    ADD CONSTRAINT channels_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.followers
    ADD CONSTRAINT followers_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.leaders
    ADD CONSTRAINT leaders_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.songs
    ADD CONSTRAINT songs_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.videos
    ADD CONSTRAINT videos_pkey PRIMARY KEY (id);
CREATE MATERIALIZED VIEW public.mat_videos AS
 SELECT videos.id AS video_id,
    (((((((((((((((to_tsvector('english'::regconfig, COALESCE(videos.title, ''::text)) || to_tsvector('english'::regconfig, (COALESCE(videos.description, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(videos.youtube_id, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(videos.youtube_artist, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(videos.youtube_song, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(videos.spotify_track_name, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(videos.spotify_artist_name, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(channels.title, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(channels.channel_id, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(leaders.name, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(leaders.nickname, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(followers.name, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(followers.nickname, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(songs.genre, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(songs.title, ''::character varying))::text)) || to_tsvector('english'::regconfig, (COALESCE(songs.artist, ''::character varying))::text)) AS tsv_document
   FROM ((((public.videos
     JOIN public.channels ON ((channels.id = videos.channel_id)))
     JOIN public.followers ON ((followers.id = videos.follower_id)))
     JOIN public.leaders ON ((leaders.id = videos.leader_id)))
     JOIN public.songs ON ((songs.id = videos.song_id)))
  GROUP BY videos.id, channels.id, followers.id, leaders.id, songs.id
  WITH NO DATA;
ALTER TABLE ONLY public.admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.playlists
    ADD CONSTRAINT playlists_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.search_suggestions
    ADD CONSTRAINT search_suggestions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
CREATE UNIQUE INDEX index_admin_users_on_email ON public.admin_users USING btree (email);
CREATE UNIQUE INDEX index_admin_users_on_reset_password_token ON public.admin_users USING btree (reset_password_token);
CREATE INDEX index_ahoy_events_on_name_and_time ON public.ahoy_events USING btree (name, "time");
CREATE INDEX index_ahoy_events_on_properties ON public.ahoy_events USING gin (properties jsonb_path_ops);
CREATE INDEX index_ahoy_events_on_user_id ON public.ahoy_events USING btree (user_id);
CREATE INDEX index_ahoy_events_on_visit_id ON public.ahoy_events USING btree (visit_id);
CREATE INDEX index_ahoy_visits_on_user_id ON public.ahoy_visits USING btree (user_id);
CREATE UNIQUE INDEX index_ahoy_visits_on_visit_token ON public.ahoy_visits USING btree (visit_token);
CREATE INDEX index_events_on_title ON public.events USING btree (title);
CREATE INDEX index_followers_on_name ON public.followers USING btree (name);
CREATE INDEX index_leaders_on_name ON public.leaders USING btree (name);
CREATE INDEX index_mat_videos_on_tsv_document ON public.mat_videos USING gin (tsv_document);
CREATE UNIQUE INDEX index_mat_videos_on_video_id ON public.mat_videos USING btree (video_id);
CREATE INDEX index_playlists_on_user_id ON public.playlists USING btree (user_id);
CREATE INDEX index_playlists_on_videos_id ON public.playlists USING btree (videos_id);
CREATE INDEX index_songs_on_artist ON public.songs USING btree (artist);
CREATE INDEX index_songs_on_genre ON public.songs USING btree (genre);
CREATE INDEX index_songs_on_title ON public.songs USING btree (title);
CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);
CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);
CREATE INDEX index_videos_on_channel_id ON public.videos USING btree (channel_id);
CREATE INDEX index_videos_on_event_id ON public.videos USING btree (event_id);
CREATE INDEX index_videos_on_follower_id ON public.videos USING btree (follower_id);
CREATE INDEX index_videos_on_leader_id ON public.videos USING btree (leader_id);
CREATE INDEX index_videos_on_song_id ON public.videos USING btree (song_id);
CREATE INDEX index_videos_searches_on_tsv_document ON public.videos_searches USING gin (tsv_document);
ALTER TABLE ONLY public.playlists
    ADD CONSTRAINT fk_rails_180bd29355 FOREIGN KEY (videos_id) REFERENCES public.videos(id);
ALTER TABLE ONLY public.videos
    ADD CONSTRAINT fk_rails_7ebce950d2 FOREIGN KEY (event_id) REFERENCES public.events(id);
ALTER TABLE ONLY public.playlists
    ADD CONSTRAINT fk_rails_d67ef1eb45 FOREIGN KEY (user_id) REFERENCES public.users(id);
SET search_path TO "$user", public;
eos
    statements.split(";
").each {|s| execute s}
  end

  def down
    statements = <<-eos
DROP SEQUENCE public.videos_id_seq CASCADE;
DROP TABLE public.videos CASCADE;
DROP SEQUENCE public.users_id_seq CASCADE;
DROP TABLE public.users CASCADE;
DROP SEQUENCE public.songs_id_seq CASCADE;
DROP TABLE public.songs CASCADE;
DROP SEQUENCE public.search_suggestions_id_seq CASCADE;
DROP TABLE public.search_suggestions CASCADE;
DROP SEQUENCE public.playlists_id_seq CASCADE;
DROP TABLE public.playlists CASCADE;
DROP SEQUENCE public.leaders_id_seq CASCADE;
DROP TABLE public.leaders CASCADE;
DROP SEQUENCE public.followers_id_seq CASCADE;
DROP TABLE public.followers CASCADE;
DROP SEQUENCE public.events_id_seq CASCADE;
DROP TABLE public.events CASCADE;
DROP SEQUENCE public.channels_id_seq CASCADE;
DROP TABLE public.channels CASCADE;
DROP SEQUENCE public.ahoy_visits_id_seq CASCADE;
DROP TABLE public.ahoy_visits CASCADE;
DROP SEQUENCE public.ahoy_events_id_seq CASCADE;
DROP TABLE public.ahoy_events CASCADE;
DROP SEQUENCE public.admin_users_id_seq CASCADE;
DROP TABLE public.admin_users CASCADE;
eos
    statements.split(";
").each {|s| execute s}
  end
end
