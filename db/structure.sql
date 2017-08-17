SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


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
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET search_path = public, pg_catalog;

--
-- Name: pg_search_dmetaphone(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION pg_search_dmetaphone(text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT array_to_string(ARRAY(SELECT dmetaphone(unnest(regexp_split_to_array($1, E'\\s+')))), ' ')
$_$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: active_admin_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE active_admin_comments (
    id bigint NOT NULL,
    namespace character varying,
    body text,
    resource_type character varying,
    resource_id bigint,
    author_type character varying,
    author_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE active_admin_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE active_admin_comments_id_seq OWNED BY active_admin_comments.id;


--
-- Name: admin_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE admin_users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admin_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admin_users_id_seq OWNED BY admin_users.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: courses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE courses (
    id bigint NOT NULL,
    title character varying,
    description text,
    target_group character varying,
    status character varying,
    qualification character varying,
    start_date date,
    end_date date,
    start_time time without time zone,
    end_time time without time zone,
    hours double precision,
    target_number integer,
    enrolment_count integer,
    lcc_code character varying,
    provider_code character varying,
    academic_year character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    venue_id bigint,
    provider_id bigint,
    subject_id bigint,
    latitude double precision,
    longitude double precision,
    lonlat geography(Point,4326),
    category_1 character varying,
    category_2 character varying,
    import_id bigint
);


--
-- Name: courses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE courses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE courses_id_seq OWNED BY courses.id;


--
-- Name: imports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE imports (
    id bigint NOT NULL,
    status character varying,
    course_count integer,
    filename character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    csv_file_file_name character varying,
    csv_file_content_type character varying,
    csv_file_file_size integer,
    csv_file_updated_at timestamp without time zone,
    finished_at timestamp without time zone,
    imported_num integer,
    note text,
    upload_url character varying
);


--
-- Name: imports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE imports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: imports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE imports_id_seq OWNED BY imports.id;


--
-- Name: news; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE news (
    id bigint NOT NULL,
    body text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: news_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE news_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: news_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE news_id_seq OWNED BY news.id;


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pages (
    id bigint NOT NULL,
    name character varying,
    body text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pages_id_seq OWNED BY pages.id;


--
-- Name: postcodes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE postcodes (
    id bigint NOT NULL,
    postcode character varying,
    easting integer,
    northing integer,
    latitude double precision,
    longitude double precision,
    postcode_no_space character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: postcodes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE postcodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: postcodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE postcodes_id_seq OWNED BY postcodes.id;


--
-- Name: providers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE providers (
    id bigint NOT NULL,
    name character varying,
    url character varying,
    telephone character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    email character varying
);


--
-- Name: providers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE providers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: providers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE providers_id_seq OWNED BY providers.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: subjects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE subjects (
    id bigint NOT NULL,
    code character varying,
    description character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: subjects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE subjects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subjects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE subjects_id_seq OWNED BY subjects.id;


--
-- Name: subjects_topics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE subjects_topics (
    topic_id bigint,
    subject_id bigint
);


--
-- Name: topics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE topics (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    category_1 text[] DEFAULT '{}'::text[],
    category_2 text[] DEFAULT '{}'::text[],
    count_courses integer,
    icon_file_name character varying,
    icon_content_type character varying,
    icon_file_size integer,
    icon_updated_at timestamp without time zone
);


--
-- Name: topics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE topics_id_seq OWNED BY topics.id;


--
-- Name: venues; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE venues (
    id bigint NOT NULL,
    name character varying,
    postcode character varying,
    area character varying,
    committee character varying,
    ward character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    latitude double precision,
    longitude double precision,
    easting integer,
    northing integer,
    postcode_no_space character varying,
    address_1 character varying,
    address_2 character varying,
    address_3 character varying
);


--
-- Name: venues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE venues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: venues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE venues_id_seq OWNED BY venues.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY active_admin_comments ALTER COLUMN id SET DEFAULT nextval('active_admin_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admin_users ALTER COLUMN id SET DEFAULT nextval('admin_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY courses ALTER COLUMN id SET DEFAULT nextval('courses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY imports ALTER COLUMN id SET DEFAULT nextval('imports_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY news ALTER COLUMN id SET DEFAULT nextval('news_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pages ALTER COLUMN id SET DEFAULT nextval('pages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY postcodes ALTER COLUMN id SET DEFAULT nextval('postcodes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY providers ALTER COLUMN id SET DEFAULT nextval('providers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY subjects ALTER COLUMN id SET DEFAULT nextval('subjects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY topics ALTER COLUMN id SET DEFAULT nextval('topics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY venues ALTER COLUMN id SET DEFAULT nextval('venues_id_seq'::regclass);


--
-- Name: active_admin_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY active_admin_comments
    ADD CONSTRAINT active_admin_comments_pkey PRIMARY KEY (id);


--
-- Name: admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: courses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: imports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY imports
    ADD CONSTRAINT imports_pkey PRIMARY KEY (id);


--
-- Name: news_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY news
    ADD CONSTRAINT news_pkey PRIMARY KEY (id);


--
-- Name: pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: postcodes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY postcodes
    ADD CONSTRAINT postcodes_pkey PRIMARY KEY (id);


--
-- Name: providers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY providers
    ADD CONSTRAINT providers_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (id);


--
-- Name: topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (id);


--
-- Name: venues_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY venues
    ADD CONSTRAINT venues_pkey PRIMARY KEY (id);


--
-- Name: index_active_admin_comments_on_author_type_and_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_author_type_and_author_id ON active_admin_comments USING btree (author_type, author_id);


--
-- Name: index_active_admin_comments_on_namespace; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_namespace ON active_admin_comments USING btree (namespace);


--
-- Name: index_active_admin_comments_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_resource_type_and_resource_id ON active_admin_comments USING btree (resource_type, resource_id);


--
-- Name: index_admin_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admin_users_on_email ON admin_users USING btree (email);


--
-- Name: index_admin_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admin_users_on_reset_password_token ON admin_users USING btree (reset_password_token);


--
-- Name: index_courses_on_import_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_courses_on_import_id ON courses USING btree (import_id);


--
-- Name: index_courses_on_lcc_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_courses_on_lcc_code ON courses USING btree (lcc_code);


--
-- Name: index_courses_on_lonlat; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_courses_on_lonlat ON courses USING gist (lonlat);


--
-- Name: index_courses_on_provider_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_courses_on_provider_id ON courses USING btree (provider_id);


--
-- Name: index_courses_on_subject_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_courses_on_subject_id ON courses USING btree (subject_id);


--
-- Name: index_courses_on_venue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_courses_on_venue_id ON courses USING btree (venue_id);


--
-- Name: index_subjects_topics_on_subject_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subjects_topics_on_subject_id ON subjects_topics USING btree (subject_id);


--
-- Name: index_subjects_topics_on_topic_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subjects_topics_on_topic_id ON subjects_topics USING btree (topic_id);


--
-- Name: fk_rails_3dce5cd5bf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY courses
    ADD CONSTRAINT fk_rails_3dce5cd5bf FOREIGN KEY (provider_id) REFERENCES providers(id);


--
-- Name: fk_rails_57d52eb461; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY courses
    ADD CONSTRAINT fk_rails_57d52eb461 FOREIGN KEY (subject_id) REFERENCES subjects(id);


--
-- Name: fk_rails_8d91db0f8c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY courses
    ADD CONSTRAINT fk_rails_8d91db0f8c FOREIGN KEY (venue_id) REFERENCES venues(id);


--
-- Name: fk_rails_c3e6349cb8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY courses
    ADD CONSTRAINT fk_rails_c3e6349cb8 FOREIGN KEY (import_id) REFERENCES imports(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20170516152940'),
('20170516153814'),
('20170516153952'),
('20170516154603'),
('20170516154618'),
('20170516154943'),
('20170516160340'),
('20170516160807'),
('20170517133407'),
('20170517163049'),
('20170517163052'),
('20170522151203'),
('20170522162847'),
('20170522163415'),
('20170530122550'),
('20170603155228'),
('20170604152510'),
('20170604153719'),
('20170617155911'),
('20170617161821'),
('20170618140016'),
('20170618140708'),
('20170618142535'),
('20170618160653'),
('20170626133952'),
('20170626162151'),
('20170626164734'),
('20170630190403'),
('20170701173218'),
('20170817131455');


