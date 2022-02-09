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

--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- Name: unaccentdict; Type: TEXT SEARCH CONFIGURATION; Schema: public; Owner: -
--

CREATE TEXT SEARCH CONFIGURATION public.unaccentdict (
    PARSER = pg_catalog."default" );

ALTER TEXT SEARCH CONFIGURATION public.unaccentdict
    ADD MAPPING FOR asciiword WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccentdict
    ADD MAPPING FOR word WITH public.unaccent, simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccentdict
    ADD MAPPING FOR numword WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccentdict
    ADD MAPPING FOR email WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccentdict
    ADD MAPPING FOR url WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccentdict
    ADD MAPPING FOR host WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccentdict
    ADD MAPPING FOR sfloat WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccentdict
    ADD MAPPING FOR version WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccentdict
    ADD MAPPING FOR hword_numpart WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccentdict
    ADD MAPPING FOR hword_part WITH public.unaccent, simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccentdict
    ADD MAPPING FOR hword_asciipart WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccentdict
    ADD MAPPING FOR numhword WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccentdict
    ADD MAPPING FOR asciihword WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccentdict
    ADD MAPPING FOR hword WITH public.unaccent, simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccentdict
    ADD MAPPING FOR url_path WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccentdict
    ADD MAPPING FOR file WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccentdict
    ADD MAPPING FOR "float" WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccentdict
    ADD MAPPING FOR "int" WITH simple;

ALTER TEXT SEARCH CONFIGURATION public.unaccentdict
    ADD MAPPING FOR uint WITH simple;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ahoy_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ahoy_events (
    id bigint NOT NULL,
    visit_id bigint,
    user_id bigint,
    name character varying,
    properties jsonb,
    "time" timestamp without time zone
);


--
-- Name: ahoy_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ahoy_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ahoy_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ahoy_events_id_seq OWNED BY public.ahoy_events.id;


--
-- Name: ahoy_visits; Type: TABLE; Schema: public; Owner: -
--

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


--
-- Name: ahoy_visits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ahoy_visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ahoy_visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ahoy_visits_id_seq OWNED BY public.ahoy_visits.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: channels; Type: TABLE; Schema: public; Owner: -
--

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
    reviewed boolean DEFAULT false,
    videos_count integer DEFAULT 0 NOT NULL
);


--
-- Name: channels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.channels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: channels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.channels_id_seq OWNED BY public.channels.id;


--
-- Name: deletion_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.deletion_requests (
    id bigint NOT NULL,
    provider character varying,
    uid character varying,
    pid character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: deletion_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.deletion_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: deletion_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.deletion_requests_id_seq OWNED BY public.deletion_requests.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

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
    reviewed boolean DEFAULT false,
    videos_count integer DEFAULT 0 NOT NULL
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: followers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.followers (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    reviewed boolean,
    nickname character varying,
    first_name character varying,
    last_name character varying,
    videos_count integer DEFAULT 0 NOT NULL,
    normalized_name character varying
);


--
-- Name: followers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.followers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: followers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.followers_id_seq OWNED BY public.followers.id;


--
-- Name: leaders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.leaders (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    reviewed boolean,
    nickname character varying,
    first_name character varying,
    last_name character varying,
    videos_count integer DEFAULT 0 NOT NULL,
    normalized_name character varying
);


--
-- Name: leaders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.leaders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: leaders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.leaders_id_seq OWNED BY public.leaders.id;


--
-- Name: playlists; Type: TABLE; Schema: public; Owner: -
--

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
    updated_at timestamp(6) without time zone NOT NULL,
    reviewed boolean DEFAULT false
);


--
-- Name: playlists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.playlists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: playlists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.playlists_id_seq OWNED BY public.playlists.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: songs; Type: TABLE; Schema: public; Owner: -
--

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
    lyrics text,
    el_recodo_song_id integer,
    videos_count integer DEFAULT 0 NOT NULL
);


