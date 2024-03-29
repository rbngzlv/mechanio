--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


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

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: admins; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE admins (
    id integer NOT NULL,
    email character varying(255),
    password character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255)
);


--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admins_id_seq OWNED BY admins.id;


--
-- Name: appointments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE appointments (
    id integer NOT NULL,
    user_id integer,
    mechanic_id integer,
    job_id integer,
    scheduled_at timestamp without time zone,
    status character varying(255)
);


--
-- Name: appointments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE appointments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: appointments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE appointments_id_seq OWNED BY appointments.id;


--
-- Name: authentications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE authentications (
    id integer NOT NULL,
    provider character varying(255),
    uid character varying(255),
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    email character varying(255)
);


--
-- Name: authentications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE authentications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: authentications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE authentications_id_seq OWNED BY authentications.id;


--
-- Name: cars; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cars (
    id integer NOT NULL,
    user_id integer,
    model_variation_id integer,
    year integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    display_title character varying(255),
    last_service_kms integer,
    last_service_date date,
    deleted_at timestamp without time zone,
    vin character varying(255),
    reg_number character varying(255)
);


--
-- Name: cars_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cars_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cars_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cars_id_seq OWNED BY cars.id;


--
-- Name: credit_cards; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE credit_cards (
    id integer NOT NULL,
    user_id integer,
    last_4 character varying(4),
    token character varying(255),
    braintree_customer_id character varying(255),
    card_type character varying(255)
);


--
-- Name: credit_cards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE credit_cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: credit_cards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE credit_cards_id_seq OWNED BY credit_cards.id;


--
-- Name: discounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE discounts (
    id integer NOT NULL,
    title character varying(255),
    code character varying(255),
    discount_type character varying(255),
    discount_value numeric(8,2),
    uses_left integer,
    starts_at date,
    ends_at date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    channel character varying(255)
);


