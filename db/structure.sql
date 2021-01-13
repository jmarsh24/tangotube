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


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin_users; Type: TABLE; Schema: public; Owner: -
--

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


--
-- Name: admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.admin_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.admin_users_id_seq OWNED BY public.admin_users.id;


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
    yt_api_pull_count integer DEFAULT 0
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
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id bigint NOT NULL,
    name character varying NOT NULL,
    city character varying,
    country character varying,
    date date,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
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
    nickname character varying
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
    nickname character varying
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
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: search_suggestions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.search_suggestions (
    id bigint NOT NULL,
    term character varying,
    popularity integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: search_suggestions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.search_suggestions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: search_suggestions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.search_suggestions_id_seq OWNED BY public.search_suggestions.id;


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
    active boolean DEFAULT true
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
    updated_at timestamp(6) without time zone NOT NULL
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
    avg_rating integer,
    tags character varying,
    song_id bigint,
    youtube_song character varying,
    youtube_artist character varying,
    performance_date timestamp without time zone,
    performance_number integer,
    performance_total integer,
    videotype_id bigint,
    event_id bigint,
    confidence_score character varying,
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
    spotify_artist_name_3 character varying,
    length interval,
    channel_id bigint,
    scanned_song boolean DEFAULT false,
    hidden boolean DEFAULT false,
    songmatches character varying[] DEFAULT '{}'::character varying[],
    hd boolean DEFAULT false,
    searchable tsvector GENERATED ALWAYS AS ((setweight(to_tsvector('english'::regconfig, COALESCE(title, ''::text)), 'A'::"char") || setweight(to_tsvector('english'::regconfig, (COALESCE(description, ''::character varying))::text), 'B'::"char"))) STORED
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
-- Name: videotypes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.videotypes (
    id bigint NOT NULL,
    name character varying NOT NULL,
    related_keywords character varying
);


--
-- Name: videotypes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.videotypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: videotypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.videotypes_id_seq OWNED BY public.videotypes.id;


--
-- Name: admin_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_users ALTER COLUMN id SET DEFAULT nextval('public.admin_users_id_seq'::regclass);


--
-- Name: channels id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.channels ALTER COLUMN id SET DEFAULT nextval('public.channels_id_seq'::regclass);


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
-- Name: search_suggestions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.search_suggestions ALTER COLUMN id SET DEFAULT nextval('public.search_suggestions_id_seq'::regclass);


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
-- Name: videotypes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.videotypes ALTER COLUMN id SET DEFAULT nextval('public.videotypes_id_seq'::regclass);


--
-- Name: admin_users admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


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
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: search_suggestions search_suggestions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.search_suggestions
    ADD CONSTRAINT search_suggestions_pkey PRIMARY KEY (id);


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
-- Name: videotypes videotypes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.videotypes
    ADD CONSTRAINT videotypes_pkey PRIMARY KEY (id);


--
-- Name: index_admin_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admin_users_on_email ON public.admin_users USING btree (email);


--
-- Name: index_admin_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admin_users_on_reset_password_token ON public.admin_users USING btree (reset_password_token);


--
-- Name: index_followers_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_followers_on_name ON public.followers USING btree (name);


--
-- Name: index_leaders_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leaders_on_name ON public.leaders USING btree (name);


--
-- Name: index_songs_on_artist; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_songs_on_artist ON public.songs USING btree (artist);


--
-- Name: index_songs_on_genre; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_songs_on_genre ON public.songs USING btree (genre);


--
-- Name: index_songs_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_songs_on_title ON public.songs USING btree (title);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


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
-- Name: index_videos_on_leader_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_videos_on_leader_id ON public.videos USING btree (leader_id);


--
-- Name: index_videos_on_searchable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_videos_on_searchable ON public.videos USING gin (searchable);


--
-- Name: index_videos_on_song_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_videos_on_song_id ON public.videos USING btree (song_id);


--
-- Name: index_videos_on_videotype_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_videos_on_videotype_id ON public.videos USING btree (videotype_id);


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
('20210112185333');


