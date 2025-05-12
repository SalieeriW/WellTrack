--
-- adminQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: challenge; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.challenge (
    user_id integer NOT NULL,
    name character varying(100) DEFAULT 'name'::character varying NOT NULL,
    description character varying(100),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    progress numeric DEFAULT 0 NOT NULL,
    criteria character varying(100) NOT NULL,
    metric character varying(100) NOT NULL,
    completed boolean DEFAULT false NOT NULL
);


ALTER TABLE public.challenge OWNER TO admin;

--
-- Name: conf_pomodoro; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.conf_pomodoro (
    user_id integer NOT NULL,
    alert boolean DEFAULT true NOT NULL,
    restart_pomodoro boolean DEFAULT true NOT NULL,
    restart_break boolean DEFAULT true NOT NULL
);


ALTER TABLE public.conf_pomodoro OWNER TO admin;

--
-- Name: conf_report; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.conf_report (
    permitted boolean DEFAULT true NOT NULL,
    deep_think boolean DEFAULT true NOT NULL,
    auto_send boolean DEFAULT true NOT NULL,
    user_id integer NOT NULL,
    day_freq boolean DEFAULT true NOT NULL,
    week_freq boolean DEFAULT true NOT NULL,
    month_freq boolean DEFAULT true,
    trimester_freq boolean DEFAULT true NOT NULL
);


ALTER TABLE public.conf_report OWNER TO admin;

