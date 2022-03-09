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
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


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
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    service_name character varying NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;


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
-- Name: clips; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clips (
    id bigint NOT NULL,
    start_seconds integer NOT NULL,
    end_seconds integer NOT NULL,
    title text,
    playback_rate double precision DEFAULT 1.0,
    tags character varying,
    user_id bigint NOT NULL,
    video_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: clips_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clips_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clips_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clips_id_seq OWNED BY public.clips.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comments (
    id bigint NOT NULL,
    user_id bigint,
    commentable_type character varying,
    commentable_id bigint,
    parent_id integer,
    body text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


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
-- Name: pay_charges; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pay_charges (
    id bigint NOT NULL,
    customer_id integer NOT NULL,
    subscription_id integer,
    processor_id character varying NOT NULL,
    amount integer NOT NULL,
    currency character varying,
    application_fee_amount integer,
    amount_refunded integer,
    metadata jsonb,
    data jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: pay_charges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pay_charges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pay_charges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pay_charges_id_seq OWNED BY public.pay_charges.id;


--
-- Name: pay_customers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pay_customers (
    id bigint NOT NULL,
    owner_type character varying,
    owner_id integer,
    processor character varying NOT NULL,
    processor_id character varying,
    "default" boolean,
    data jsonb,
    deleted_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: pay_customers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pay_customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pay_customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pay_customers_id_seq OWNED BY public.pay_customers.id;


--
-- Name: pay_merchants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pay_merchants (
    id bigint NOT NULL,
    owner_type character varying,
    owner_id integer,
    processor character varying NOT NULL,
    processor_id character varying,
    "default" boolean,
    data jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: pay_merchants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pay_merchants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pay_merchants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pay_merchants_id_seq OWNED BY public.pay_merchants.id;


--
-- Name: pay_payment_methods; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pay_payment_methods (
    id bigint NOT NULL,
    customer_id integer NOT NULL,
    processor_id character varying NOT NULL,
    "default" boolean,
    type character varying,
    data jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: pay_payment_methods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pay_payment_methods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pay_payment_methods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pay_payment_methods_id_seq OWNED BY public.pay_payment_methods.id;


--
-- Name: pay_subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pay_subscriptions (
    id bigint NOT NULL,
    customer_id integer NOT NULL,
    name character varying NOT NULL,
    processor_id character varying NOT NULL,
    processor_plan character varying NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    status character varying NOT NULL,
    trial_ends_at timestamp without time zone,
    ends_at timestamp without time zone,
    application_fee_percent numeric(8,2),
    metadata jsonb,
    data jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: pay_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pay_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pay_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pay_subscriptions_id_seq OWNED BY public.pay_subscriptions.id;


--
-- Name: pay_webhooks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pay_webhooks (
    id bigint NOT NULL,
    processor character varying,
    event_type character varying,
    event jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: pay_webhooks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pay_webhooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pay_webhooks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pay_webhooks_id_seq OWNED BY public.pay_webhooks.id;


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
    videos_count integer DEFAULT 0 NOT NULL,
    lyrics_en character varying
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
    performance_total_number integer,
    cached_votes_total integer DEFAULT 0,
    cached_votes_score integer DEFAULT 0,
    cached_votes_up integer DEFAULT 0,
    cached_votes_down integer DEFAULT 0,
    cached_weighted_score integer DEFAULT 0,
    cached_weighted_total integer DEFAULT 0,
    cached_weighted_average double precision DEFAULT 0.0
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
-- Name: votes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.votes (
    id bigint NOT NULL,
    votable_type character varying,
    votable_id bigint,
    voter_type character varying,
    voter_id bigint,
    vote_flag boolean,
    vote_scope character varying,
    vote_weight integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: votes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.votes_id_seq OWNED BY public.votes.id;


--
-- Name: yt_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.yt_comments (
    id bigint NOT NULL,
    video_id bigint NOT NULL,
    body text NOT NULL,
    user_name text NOT NULL,
    like_count integer DEFAULT 0 NOT NULL,
    date date NOT NULL,
    channel_id character varying NOT NULL,
    profile_image_url character varying NOT NULL,
    youtube_id character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: yt_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.yt_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: yt_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.yt_comments_id_seq OWNED BY public.yt_comments.id;


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);


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
-- Name: clips id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clips ALTER COLUMN id SET DEFAULT nextval('public.clips_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


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
-- Name: pay_charges id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pay_charges ALTER COLUMN id SET DEFAULT nextval('public.pay_charges_id_seq'::regclass);


--
-- Name: pay_customers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pay_customers ALTER COLUMN id SET DEFAULT nextval('public.pay_customers_id_seq'::regclass);


--
-- Name: pay_merchants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pay_merchants ALTER COLUMN id SET DEFAULT nextval('public.pay_merchants_id_seq'::regclass);


--
-- Name: pay_payment_methods id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pay_payment_methods ALTER COLUMN id SET DEFAULT nextval('public.pay_payment_methods_id_seq'::regclass);


--
-- Name: pay_subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pay_subscriptions ALTER COLUMN id SET DEFAULT nextval('public.pay_subscriptions_id_seq'::regclass);


--
-- Name: pay_webhooks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pay_webhooks ALTER COLUMN id SET DEFAULT nextval('public.pay_webhooks_id_seq'::regclass);


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
-- Name: votes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.votes ALTER COLUMN id SET DEFAULT nextval('public.votes_id_seq'::regclass);


--
-- Name: yt_comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.yt_comments ALTER COLUMN id SET DEFAULT nextval('public.yt_comments_id_seq'::regclass);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


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
-- Name: clips clips_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clips
    ADD CONSTRAINT clips_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


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
-- Name: pay_charges pay_charges_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pay_charges
    ADD CONSTRAINT pay_charges_pkey PRIMARY KEY (id);


--
-- Name: pay_customers pay_customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pay_customers
    ADD CONSTRAINT pay_customers_pkey PRIMARY KEY (id);


--
-- Name: pay_merchants pay_merchants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pay_merchants
    ADD CONSTRAINT pay_merchants_pkey PRIMARY KEY (id);


--
-- Name: pay_payment_methods pay_payment_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pay_payment_methods
    ADD CONSTRAINT pay_payment_methods_pkey PRIMARY KEY (id);


--
-- Name: pay_subscriptions pay_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pay_subscriptions
    ADD CONSTRAINT pay_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: pay_webhooks pay_webhooks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pay_webhooks
    ADD CONSTRAINT pay_webhooks_pkey PRIMARY KEY (id);


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
-- Name: votes votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.votes
    ADD CONSTRAINT votes_pkey PRIMARY KEY (id);


--
-- Name: yt_comments yt_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.yt_comments
    ADD CONSTRAINT yt_comments_pkey PRIMARY KEY (id);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


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
-- Name: index_clips_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clips_on_user_id ON public.clips USING btree (user_id);


--
-- Name: index_clips_on_video_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clips_on_video_id ON public.clips USING btree (video_id);


--
-- Name: index_comments_on_commentable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_commentable ON public.comments USING btree (commentable_type, commentable_id);


--
-- Name: index_comments_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_user_id ON public.comments USING btree (user_id);


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
-- Name: index_pay_charges_on_customer_id_and_processor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_pay_charges_on_customer_id_and_processor_id ON public.pay_charges USING btree (customer_id, processor_id);


--
-- Name: index_pay_charges_on_subscription_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pay_charges_on_subscription_id ON public.pay_charges USING btree (subscription_id);


--
-- Name: index_pay_customers_on_processor_and_processor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_pay_customers_on_processor_and_processor_id ON public.pay_customers USING btree (processor, processor_id);


--
-- Name: index_pay_merchants_on_owner_type_and_owner_id_and_processor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pay_merchants_on_owner_type_and_owner_id_and_processor ON public.pay_merchants USING btree (owner_type, owner_id, processor);


--
-- Name: index_pay_payment_methods_on_customer_id_and_processor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_pay_payment_methods_on_customer_id_and_processor_id ON public.pay_payment_methods USING btree (customer_id, processor_id);


--
-- Name: index_pay_subscriptions_on_customer_id_and_processor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_pay_subscriptions_on_customer_id_and_processor_id ON public.pay_subscriptions USING btree (customer_id, processor_id);


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
-- Name: index_votes_on_votable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_votes_on_votable ON public.votes USING btree (votable_type, votable_id);


--
-- Name: index_votes_on_votable_id_and_votable_type_and_vote_scope; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_votes_on_votable_id_and_votable_type_and_vote_scope ON public.votes USING btree (votable_id, votable_type, vote_scope);


--
-- Name: index_votes_on_voter; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_votes_on_voter ON public.votes USING btree (voter_type, voter_id);


--
-- Name: index_votes_on_voter_id_and_voter_type_and_vote_scope; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_votes_on_voter_id_and_voter_type_and_vote_scope ON public.votes USING btree (voter_id, voter_type, vote_scope);


--
-- Name: index_yt_comments_on_video_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_yt_comments_on_video_id ON public.yt_comments USING btree (video_id);


--
-- Name: pay_customer_owner_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pay_customer_owner_index ON public.pay_customers USING btree (owner_type, owner_id, deleted_at, "default");


--
-- Name: comments fk_rails_03de2dc08c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_rails_03de2dc08c FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: playlists fk_rails_180bd29355; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playlists
    ADD CONSTRAINT fk_rails_180bd29355 FOREIGN KEY (videos_id) REFERENCES public.videos(id);


--
-- Name: pay_charges fk_rails_44a2c276fa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pay_charges
    ADD CONSTRAINT fk_rails_44a2c276fa FOREIGN KEY (subscription_id) REFERENCES public.pay_subscriptions(id);


--
-- Name: videos fk_rails_7ebce950d2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.videos
    ADD CONSTRAINT fk_rails_7ebce950d2 FOREIGN KEY (event_id) REFERENCES public.events(id);


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: pay_charges fk_rails_b19d32f835; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pay_charges
    ADD CONSTRAINT fk_rails_b19d32f835 FOREIGN KEY (customer_id) REFERENCES public.pay_customers(id);


--
-- Name: pay_subscriptions fk_rails_b7cd64d378; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pay_subscriptions
    ADD CONSTRAINT fk_rails_b7cd64d378 FOREIGN KEY (customer_id) REFERENCES public.pay_customers(id);


--
-- Name: yt_comments fk_rails_b8c2c55344; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.yt_comments
    ADD CONSTRAINT fk_rails_b8c2c55344 FOREIGN KEY (video_id) REFERENCES public.videos(id);


--
-- Name: clips fk_rails_b8e2fc769f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clips
    ADD CONSTRAINT fk_rails_b8e2fc769f FOREIGN KEY (video_id) REFERENCES public.videos(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: pay_payment_methods fk_rails_c78c6cb84d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pay_payment_methods
    ADD CONSTRAINT fk_rails_c78c6cb84d FOREIGN KEY (customer_id) REFERENCES public.pay_customers(id);


--
-- Name: playlists fk_rails_d67ef1eb45; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playlists
    ADD CONSTRAINT fk_rails_d67ef1eb45 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: clips fk_rails_da05a176b5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clips
    ADD CONSTRAINT fk_rails_da05a176b5 FOREIGN KEY (user_id) REFERENCES public.users(id);


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
('20220209032610'),
('20220210150146'),
('20220212040653'),
('20220212040654'),
('20220212040655'),
('20220212040656'),
('20220212144641'),
('20220212144740'),
('20220224114432'),
('20220224134559'),
('20220228110513'),
('20220307091518'),
('20220307112504'),
('20220309145737');