--
-- Name: songs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.songs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: songs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.songs_id_seq OWNED BY public.songs.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    name character varying,
    first_name character varying,
    last_name character varying,
    image character varying,
    uid character varying,
    provider character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    role integer
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: videos; Type: TABLE; Schema: public; Owner: -
--

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
    acr_cloud_artist_name character varying,
    acr_cloud_artist_name_1 character varying,
    acr_cloud_album_name character varying,
    acr_cloud_track_name character varying,
    performance_date timestamp without time zone,
    spotify_artist_id_1 character varying,
    spotify_artist_name_1 character varying,
    performance_number integer,
    performance_total_number integer
);


--
-- Name: videos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.videos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: videos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.videos_id_seq OWNED BY public.videos.id;


--
-- Name: videos_searches; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.videos_searches AS
 SELECT videos.id AS video_id,
    (((((((((((((((((to_tsvector('public.unaccentdict'::regconfig, COALESCE(replace((channels.title)::text, ''''::text, ''::text), ''::text)) || to_tsvector('public.unaccentdict'::regconfig, COALESCE(replace((channels.channel_id)::text, ''''::text, ''::text), ''::text))) || to_tsvector('public.unaccentdict'::regconfig, COALESCE(replace((followers.name)::text, ''''::text, ''::text), ''::text))) || to_tsvector('public.unaccentdict'::regconfig, COALESCE(replace((followers.nickname)::text, ''''::text, ''::text), ''::text))) || to_tsvector('public.unaccentdict'::regconfig, COALESCE(replace((leaders.name)::text, ''''::text, ''::text), ''::text))) || to_tsvector('public.unaccentdict'::regconfig, COALESCE(replace((leaders.nickname)::text, ''''::text, ''::text), ''::text))) || to_tsvector('public.unaccentdict'::regconfig, COALESCE(replace((songs.genre)::text, ''''::text, ''::text), ''::text))) || to_tsvector('public.unaccentdict'::regconfig, COALESCE(replace((songs.title)::text, ''''::text, ''::text), ''::text))) || to_tsvector('public.unaccentdict'::regconfig, COALESCE(replace((songs.artist)::text, ''''::text, ''::text), ''::text))) || to_tsvector('public.unaccentdict'::regconfig, COALESCE(replace((videos.acr_cloud_artist_name)::text, ''''::text, ''::text), ''::text))) || to_tsvector('public.unaccentdict'::regconfig, COALESCE(replace((videos.description)::text, ''''::text, ''::text), ''::text))) || to_tsvector('public.unaccentdict'::regconfig, COALESCE(replace(videos.title, ''''::text, ''::text), ''::text))) || to_tsvector('public.unaccentdict'::regconfig, COALESCE(replace((videos.youtube_artist)::text, ''''::text, ''::text), ''::text))) || to_tsvector('public.unaccentdict'::regconfig, COALESCE(replace((videos.youtube_id)::text, ''''::text, ''::text), ''::text))) || to_tsvector('public.unaccentdict'::regconfig, COALESCE(replace((videos.youtube_song)::text, ''''::text, ''::text), ''::text))) || to_tsvector('public.unaccentdict'::regconfig, COALESCE(replace((videos.spotify_artist_name)::text, ''''::text, ''::text), ''::text))) || to_tsvector('public.unaccentdict'::regconfig, COALESCE(replace((videos.spotify_track_name)::text, ''''::text, ''::text), ''::text))) || to_tsvector('public.unaccentdict'::regconfig, COALESCE(replace((videos.tags)::text, ''''::text, ''::text), ''::text))) AS tsv_document
   FROM ((((public.videos
     LEFT JOIN public.channels ON ((channels.id = videos.channel_id)))
     LEFT JOIN public.followers ON ((followers.id = videos.follower_id)))
     LEFT JOIN public.leaders ON ((leaders.id = videos.leader_id)))
     LEFT JOIN public.songs ON ((songs.id = videos.song_id)))
  WITH NO DATA;


--
-- Name: ahoy_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ahoy_events ALTER COLUMN id SET DEFAULT nextval('public.ahoy_events_id_seq'::regclass);


--
-- Name: ahoy_visits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ahoy_visits ALTER COLUMN id SET DEFAULT nextval('public.ahoy_visits_id_seq'::regclass);


--
-- Name: channels id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.channels ALTER COLUMN id SET DEFAULT nextval('public.channels_id_seq'::regclass);


--
-- Name: deletion_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deletion_requests ALTER COLUMN id SET DEFAULT nextval('public.deletion_requests_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: followers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.followers ALTER COLUMN id SET DEFAULT nextval('public.followers_id_seq'::regclass);


--
-- Name: leaders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leaders ALTER COLUMN id SET DEFAULT nextval('public.leaders_id_seq'::regclass);


--
-- Name: playlists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playlists ALTER COLUMN id SET DEFAULT nextval('public.playlists_id_seq'::regclass);


--
-- Name: songs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs ALTER COLUMN id SET DEFAULT nextval('public.songs_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: videos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.videos ALTER COLUMN id SET DEFAULT nextval('public.videos_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: channels channels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.channels
    ADD CONSTRAINT channels_pkey PRIMARY KEY (id);


--
-- Name: deletion_requests deletion_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deletion_requests
    ADD CONSTRAINT deletion_requests_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: followers followers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.followers
    ADD CONSTRAINT followers_pkey PRIMARY KEY (id);


--
-- Name: leaders leaders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leaders
    ADD CONSTRAINT leaders_pkey PRIMARY KEY (id);


--
-- Name: playlists playlists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playlists
    ADD CONSTRAINT playlists_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: songs songs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs
    ADD CONSTRAINT songs_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: videos videos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.videos
    ADD CONSTRAINT videos_pkey PRIMARY KEY (id);


--
-- Name: index_ahoy_events_on_name_and_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ahoy_events_on_name_and_time ON public.ahoy_events USING btree (name, "time");


--
-- Name: index_ahoy_events_on_properties; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ahoy_events_on_properties ON public.ahoy_events USING gin (properties jsonb_path_ops);


--
-- Name: index_ahoy_events_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ahoy_events_on_user_id ON public.ahoy_events USING btree (user_id);


--
-- Name: index_ahoy_events_on_visit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ahoy_events_on_visit_id ON public.ahoy_events USING btree (visit_id);


--
-- Name: index_ahoy_visits_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ahoy_visits_on_user_id ON public.ahoy_visits USING btree (user_id);


--
-- Name: index_ahoy_visits_on_visit_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ahoy_visits_on_visit_token ON public.ahoy_visits USING btree (visit_token);


--
-- Name: index_channels_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_channels_on_title ON public.channels USING btree (title);


--
-- Name: index_deletion_requests_on_pid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_deletion_requests_on_pid ON public.deletion_requests USING btree (pid);


--
-- Name: index_events_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_title ON public.events USING btree (title);


--
-- Name: index_followers_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_followers_on_name ON public.followers USING btree (name);


--
-- Name: index_leaders_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leaders_on_name ON public.leaders USING btree (name);


--
-- Name: index_playlists_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_playlists_on_user_id ON public.playlists USING btree (user_id);


--
-- Name: index_playlists_on_videos_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_playlists_on_videos_id ON public.playlists USING btree (videos_id);


--
-- Name: index_songs_on_artist; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_songs_on_artist ON public.songs USING btree (artist);


--
-- Name: index_songs_on_genre; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_songs_on_genre ON public.songs USING btree (genre);


--
-- Name: index_songs_on_last_name_search; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_songs_on_last_name_search ON public.songs USING btree (last_name_search);


--
-- Name: index_songs_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_songs_on_title ON public.songs USING btree (title);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_videos_on_acr_cloud_artist_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_videos_on_acr_cloud_artist_name ON public.videos USING btree (acr_cloud_artist_name);


--
-- Name: index_videos_on_acr_cloud_track_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_videos_on_acr_cloud_track_name ON public.videos USING btree (acr_cloud_track_name);


--
-- Name: index_videos_on_channel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_videos_on_channel_id ON public.videos USING btree (channel_id);


--
-- Name: index_videos_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_videos_on_event_id ON public.videos USING btree (event_id);


--
-- Name: index_videos_on_follower_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_videos_on_follower_id ON public.videos USING btree (follower_id);


--
-- Name: index_videos_on_hd; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_videos_on_hd ON public.videos USING btree (hd);


--
-- Name: index_videos_on_hidden; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_videos_on_hidden ON public.videos USING btree (hidden);


--
-- Name: index_videos_on_leader_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_videos_on_leader_id ON public.videos USING btree (leader_id);


--
-- Name: index_videos_on_performance_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_videos_on_performance_date ON public.videos USING btree (performance_date);


--
-- Name: index_videos_on_popularity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_videos_on_popularity ON public.videos USING btree (popularity);


--
-- Name: index_videos_on_song_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_videos_on_song_id ON public.videos USING btree (song_id);


--
-- Name: index_videos_on_spotify_artist_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_videos_on_spotify_artist_name ON public.videos USING btree (spotify_artist_name);


--
-- Name: index_videos_on_spotify_track_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_videos_on_spotify_track_name ON public.videos USING btree (spotify_track_name);


--
-- Name: index_videos_on_tags; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_videos_on_tags ON public.videos USING btree (tags);


--
-- Name: index_videos_on_upload_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_videos_on_upload_date ON public.videos USING btree (upload_date);


--
-- Name: index_videos_on_view_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_videos_on_view_count ON public.videos USING btree (view_count);


--
-- Name: index_videos_on_youtube_artist; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_videos_on_youtube_artist ON public.videos USING btree (youtube_artist);


--
-- Name: index_videos_on_youtube_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_videos_on_youtube_id ON public.videos USING btree (youtube_id);


--
-- Name: index_videos_on_youtube_song; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_videos_on_youtube_song ON public.videos USING btree (youtube_song);


--
-- Name: index_videos_searches_on_tsv_document; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_videos_searches_on_tsv_document ON public.videos_searches USING gin (tsv_document);


--
-- Name: playlists fk_rails_180bd29355; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playlists
    ADD CONSTRAINT fk_rails_180bd29355 FOREIGN KEY (videos_id) REFERENCES public.videos(id);


--
-- Name: videos fk_rails_7ebce950d2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.videos
    ADD CONSTRAINT fk_rails_7ebce950d2 FOREIGN KEY (event_id) REFERENCES public.events(id);


--
-- Name: playlists fk_rails_d67ef1eb45; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playlists
    ADD CONSTRAINT fk_rails_d67ef1eb45 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20200702183140'),
('20200703195144'),
('20200703210522'),
('20200705212132'),
('20200705213652'),
('20200706151719'),
('20200707071332'),
('20200714163153'),
('20200717075238'),
('20200721213201'),
('20200724111424'),
('20200726121535'),
('20200727180548'),
('20200728084042'),
('20200728084051'),
('20200728085020'),
('20200728085048'),
('20200907014655'),
('20201019230928'),
('20201102165536'),
('20201102165548'),
('20201102165631'),
('20201104112926'),
('20201128194419'),
('20201128214542'),
('20201128222120'),
('20201207145709'),
('20201208083012'),
('20201212174857'),
('20201219105757'),
('20201220175426'),
('20201220232439'),
('20201223085023'),
('20201223085038'),
('20201229202305'),
('20201231063836'),
('20201231101018'),
('20210103161704'),
('20210104081821'),
('20210104100230'),
('20210107195638'),
('20210109154316'),
('20210110182117'),
('20210112175659'),
('20210112185333'),
('20210115171517'),
('20210116124900'),
('20210116154216'),
('20210116203557'),
('20210117064902'),
('20210117065523'),
('20210117065539'),
('20210118123830'),
('20210124151237'),
('20210124180841'),
('20210127131318'),
('20210201102317'),
('20210205075009'),
('20210206151011'),
('20210206172109'),
('20210206223104'),
('20210207085038'),
('20210207115746'),
('20210210140250'),
('20210211153442'),
('20210306201925'),
('20210308100534'),
('20210309200926'),
('20210309222823'),
('20210309222936'),
('20210309222950'),
('20210309223000'),
('20210309223723'),
('20210309233622'),
('20210315153437'),
('20210426184554'),
('20210426185440'),
('20210426205241'),
('20210428220252'),
('20210530040913'),
('20210530041239'),
('20210530041330'),
('20210530043025'),
('20210530061929'),
('20210605102713'),
('20210606002534'),
('20211229163231'),
('20220124174633'),
('20220124180416'),
('20220127133110'),
('20220208010324'),
('20220208130431'),
('20220208222724'),
('20220209013643'),
('20220209032353'),
('20220209032610');