--
-- Name: conf_user; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.conf_user (
    auto_monitoring boolean DEFAULT true NOT NULL,
    camera boolean DEFAULT true NOT NULL,
    alert_frequency integer DEFAULT 0,
    duration integer DEFAULT 0,
    data_retention integer DEFAULT 15 NOT NULL,
    light_theme boolean DEFAULT true NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.conf_user OWNER TO admin;

--
-- Name: report; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.report (
    name character varying(100) DEFAULT 'daily_report'::character varying NOT NULL,
    description character varying(100) DEFAULT 'description'::character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    content text DEFAULT 'content'::text NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.report OWNER TO admin;

--
-- Name: token; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.token (
    email character varying(100) NOT NULL,
    token character varying(100) NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    password character varying(100) NOT NULL
);


ALTER TABLE public.token OWNER TO admin;

--
-- Name: user_data; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.user_data (
    user_id integer NOT NULL,
    hydration integer NOT NULL,
    breaks integer NOT NULL,
    posture_correction integer NOT NULL,
    nivel_of_stress integer NOT NULL,
    last_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    concentration_time integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_data OWNER TO admin;

--
-- Name: user_setup; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.user_setup (
    user_id integer NOT NULL,
    setup integer NOT NULL,
    work_time integer,
    short_break integer,
    long_break integer,
    name_challenge character varying(100)
);


ALTER TABLE public.user_setup OWNER TO admin;

--
-- Name: users; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(100),
    email character varying(100) NOT NULL,
    password character varying(255) NOT NULL
);


ALTER TABLE public.users OWNER TO admin;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO admin;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: challenge; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.challenge (user_id, name, description, created_at, progress, criteria, metric, completed) FROM stdin;
\.


--
-- Data for Name: conf_pomodoro; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.conf_pomodoro (user_id, alert, restart_pomodoro, restart_break) FROM stdin;
2	f	t	t
\.


--
-- Data for Name: conf_report; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.conf_report (permitted, deep_think, auto_send, user_id, day_freq, week_freq, month_freq, trimester_freq) FROM stdin;
f	t	t	2	t	t	t	t
\.


--
-- Data for Name: conf_user; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.conf_user (auto_monitoring, camera, alert_frequency, duration, data_retention, light_theme, user_id) FROM stdin;
f	t	90	90	90	t	2
\.


--
-- Data for Name: report; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.report (name, description, created_at, content, user_id) FROM stdin;
daily_report	description	2025-04-27 16:16:52.285274+00	content	2
\.


--
-- Data for Name: token; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.token (email, token, expires_at, password) FROM stdin;
xuanyi.qiu@estudiantat.upc.edu	a1e844a3-b07b-4b63-81e4-04f9cb90eef3	2025-04-17 20:27:04.015+00	password
\.


--
-- Data for Name: user_data; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.user_data (user_id, hydration, breaks, posture_correction, nivel_of_stress, last_updated, concentration_time) FROM stdin;
2	10	10	10	10	2025-04-24 11:57:19.107501+00	0
2	10	10	10	10	2025-04-22 11:59:39.144486+00	0
2	10	10	10	10	2025-04-14 11:59:44.106649+00	0
\.


--
-- Data for Name: user_setup; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.user_setup (user_id, setup, work_time, short_break, long_break, name_challenge) FROM stdin;
2	1	25	5	15	Challenge 1
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.users (id, name, email, password) FROM stdin;
2	\N	test@test.test	testtest
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.users_id_seq', 4, true);


--
-- Name: conf_user Conf_user_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.conf_user
    ADD CONSTRAINT "Conf_user_pkey" PRIMARY KEY (user_id);


--
-- Name: challenge challenge_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.challenge
    ADD CONSTRAINT challenge_pkey PRIMARY KEY (user_id, name);


--
-- Name: conf_pomodoro conf_pomodoro_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.conf_pomodoro
    ADD CONSTRAINT conf_pomodoro_pkey PRIMARY KEY (user_id);


--
-- Name: conf_report conf_report_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.conf_report
    ADD CONSTRAINT conf_report_pkey PRIMARY KEY (user_id);


--
-- Name: token token_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.token
    ADD CONSTRAINT token_pkey PRIMARY KEY (email);


--
-- Name: user_setup user_setup_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_setup
    ADD CONSTRAINT user_setup_pkey PRIMARY KEY (user_id, setup);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: conf_user user_id; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.conf_user
    ADD CONSTRAINT user_id FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: conf_report user_id; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.conf_report
    ADD CONSTRAINT user_id FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: report user_id; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.report
    ADD CONSTRAINT user_id FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- Name: user_data user_id; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_data
    ADD CONSTRAINT user_id FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- Name: challenge user_id; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.challenge
    ADD CONSTRAINT user_id FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- Name: conf_pomodoro user_id; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.conf_pomodoro
    ADD CONSTRAINT user_id FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- Name: user_setup user_id; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_setup
    ADD CONSTRAINT user_id FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- adminQL database dump complete
--

--
-- Dummy Data for Tables (Partial)
--

-- users
INSERT INTO public.users (id, name, email, password) VALUES
(1, 'Alice Wonderland', 'alice@example.com', 'hashed_password_alice'),
(3, 'Bob The Builder', 'bob@example.com', 'hashed_password_bob');

-- challenge
INSERT INTO public.challenge (user_id, name, description, created_at, progress, criteria, metric, completed) VALUES
(1, 'Read 10 Books', 'Read 10 books this year', '2025-01-01 10:00:00+00', 3, '10', 'books', false),
(1, 'Read 5 Books', 'Read 10 books this year', '2025-05-06 10:00:00+00', 3, '10', 'books', true),
(1, 'Read 4 Books', 'Read 10 books this year', '2025-05-03 10:00:00+00', 3, '10', 'books', false),
(1, 'Read 3 Books', 'Read 10 books this year', '2025-05-01 10:00:00+00', 3, '10', 'books', false),
(1, 'Read 2 Books', 'Read 10 books this year', '2025-05-01 10:00:00+00', 3, '10', 'books', true),
(3, 'Code 100 Hours', 'Spend 100 hours coding', '2025-02-15 14:30:00+00', 65.5, '100', 'hours', false);

-- conf_pomodoro
INSERT INTO public.conf_pomodoro (user_id, alert, restart_pomodoro, restart_break) VALUES
(1, true, true, false),
(3, false, true, true);

-- conf_report
INSERT INTO public.conf_report (permitted, deep_think, auto_send, user_id, day_freq, week_freq, month_freq, trimester_freq) VALUES
(true, true, true, 1, true, true, true, true),
(true, false, false, 3, false, true, false, true);

-- conf_user
INSERT INTO public.conf_user (auto_monitoring, camera, alert_frequency, duration, data_retention, light_theme, user_id) VALUES
(true, true, 60, 25, 30, true, 1),
(false, false, 0, 0, 7, false, 3);

-- report
-- report (Corrected)
INSERT INTO public.report (name, description, created_at, content, user_id) VALUES
('Daily Report 2025-04-26', 'Daily summary of activity', '2025-04-26 20:00:00+00', 'Hydration: 1.9L, Breaks: 5, Posture: 8, Stress: 3', 1),
('Weekly Report 2025-04-21 to 2025-04-27', 'Weekly overview', '2025-04-27 18:00:00+00', 'Average Hydration: 1.7L, Total Breaks: 30...', 3);

-- token
INSERT INTO public.token (email, token, expires_at, password) VALUES
('bob@example.com', 'reset_token_bob', '2025-05-01 12:00:00+00', 'old_hashed_password_bob');

-- user_data
INSERT INTO public.user_data (user_id, hydration, breaks, posture_correction, nivel_of_stress, concentration_time, last_updated) VALUES
(1, 2, 7, 12, 2, 10, '2025-04-27 16:05:00+00'),
(3, 5, 3, 5, 4, 20, '2025-04-27 16:10:00+00');

-- user_setup
INSERT INTO public.user_setup (user_id, setup, work_time, short_break, long_break, name_challenge) VALUES
(1, 1, 25, 5, 15, 'Focus Challenge'),
(3, 1, 50, 10, 20, 'Deep Work Session');


SET search_path TO public;