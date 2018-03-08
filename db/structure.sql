SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE accounts (
    id bigint NOT NULL,
    owner_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    acme_account_key bytea NOT NULL
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;


--
-- Name: accounts_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE accounts_users (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    user_id bigint NOT NULL
);


--
-- Name: accounts_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE accounts_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE accounts_users_id_seq OWNED BY accounts_users.id;


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
-- Name: que_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE que_jobs (
    priority smallint DEFAULT 100 NOT NULL,
    run_at timestamp with time zone DEFAULT now() NOT NULL,
    job_id bigint NOT NULL,
    job_class text NOT NULL,
    args json DEFAULT '[]'::json NOT NULL,
    error_count integer DEFAULT 0 NOT NULL,
    last_error text,
    queue text DEFAULT ''::text NOT NULL
);


--
-- Name: TABLE que_jobs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE que_jobs IS '3';


--
-- Name: que_jobs_job_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE que_jobs_job_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: que_jobs_job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE que_jobs_job_id_seq OWNED BY que_jobs.job_id;


--
-- Name: revision_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE revision_files (
    id bigint NOT NULL,
    revision_id bigint NOT NULL,
    upstream_file_id bigint NOT NULL,
    site_path character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: revision_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE revision_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: revision_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE revision_files_id_seq OWNED BY revision_files.id;


--
-- Name: revisions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE revisions (
    id bigint NOT NULL,
    number integer NOT NULL,
    site_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE revisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: revisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE revisions_id_seq OWNED BY revisions.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sites (
    id bigint NOT NULL,
    domain citext NOT NULL,
    account_id bigint NOT NULL,
    revision_count integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    current_revision_id bigint,
    domain_validation_token character varying,
    domain_validation_content character varying,
    domain_validated_at timestamp without time zone,
    acme_authorization_uri character varying,
    acme_challenge_token character varying,
    certificate_private_key bytea,
    certificate_full_chain bytea
);


--
-- Name: sites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sites_id_seq OWNED BY sites.id;


--
-- Name: tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tokens (
    id bigint NOT NULL,
    access_token character varying NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tokens_id_seq OWNED BY tokens.id;


--
-- Name: upstream_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE upstream_files (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    md5 citext NOT NULL,
    size bigint NOT NULL,
    content_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: upstream_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE upstream_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: upstream_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE upstream_files_id_seq OWNED BY upstream_files.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id bigint NOT NULL,
    email citext NOT NULL,
    password_digest character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);


--
-- Name: accounts_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts_users ALTER COLUMN id SET DEFAULT nextval('accounts_users_id_seq'::regclass);


--
-- Name: que_jobs job_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY que_jobs ALTER COLUMN job_id SET DEFAULT nextval('que_jobs_job_id_seq'::regclass);


--
-- Name: revision_files id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY revision_files ALTER COLUMN id SET DEFAULT nextval('revision_files_id_seq'::regclass);


--
-- Name: revisions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY revisions ALTER COLUMN id SET DEFAULT nextval('revisions_id_seq'::regclass);


--
-- Name: sites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sites ALTER COLUMN id SET DEFAULT nextval('sites_id_seq'::regclass);


--
-- Name: tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tokens ALTER COLUMN id SET DEFAULT nextval('tokens_id_seq'::regclass);


--
-- Name: upstream_files id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY upstream_files ALTER COLUMN id SET DEFAULT nextval('upstream_files_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: accounts_users accounts_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts_users
    ADD CONSTRAINT accounts_users_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: que_jobs que_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY que_jobs
    ADD CONSTRAINT que_jobs_pkey PRIMARY KEY (queue, priority, run_at, job_id);


--
-- Name: revision_files revision_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY revision_files
    ADD CONSTRAINT revision_files_pkey PRIMARY KEY (id);


--
-- Name: revisions revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY revisions
    ADD CONSTRAINT revisions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sites sites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sites
    ADD CONSTRAINT sites_pkey PRIMARY KEY (id);


--
-- Name: tokens tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (id);


--
-- Name: upstream_files upstream_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY upstream_files
    ADD CONSTRAINT upstream_files_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_accounts_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_owner_id ON accounts USING btree (owner_id);


--
-- Name: index_accounts_users_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_users_on_account_id ON accounts_users USING btree (account_id);


--
-- Name: index_accounts_users_on_account_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_accounts_users_on_account_id_and_user_id ON accounts_users USING btree (account_id, user_id);


--
-- Name: index_accounts_users_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_users_on_user_id ON accounts_users USING btree (user_id);


--
-- Name: index_accounts_users_on_user_id_and_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_users_on_user_id_and_account_id ON accounts_users USING btree (user_id, account_id);


--
-- Name: index_revision_files_on_revision_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_revision_files_on_revision_id ON revision_files USING btree (revision_id);


--
-- Name: index_revision_files_on_revision_id_and_site_path; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_revision_files_on_revision_id_and_site_path ON revision_files USING btree (revision_id, site_path);


--
-- Name: index_revision_files_on_upstream_file_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_revision_files_on_upstream_file_id ON revision_files USING btree (upstream_file_id);


--
-- Name: index_revisions_on_site_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_revisions_on_site_id ON revisions USING btree (site_id);


--
-- Name: index_revisions_on_site_id_and_number; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_revisions_on_site_id_and_number ON revisions USING btree (site_id, number);


--
-- Name: index_sites_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sites_on_account_id ON sites USING btree (account_id);


--
-- Name: index_sites_on_acme_challenge_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sites_on_acme_challenge_token ON sites USING btree (acme_challenge_token);


--
-- Name: index_sites_on_current_revision_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sites_on_current_revision_id ON sites USING btree (current_revision_id);


--
-- Name: index_sites_on_domain; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sites_on_domain ON sites USING btree (domain);


--
-- Name: index_sites_on_domain_validated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sites_on_domain_validated_at ON sites USING btree (domain_validated_at);


--
-- Name: index_sites_on_domain_validation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sites_on_domain_validation_token ON sites USING btree (domain_validation_token);


--
-- Name: index_tokens_on_access_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tokens_on_access_token ON tokens USING btree (access_token);


--
-- Name: index_tokens_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tokens_on_user_id ON tokens USING btree (user_id);


--
-- Name: index_upstream_files_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_upstream_files_on_account_id ON upstream_files USING btree (account_id);


--
-- Name: index_upstream_files_on_account_id_and_md5; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_upstream_files_on_account_id_and_md5 ON upstream_files USING btree (account_id, md5);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20170925153838'),
('20170925153839'),
('20170925155537'),
('20170925155857'),
('20170925160313'),
('20170925160527'),
('20170927214142'),
('20170927223836'),
('20170927223837'),
('20180121190925'),
('20180130023358'),
('20180130034705'),
('20180202232330');