--
-- Name: discounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE discounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: discounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE discounts_id_seq OWNED BY discounts.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events (
    id integer NOT NULL,
    occurs_until date,
    recurrence character varying(255),
    title character varying(255),
    mechanic_id integer,
    job_id integer,
    count integer,
    schedule text,
    start_time timestamp without time zone,
    end_time timestamp without time zone
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- Name: fixed_amounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE fixed_amounts (
    id integer NOT NULL,
    description character varying(255),
    cost numeric(8,2),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: fixed_amounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fixed_amounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fixed_amounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE fixed_amounts_id_seq OWNED BY fixed_amounts.id;


--
-- Name: imported_cars; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE imported_cars (
    id integer NOT NULL,
    make character varying(255),
    model character varying(255),
    year character varying(255),
    version text,
    transmission character varying(255),
    shape character varying(255),
    service text,
    price character varying(255),
    service_instructions text,
    parts text,
    service_inclusions text,
    notes text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: imported_cars_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE imported_cars_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: imported_cars_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE imported_cars_id_seq OWNED BY imported_cars.id;


--
-- Name: invitations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE invitations (
    id integer NOT NULL,
    user_id integer,
    sender_id integer,
    give_discount_id integer,
    get_discount_id integer,
    email character varying(255),
    created_at timestamp without time zone,
    accepted_at timestamp without time zone
);


--
-- Name: invitations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invitations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invitations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invitations_id_seq OWNED BY invitations.id;


--
-- Name: jobs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jobs (
    id integer NOT NULL,
    user_id integer,
    car_id integer,
    location_id integer,
    mechanic_id integer,
    contact_email character varying(255),
    contact_phone character varying(255),
    cost numeric(8,2),
    serialized_params text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    status character varying(255),
    title character varying(255),
    scheduled_at timestamp without time zone,
    assigned_at timestamp without time zone,
    credit_card_id integer,
    transaction_id character varying(255),
    transaction_status character varying(255),
    transaction_errors text,
    uid character varying(255),
    completed_at timestamp without time zone,
    discount_id integer,
    discount_amount numeric(8,2),
    final_cost numeric(8,2),
    search_terms character varying(255),
    delete_reason character varying(255),
    delete_reason_other character varying(255),
    estimate_deleted_at timestamp without time zone
);


--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE jobs_id_seq OWNED BY jobs.id;


--
-- Name: labours; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE labours (
    id integer NOT NULL,
    duration_hours integer,
    hourly_rate numeric(8,2),
    cost numeric(8,2),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    duration_minutes integer
);


--
-- Name: labours_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE labours_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: labours_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE labours_id_seq OWNED BY labours.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE locations (
    id integer NOT NULL,
    address character varying(255),
    postcode character varying(255),
    state_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    latitude numeric(12,8),
    longitude numeric(12,8),
    city character varying(255),
    suburb_id integer
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE locations_id_seq OWNED BY locations.id;


--
-- Name: makes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE makes (
    id integer NOT NULL,
    name character varying(255)
);


--
-- Name: makes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE makes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: makes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE makes_id_seq OWNED BY makes.id;


--
-- Name: mechanic_regions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mechanic_regions (
    id integer NOT NULL,
    mechanic_id integer,
    region_id integer,
    postcode character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: mechanic_regions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mechanic_regions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mechanic_regions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mechanic_regions_id_seq OWNED BY mechanic_regions.id;


--
-- Name: mechanics; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mechanics (
    id integer NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    email character varying(255),
    password character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    dob date,
    description text,
    driver_license_number character varying(255),
    license_state_id integer,
    license_expiry date,
    avatar character varying(255),
    driver_license character varying(255),
    abn character varying(255),
    mechanic_license character varying(255),
    business_website character varying(255),
    business_email character varying(255),
    years_as_a_mechanic integer,
    mobile_number character varying(255),
    other_number character varying(255),
    abn_number character varying(255),
    abn_expiry date,
    mechanic_license_number character varying(255),
    mechanic_license_expiry date,
    mechanic_license_state_id character varying(255),
    phone_verified boolean DEFAULT false,
    super_mechanic boolean DEFAULT false,
    warranty_covered boolean DEFAULT false,
    qualification_verified boolean DEFAULT false,
    location_id integer,
    business_location_id integer,
    total_earnings numeric(8,2) DEFAULT 0,
    current_jobs_count integer DEFAULT 0,
    completed_jobs_count integer DEFAULT 0,
    business_name character varying(255),
    business_mobile_number character varying(255),
    repair_work_classes text,
    tradesperson_certificates text,
    suspended_at timestamp without time zone,
    rating numeric(8,2) DEFAULT 0
);


--
-- Name: mechanics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mechanics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mechanics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mechanics_id_seq OWNED BY mechanics.id;


--
-- Name: model_variations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE model_variations (
    id integer NOT NULL,
    title character varying(255),
    identifier character varying(255),
    model_id integer,
    from_year integer,
    to_year integer,
    transmission character varying(255),
    fuel character varying(255),
    make_id integer,
    display_title character varying(255),
    comment text,
    detailed_title character varying(255),
    shape character varying(255)
);


--
-- Name: model_variations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE model_variations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: model_variations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE model_variations_id_seq OWNED BY model_variations.id;


--
-- Name: models; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE models (
    id integer NOT NULL,
    name character varying(255),
    make_id integer
);


--
-- Name: models_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE models_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: models_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE models_id_seq OWNED BY models.id;


--
-- Name: parts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE parts (
    id integer NOT NULL,
    name character varying(255),
    quantity integer,
    cost numeric(8,2),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    unit_cost numeric(8,2)
);


--
-- Name: parts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE parts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: parts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE parts_id_seq OWNED BY parts.id;


--
-- Name: payout_methods; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE payout_methods (
    id integer NOT NULL,
    account_name character varying(255),
    bsb_number character varying(255),
    account_number character varying(255),
    mechanic_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: payout_methods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE payout_methods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payout_methods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE payout_methods_id_seq OWNED BY payout_methods.id;


--
-- Name: payouts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE payouts (
    id integer NOT NULL,
    account_name character varying(255),
    account_number character varying(255),
    bsb_number character varying(255),
    transaction_id character varying(255),
    amount numeric(8,2),
    job_id integer,
    mechanic_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    receipt character varying(255)
);


--
-- Name: payouts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE payouts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE payouts_id_seq OWNED BY payouts.id;


--
-- Name: ratings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ratings (
    id integer NOT NULL,
    user_id integer,
    mechanic_id integer,
    job_id integer,
    professional integer,
    service_quality integer,
    communication integer,
    cleanness integer,
    convenience integer,
    comment text,
    recommend boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    published boolean,
    user_name character varying(255),
    mechanic_name character varying(255),
    job_title character varying(255)
);


--
-- Name: ratings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ratings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ratings_id_seq OWNED BY ratings.id;


--
-- Name: regions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE regions (
    id integer NOT NULL,
    name character varying(255),
    postcode integer,
    ancestry character varying(255),
    ancestry_depth integer DEFAULT 0,
    state_id integer,
    display_name character varying(255)
);


--
-- Name: regions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE regions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE regions_id_seq OWNED BY regions.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: service_costs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE service_costs (
    id integer NOT NULL,
    description character varying(255),
    cost numeric(8,2),
    service_plan_id integer
);


--
-- Name: service_costs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE service_costs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: service_costs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE service_costs_id_seq OWNED BY service_costs.id;


--
-- Name: service_plans; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE service_plans (
    id integer NOT NULL,
    title character varying(255),
    kms_travelled integer,
    months integer,
    cost numeric(8,2),
    make_id integer,
    model_id integer,
    model_variation_id integer,
    inclusions text,
    instructions text,
    parts text,
    notes text,
    display_title character varying(255)
);


--
-- Name: service_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE service_plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: service_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE service_plans_id_seq OWNED BY service_plans.id;


--
-- Name: symptoms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE symptoms (
    id integer NOT NULL,
    description character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    comment text,
    ancestry character varying(255)
);


--
-- Name: symptoms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE symptoms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: symptoms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE symptoms_id_seq OWNED BY symptoms.id;


--
-- Name: task_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE task_items (
    id integer NOT NULL,
    task_id integer,
    itemable_id integer,
    itemable_type character varying(255)
);


--
-- Name: task_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE task_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: task_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE task_items_id_seq OWNED BY task_items.id;


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tasks (
    id integer NOT NULL,
    type character varying(255),
    job_id integer,
    service_plan_id integer,
    note text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    title character varying(255),
    cost numeric(8,2),
    description text
);


--
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tasks_id_seq OWNED BY tasks.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    email character varying(255),
    password character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    confirmation_token character varying(255),
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    dob date,
    mobile_number character varying(255),
    description text,
    avatar character varying(255),
    braintree_customer_id character varying(255),
    location_id integer,
    suspended_at timestamp without time zone,
    referrer_code character varying(255),
    referred_by integer
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
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admins ALTER COLUMN id SET DEFAULT nextval('admins_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY appointments ALTER COLUMN id SET DEFAULT nextval('appointments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY authentications ALTER COLUMN id SET DEFAULT nextval('authentications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cars ALTER COLUMN id SET DEFAULT nextval('cars_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY credit_cards ALTER COLUMN id SET DEFAULT nextval('credit_cards_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY discounts ALTER COLUMN id SET DEFAULT nextval('discounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY fixed_amounts ALTER COLUMN id SET DEFAULT nextval('fixed_amounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY imported_cars ALTER COLUMN id SET DEFAULT nextval('imported_cars_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY invitations ALTER COLUMN id SET DEFAULT nextval('invitations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY jobs ALTER COLUMN id SET DEFAULT nextval('jobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY labours ALTER COLUMN id SET DEFAULT nextval('labours_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations ALTER COLUMN id SET DEFAULT nextval('locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY makes ALTER COLUMN id SET DEFAULT nextval('makes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mechanic_regions ALTER COLUMN id SET DEFAULT nextval('mechanic_regions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mechanics ALTER COLUMN id SET DEFAULT nextval('mechanics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY model_variations ALTER COLUMN id SET DEFAULT nextval('model_variations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY models ALTER COLUMN id SET DEFAULT nextval('models_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY parts ALTER COLUMN id SET DEFAULT nextval('parts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY payout_methods ALTER COLUMN id SET DEFAULT nextval('payout_methods_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY payouts ALTER COLUMN id SET DEFAULT nextval('payouts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ratings ALTER COLUMN id SET DEFAULT nextval('ratings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY regions ALTER COLUMN id SET DEFAULT nextval('regions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY service_costs ALTER COLUMN id SET DEFAULT nextval('service_costs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY service_plans ALTER COLUMN id SET DEFAULT nextval('service_plans_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY symptoms ALTER COLUMN id SET DEFAULT nextval('symptoms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY task_items ALTER COLUMN id SET DEFAULT nextval('task_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tasks ALTER COLUMN id SET DEFAULT nextval('tasks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (id);


--
-- Name: authorizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY authentications
    ADD CONSTRAINT authorizations_pkey PRIMARY KEY (id);


--
-- Name: brands_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY makes
    ADD CONSTRAINT brands_pkey PRIMARY KEY (id);


--
-- Name: cars_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cars
    ADD CONSTRAINT cars_pkey PRIMARY KEY (id);


--
-- Name: credit_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY credit_cards
    ADD CONSTRAINT credit_cards_pkey PRIMARY KEY (id);


--
-- Name: discounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY discounts
    ADD CONSTRAINT discounts_pkey PRIMARY KEY (id);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: fixed_amounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fixed_amounts
    ADD CONSTRAINT fixed_amounts_pkey PRIMARY KEY (id);


--
-- Name: imported_cars_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY imported_cars
    ADD CONSTRAINT imported_cars_pkey PRIMARY KEY (id);


--
-- Name: invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invitations
    ADD CONSTRAINT invitations_pkey PRIMARY KEY (id);


--
-- Name: jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: labours_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY labours
    ADD CONSTRAINT labours_pkey PRIMARY KEY (id);


--
-- Name: locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: mechanic_regions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mechanic_regions
    ADD CONSTRAINT mechanic_regions_pkey PRIMARY KEY (id);


--
-- Name: mechanics_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mechanics
    ADD CONSTRAINT mechanics_pkey PRIMARY KEY (id);


--
-- Name: model_variations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY model_variations
    ADD CONSTRAINT model_variations_pkey PRIMARY KEY (id);


--
-- Name: models_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY models
    ADD CONSTRAINT models_pkey PRIMARY KEY (id);


--
-- Name: parts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY parts
    ADD CONSTRAINT parts_pkey PRIMARY KEY (id);


--
-- Name: payout_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY payout_methods
    ADD CONSTRAINT payout_methods_pkey PRIMARY KEY (id);


--
-- Name: payouts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY payouts
    ADD CONSTRAINT payouts_pkey PRIMARY KEY (id);


--
-- Name: ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ratings
    ADD CONSTRAINT ratings_pkey PRIMARY KEY (id);


--
-- Name: regions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: service_costs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY service_costs
    ADD CONSTRAINT service_costs_pkey PRIMARY KEY (id);


--
-- Name: service_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY service_plans
    ADD CONSTRAINT service_plans_pkey PRIMARY KEY (id);


--
-- Name: symptoms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY symptoms
    ADD CONSTRAINT symptoms_pkey PRIMARY KEY (id);


--
-- Name: task_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY task_items
    ADD CONSTRAINT task_items_pkey PRIMARY KEY (id);


--
-- Name: tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_admins_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admins_on_email ON admins USING btree (email);


--
-- Name: index_admins_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admins_on_reset_password_token ON admins USING btree (reset_password_token);


--
-- Name: index_appointments_on_job_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_appointments_on_job_id ON appointments USING btree (job_id);


--
-- Name: index_appointments_on_mechanic_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_appointments_on_mechanic_id ON appointments USING btree (mechanic_id);


--
-- Name: index_appointments_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_appointments_on_user_id ON appointments USING btree (user_id);


--
-- Name: index_authentications_on_uid_and_provider; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_authentications_on_uid_and_provider ON authentications USING btree (uid, provider);


--
-- Name: index_authentications_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_authentications_on_user_id ON authentications USING btree (user_id);


--
-- Name: index_credit_cards_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_credit_cards_on_user_id ON credit_cards USING btree (user_id);


--
-- Name: index_discounts_on_channel; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_discounts_on_channel ON discounts USING btree (channel);


--
-- Name: index_discounts_on_code; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_discounts_on_code ON discounts USING btree (code);


--
-- Name: index_invitations_on_sender_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_invitations_on_sender_id ON invitations USING btree (sender_id);


--
-- Name: index_invitations_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_invitations_on_user_id ON invitations USING btree (user_id);


--
-- Name: index_jobs_on_discount_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_jobs_on_discount_id ON jobs USING btree (discount_id);


--
-- Name: index_jobs_on_mechanic_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_jobs_on_mechanic_id ON jobs USING btree (mechanic_id);


--
-- Name: index_jobs_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_jobs_on_user_id ON jobs USING btree (user_id);


--
-- Name: index_locations_on_suburb_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_locations_on_suburb_id ON locations USING btree (suburb_id);


--
-- Name: index_mechanic_regions_on_mechanic_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mechanic_regions_on_mechanic_id ON mechanic_regions USING btree (mechanic_id);


--
-- Name: index_mechanic_regions_on_mechanic_id_and_postcode; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mechanic_regions_on_mechanic_id_and_postcode ON mechanic_regions USING btree (mechanic_id, postcode);


--
-- Name: index_mechanic_regions_on_region_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mechanic_regions_on_region_id ON mechanic_regions USING btree (region_id);


--
-- Name: index_mechanics_on_business_location_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mechanics_on_business_location_id ON mechanics USING btree (business_location_id);


--
-- Name: index_mechanics_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_mechanics_on_email ON mechanics USING btree (email);


--
-- Name: index_mechanics_on_location_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mechanics_on_location_id ON mechanics USING btree (location_id);


--
-- Name: index_mechanics_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_mechanics_on_reset_password_token ON mechanics USING btree (reset_password_token);


--
-- Name: index_on_locations_location; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_on_locations_location ON locations USING gist (st_geographyfromtext((((('SRID=4326;POINT('::text || longitude) || ' '::text) || latitude) || ')'::text)));


--
-- Name: index_payout_methods_on_mechanic_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_payout_methods_on_mechanic_id ON payout_methods USING btree (mechanic_id);


--
-- Name: index_payouts_on_job_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_payouts_on_job_id ON payouts USING btree (job_id);


--
-- Name: index_payouts_on_mechanic_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_payouts_on_mechanic_id ON payouts USING btree (mechanic_id);


--
-- Name: index_ratings_on_job_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ratings_on_job_id ON ratings USING btree (job_id);


--
-- Name: index_ratings_on_mechanic_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ratings_on_mechanic_id ON ratings USING btree (mechanic_id);


--
-- Name: index_ratings_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ratings_on_user_id ON ratings USING btree (user_id);


--
-- Name: index_regions_name_vector; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_regions_name_vector ON regions USING gin (name gin_trgm_ops);


--
-- Name: index_regions_on_ancestry; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_regions_on_ancestry ON regions USING btree (ancestry);


--
-- Name: index_regions_on_display_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_regions_on_display_name ON regions USING btree (display_name);


--
-- Name: index_regions_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_regions_on_name ON regions USING btree (name);


--
-- Name: index_regions_on_name_and_postcode; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_regions_on_name_and_postcode ON regions USING btree (name, postcode);


--
-- Name: index_regions_on_postcode; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_regions_on_postcode ON regions USING btree (postcode);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_location_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_location_id ON users USING btree (location_id);


--
-- Name: index_users_on_referred_by; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_referred_by ON users USING btree (referred_by);


--
-- Name: index_users_on_referrer_code; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_referrer_code ON users USING btree (referrer_code);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20130828203712');

INSERT INTO schema_migrations (version) VALUES ('20130828203749');

INSERT INTO schema_migrations (version) VALUES ('20130828203819');

INSERT INTO schema_migrations (version) VALUES ('20130829165042');

INSERT INTO schema_migrations (version) VALUES ('20130829165126');

INSERT INTO schema_migrations (version) VALUES ('20130829165132');

INSERT INTO schema_migrations (version) VALUES ('20130903091127');

INSERT INTO schema_migrations (version) VALUES ('20130903183810');

INSERT INTO schema_migrations (version) VALUES ('20130910142455');

INSERT INTO schema_migrations (version) VALUES ('20130910151411');

INSERT INTO schema_migrations (version) VALUES ('20130910151444');

INSERT INTO schema_migrations (version) VALUES ('20130910153412');

INSERT INTO schema_migrations (version) VALUES ('20130910154003');

INSERT INTO schema_migrations (version) VALUES ('20130911125456');

INSERT INTO schema_migrations (version) VALUES ('20130911190812');

INSERT INTO schema_migrations (version) VALUES ('20130911203101');

INSERT INTO schema_migrations (version) VALUES ('20130918122858');

INSERT INTO schema_migrations (version) VALUES ('20130919071913');

INSERT INTO schema_migrations (version) VALUES ('20130920091119');

INSERT INTO schema_migrations (version) VALUES ('20130922161037');

INSERT INTO schema_migrations (version) VALUES ('20130923094110');

INSERT INTO schema_migrations (version) VALUES ('20130923130845');

INSERT INTO schema_migrations (version) VALUES ('20130924131003');

INSERT INTO schema_migrations (version) VALUES ('20130924145301');

INSERT INTO schema_migrations (version) VALUES ('20130924190449');

INSERT INTO schema_migrations (version) VALUES ('20130925132012');

INSERT INTO schema_migrations (version) VALUES ('20130930083730');

INSERT INTO schema_migrations (version) VALUES ('20131002115305');

INSERT INTO schema_migrations (version) VALUES ('20131002131413');

INSERT INTO schema_migrations (version) VALUES ('20131002131438');

INSERT INTO schema_migrations (version) VALUES ('20131002131905');

INSERT INTO schema_migrations (version) VALUES ('20131002134159');

INSERT INTO schema_migrations (version) VALUES ('20131002134703');

INSERT INTO schema_migrations (version) VALUES ('20131002141942');

INSERT INTO schema_migrations (version) VALUES ('20131003074235');

INSERT INTO schema_migrations (version) VALUES ('20131005084217');

INSERT INTO schema_migrations (version) VALUES ('20131005123616');

INSERT INTO schema_migrations (version) VALUES ('20131007145500');

INSERT INTO schema_migrations (version) VALUES ('20131008135515');

INSERT INTO schema_migrations (version) VALUES ('20131008143938');

INSERT INTO schema_migrations (version) VALUES ('20131008144550');

INSERT INTO schema_migrations (version) VALUES ('20131009151941');

INSERT INTO schema_migrations (version) VALUES ('20131009152333');

INSERT INTO schema_migrations (version) VALUES ('20131009164438');

INSERT INTO schema_migrations (version) VALUES ('20131010123007');

INSERT INTO schema_migrations (version) VALUES ('20131010145320');

INSERT INTO schema_migrations (version) VALUES ('20131014133810');

INSERT INTO schema_migrations (version) VALUES ('20131015094133');

INSERT INTO schema_migrations (version) VALUES ('20131016132106');

INSERT INTO schema_migrations (version) VALUES ('20131016133737');

INSERT INTO schema_migrations (version) VALUES ('20131018044121');

INSERT INTO schema_migrations (version) VALUES ('20131018085126');

INSERT INTO schema_migrations (version) VALUES ('20131023141250');

INSERT INTO schema_migrations (version) VALUES ('20131025093219');

INSERT INTO schema_migrations (version) VALUES ('20131025144458');

INSERT INTO schema_migrations (version) VALUES ('20131031132802');

INSERT INTO schema_migrations (version) VALUES ('20131105150958');

INSERT INTO schema_migrations (version) VALUES ('20131120131338');

INSERT INTO schema_migrations (version) VALUES ('20131120190546');

INSERT INTO schema_migrations (version) VALUES ('20131120192649');

INSERT INTO schema_migrations (version) VALUES ('20131125150816');

INSERT INTO schema_migrations (version) VALUES ('20131127134406');

INSERT INTO schema_migrations (version) VALUES ('20131204152756');

INSERT INTO schema_migrations (version) VALUES ('20131212202413');

INSERT INTO schema_migrations (version) VALUES ('20131212202952');

INSERT INTO schema_migrations (version) VALUES ('20131217145844');

INSERT INTO schema_migrations (version) VALUES ('20131217190922');

INSERT INTO schema_migrations (version) VALUES ('20131218161230');

INSERT INTO schema_migrations (version) VALUES ('20131219160457');

INSERT INTO schema_migrations (version) VALUES ('20131223143523');

INSERT INTO schema_migrations (version) VALUES ('20131223143821');

INSERT INTO schema_migrations (version) VALUES ('20131223164355');

INSERT INTO schema_migrations (version) VALUES ('20131224174010');

INSERT INTO schema_migrations (version) VALUES ('20131225151228');

INSERT INTO schema_migrations (version) VALUES ('20140108105707');

INSERT INTO schema_migrations (version) VALUES ('20140114132200');

INSERT INTO schema_migrations (version) VALUES ('20140115140743');

INSERT INTO schema_migrations (version) VALUES ('20140116101829');

INSERT INTO schema_migrations (version) VALUES ('20140117081109');

INSERT INTO schema_migrations (version) VALUES ('20140120121306');

INSERT INTO schema_migrations (version) VALUES ('20140120145046');

INSERT INTO schema_migrations (version) VALUES ('20140120145329');

INSERT INTO schema_migrations (version) VALUES ('20140121215503');

INSERT INTO schema_migrations (version) VALUES ('20140121215545');

INSERT INTO schema_migrations (version) VALUES ('20140123110341');

INSERT INTO schema_migrations (version) VALUES ('20140123111537');

INSERT INTO schema_migrations (version) VALUES ('20140127135118');

INSERT INTO schema_migrations (version) VALUES ('20140206150842');

INSERT INTO schema_migrations (version) VALUES ('20140211170449');

INSERT INTO schema_migrations (version) VALUES ('20140211221307');

INSERT INTO schema_migrations (version) VALUES ('20140214095427');

INSERT INTO schema_migrations (version) VALUES ('20140303155311');

INSERT INTO schema_migrations (version) VALUES ('20140326090031');

INSERT INTO schema_migrations (version) VALUES ('20140331173751');

INSERT INTO schema_migrations (version) VALUES ('20140407181553');

INSERT INTO schema_migrations (version) VALUES ('20140414110016');

INSERT INTO schema_migrations (version) VALUES ('20140414161446');

INSERT INTO schema_migrations (version) VALUES ('20140416153425');

INSERT INTO schema_migrations (version) VALUES ('20140417143542');

INSERT INTO schema_migrations (version) VALUES ('20140419092827');

INSERT INTO schema_migrations (version) VALUES ('20140425120216');

INSERT INTO schema_migrations (version) VALUES ('20140514200025');

INSERT INTO schema_migrations (version) VALUES ('20140519165519');

INSERT INTO schema_migrations (version) VALUES ('20140520120934');

INSERT INTO schema_migrations (version) VALUES ('20140521205442');

INSERT INTO schema_migrations (version) VALUES ('20140603090552');

INSERT INTO schema_migrations (version) VALUES ('20140605065806');

INSERT INTO schema_migrations (version) VALUES ('20140612152124');

INSERT INTO schema_migrations (version) VALUES ('20140616111744');

INSERT INTO schema_migrations (version) VALUES ('20140616122349');

INSERT INTO schema_migrations (version) VALUES ('20140616200244');

INSERT INTO schema_migrations (version) VALUES ('20140618164911');

INSERT INTO schema_migrations (version) VALUES ('20140620093639');

INSERT INTO schema_migrations (version) VALUES ('20140624095434');

INSERT INTO schema_migrations (version) VALUES ('20140625185317');

INSERT INTO schema_migrations (version) VALUES ('20140627105158');

INSERT INTO schema_migrations (version) VALUES ('20140704123108');

INSERT INTO schema_migrations (version) VALUES ('20140710193843');

INSERT INTO schema_migrations (version) VALUES ('20140711170953');

INSERT INTO schema_migrations (version) VALUES ('20140720101413');

INSERT INTO schema_migrations (version) VALUES ('20140720102750');

INSERT INTO schema_migrations (version) VALUES ('20140723123007');
