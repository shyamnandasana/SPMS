--
-- PostgreSQL database dump
--

\restrict DLknUCS5dtvLDHq2Q4klk3IdOK0vNM9IFd1CnfHMRB42bklqaqPPib0g9tOwwxv

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

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

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: ProjectStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."ProjectStatus" AS ENUM (
    'PROPOSED',
    'APPROVED',
    'IN_PROGRESS',
    'COMPLETED',
    'REJECTED'
);


--
-- Name: Role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."Role" AS ENUM (
    'ADMIN',
    'FACULTY',
    'STUDENT'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: AcademicYear; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."AcademicYear" (
    id text NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    "startDate" timestamp(3) without time zone NOT NULL,
    "endDate" timestamp(3) without time zone NOT NULL,
    "isCurrent" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: ActivityLog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."ActivityLog" (
    id text NOT NULL,
    "projectId" text NOT NULL,
    "userId" text NOT NULL,
    action text NOT NULL,
    details text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: Department; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Department" (
    id text NOT NULL,
    name text NOT NULL,
    code text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: Document; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Document" (
    id text NOT NULL,
    "projectId" text NOT NULL,
    name text NOT NULL,
    url text NOT NULL,
    type text NOT NULL,
    "uploadedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: FacultyProfile; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."FacultyProfile" (
    id text NOT NULL,
    "userId" text NOT NULL,
    department text NOT NULL,
    designation text NOT NULL,
    expertise text[]
);


--
-- Name: Grade; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Grade" (
    id text NOT NULL,
    "studentId" text NOT NULL,
    "projectId" text NOT NULL,
    marks double precision NOT NULL,
    comments text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: Meeting; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Meeting" (
    id text NOT NULL,
    "projectId" text NOT NULL,
    title text NOT NULL,
    date timestamp(3) without time zone NOT NULL,
    minutes text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: MeetingAttendance; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."MeetingAttendance" (
    id text NOT NULL,
    "meetingId" text NOT NULL,
    "studentId" text NOT NULL,
    "isPresent" boolean DEFAULT false NOT NULL,
    remarks text
);


--
-- Name: Message; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Message" (
    id text NOT NULL,
    "senderId" text NOT NULL,
    content text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: Milestone; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Milestone" (
    id text NOT NULL,
    "projectId" text NOT NULL,
    title text NOT NULL,
    deadline timestamp(3) without time zone NOT NULL,
    "isCompleted" boolean DEFAULT false NOT NULL
);


--
-- Name: Notification; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Notification" (
    id text NOT NULL,
    "userId" text NOT NULL,
    title text NOT NULL,
    message text NOT NULL,
    "isRead" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: Project; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Project" (
    id text NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    "typeId" text NOT NULL,
    status public."ProjectStatus" DEFAULT 'PROPOSED'::public."ProjectStatus" NOT NULL,
    "groupId" text NOT NULL,
    "guideId" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: ProjectGroup; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."ProjectGroup" (
    id text NOT NULL,
    name text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: ProjectType; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."ProjectType" (
    id text NOT NULL,
    name text NOT NULL,
    description text
);


--
-- Name: StudentProfile; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."StudentProfile" (
    id text NOT NULL,
    "userId" text NOT NULL,
    "idNumber" text NOT NULL,
    department text NOT NULL,
    batch text NOT NULL,
    "groupId" text,
    "isLeader" boolean DEFAULT false NOT NULL
);


--
-- Name: StudentTask; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."StudentTask" (
    id text NOT NULL,
    "studentId" text NOT NULL,
    title text NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: User; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."User" (
    id text NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    "fullName" text NOT NULL,
    role public."Role" DEFAULT 'STUDENT'::public."Role" NOT NULL,
    "avatarUrl" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL
);


--
-- Data for Name: AcademicYear; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."AcademicYear" (id, name, slug, "startDate", "endDate", "isCurrent", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: ActivityLog; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."ActivityLog" (id, "projectId", "userId", action, details, "createdAt") FROM stdin;
cmm23ec8c0007h466cgdntnia	PRJ-1772026423360	fac-user-1	Project Initialization	Project structure and milestones established.	2026-02-25 13:51:01.74
\.


--
-- Data for Name: Department; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Department" (id, name, code, "createdAt", "updatedAt") FROM stdin;
cmm22j88g0000xg66mbp4vnud	Computer Science and Engineering	CSE	2026-02-25 13:26:50.224	2026-02-25 13:26:50.224
cmm22j88i0002xg660c513xsk	Mechanical Engineering	ME	2026-02-25 13:26:50.226	2026-02-25 13:26:50.226
cmm22j88h0001xg66u9nnx9y1	Information and Communication Technology	ICT	2026-02-25 13:26:50.225	2026-02-25 13:26:50.225
\.


--
-- Data for Name: Document; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Document" (id, "projectId", name, url, type, "uploadedAt") FROM stdin;
9536c19a-2cd5-49f3-a6ab-c6140fcc109e	PRJ-1772026423360	srs	/uploads/1772033666534-267351750.pdf	REPORT	2026-02-25 15:34:26.581
03485414-021a-423f-845f-fc8d57487ab7	PRJ-1773234779414	Project Doumentation	/uploads/1773299055428-468188862.pdf	REPORT	2026-03-12 07:04:15.46
56b850f0-4019-4ce1-ad54-efca5dccba92	PRJ-1773299543084	fefe	/uploads/1773300470777-113900645.pdf	REPORT	2026-03-12 07:27:50.797
\.


--
-- Data for Name: FacultyProfile; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."FacultyProfile" (id, "userId", department, designation, expertise) FROM stdin;
fprof-0	fac-user-0	Computer Science and Engineering	Head of Department	{"Machine Learning","Cloud Computing",IoT}
fprof-1	fac-user-1	Information and Communication Technology	Assistant Professor	{"Machine Learning","Cloud Computing",IoT}
fprof-3	fac-user-3	Computer Science and Engineering	Assistant Professor	{"Machine Learning","Cloud Computing",IoT}
fprof-4	fac-user-4	Information and Communication Technology	Assistant Professor	{"Machine Learning","Cloud Computing",IoT}
fprof-5	fac-user-5	Mechanical Engineering	Assistant Professor	{"Machine Learning","Cloud Computing",IoT}
fprof-2	fac-user-2	Mechanical Engineering	Assistant Professor	{"Machine Learning","Cloud Computing",IoT}
\.


--
-- Data for Name: Grade; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Grade" (id, "studentId", "projectId", marks, comments, "createdAt", "updatedAt") FROM stdin;
g-sprof-2-PRJ-1772026423360	sprof-2	PRJ-1772026423360	88	Consistent progress.	2026-02-25 13:51:01.945	2026-02-25 13:51:01.945
g-sprof-7-PRJ-1772026423360	sprof-7	PRJ-1772026423360	50	Consistent progress.	2026-02-25 13:51:01.962	2026-02-25 14:18:18.164
\.


--
-- Data for Name: Meeting; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Meeting" (id, "projectId", title, date, minutes, "createdAt") FROM stdin;
cmm23ec7c0000h4661s5gqkmq	PRJ-1772026423360	Initial Ideas	2026-02-11 13:51:01.7	Discussed core features.	2026-02-25 13:51:01.703
cmm23ec7t0003h4660dukfeky	PRJ-1772026423360	Weekly Sync #1	2026-02-18 13:51:01.7	Backend setup complete.	2026-02-25 13:51:01.72
cmm23ec870006h4661kj9wisx	PRJ-1772026423360	Design Review	2026-02-25 13:51:01.7	\N	2026-02-25 13:51:01.735
cmm24e29w00000g66h5fq9zar	PRJ-1772026423360	cdehcvdecv	2026-02-25 16:20:00	\N	2026-02-25 14:18:48.451
cmm24e2rn00010g66gyy1yqdu	PRJ-1772026423360	cdehcvdecv	2026-02-25 16:20:00	\N	2026-02-25 14:18:49.091
cmm24nfiw00020g66clu1yydj	PRJ-1772026423360	fftdd	2026-02-25 14:29:00	\N	2026-02-25 14:26:05.528
cmm24nfwv00030g666s0g8l06	PRJ-1772026423360	fftdd	2026-02-25 14:29:00	\N	2026-02-25 14:26:06.03
cmmm2bibv00009o661a3tj9o2	PRJ-1773234779414	For Intoduction	2026-03-19 13:16:00	\N	2026-03-11 13:16:13.579
\.


--
-- Data for Name: MeetingAttendance; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."MeetingAttendance" (id, "meetingId", "studentId", "isPresent", remarks) FROM stdin;
cmm23ec7h0001h466zip6baye	cmm23ec7c0000h4661s5gqkmq	sprof-2	t	\N
cmm23ec7p0002h4665jiyfslb	cmm23ec7c0000h4661s5gqkmq	sprof-7	t	\N
cmm23ec7v0004h466tro9inny	cmm23ec7t0003h4660dukfeky	sprof-2	t	\N
cmm23ec800005h4661pe85s7j	cmm23ec7t0003h4660dukfeky	sprof-7	t	\N
\.


--
-- Data for Name: Message; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Message" (id, "senderId", content, "createdAt") FROM stdin;
\.


--
-- Data for Name: Milestone; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Milestone" (id, "projectId", title, deadline, "isCompleted") FROM stdin;
mil-PRJ-1772026423360-p	PRJ-1772026423360	Project Planning	2025-03-01 00:00:00	t
mil-PRJ-1772026423360-d	PRJ-1772026423360	System Design	2025-04-15 00:00:00	f
mil-PRJ-1772026423360-i	PRJ-1772026423360	Implementation	2025-05-30 00:00:00	f
9e974410-c2b5-469c-a131-6ed7ee604e7a	PRJ-1773234779414	Won th enational leval hackethon	2026-03-13 00:00:00	f
\.


--
-- Data for Name: Notification; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Notification" (id, "userId", title, message, "isRead", "createdAt") FROM stdin;
\.


--
-- Data for Name: Project; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Project" (id, title, description, "typeId", status, "groupId", "guideId", "createdAt", "updatedAt") FROM stdin;
PRJ-1772026423360	Demo	sdnjje fjee fje	cmm4kpges0000zk66vje89a69	APPROVED	GRP-1772026423318	fprof-1	2026-02-25 13:33:43.373	2026-03-11 13:11:57.634
PRJ-1773234779414	SPMS	Peoject About ....	cmm4kpges0000zk66vje89a69	APPROVED	GRP-1773234779395	fprof-2	2026-03-11 13:12:59.422	2026-03-12 07:05:14.904
PRJ-1773299295052	RMS	Project about resource	cmm22j8aa0004xg66klr7v6vj	REJECTED	GRP-1773299295040	fprof-0	2026-03-12 07:08:15.059	2026-03-12 07:10:46.9
PRJ-1773299543084	Hackmania	fbebfebf e	cmm4kpges0000zk66vje89a69	APPROVED	GRP-1773299543068	fprof-0	2026-03-12 07:12:23.087	2026-03-12 07:17:41.736
\.


--
-- Data for Name: ProjectGroup; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."ProjectGroup" (id, name, "createdAt") FROM stdin;
group-3	Team Deepak	2026-02-25 13:26:50.415
group-4	Team Neha	2026-02-25 13:26:50.432
GRP-1773234779395	Coder	2026-03-11 13:12:59.399
GRP-1772026423318	Demo Group	2026-02-25 13:33:43.34
GRP-1773299295040	Codex	2026-03-12 07:08:15.041
GRP-1773299543068	bfejjfbevehbbf 	2026-03-12 07:12:23.071
\.


--
-- Data for Name: ProjectType; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."ProjectType" (id, name, description) FROM stdin;
cmm22j8aa0004xg66klr7v6vj	Industry Project	Projects in collaboration with industry
cmm22j8a90003xg662o4mrcq0	In-House Project	Internal university projects
cmm4kpges0000zk66vje89a69	MAJOR	\N
\.


--
-- Data for Name: StudentProfile; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."StudentProfile" (id, "userId", "idNumber", department, batch, "groupId", "isLeader") FROM stdin;
sprof-11	std-user-11	2101010111	Mechanical Engineering	2021-2025	group-3	f
sprof-1	std-user-1	2101010101	Information and Communication Technology	2021-2025	\N	f
sprof-6	std-user-6	2101010106	Computer Science and Engineering	2021-2025	\N	f
sprof-8	std-user-8	2101010108	Mechanical Engineering	2021-2025	\N	f
sprof-3	std-user-3	2101010103	Computer Science and Engineering	2021-2025	\N	f
sprof-5	std-user-5	2101010105	Mechanical Engineering	2021-2025	GRP-1772026423318	f
sprof-12	std-user-12	2101010112	Computer Science and Engineering	2021-2025	GRP-1772026423318	f
sprof-0	std-user-0	2101010100	Computer Science and Engineering	2021-2025	GRP-1773299295040	f
sprof-4	std-user-4	2101010104	Information and Communication Technology	2021-2025	GRP-1773299295040	f
sprof-10	std-user-10	2101010110	Information and Communication Technology	2021-2025	GRP-1773299295040	f
sprof-2	std-user-2	2101010102	Mechanical Engineering	2021-2025	GRP-1773299543068	f
sprof-7	std-user-7	2101010107	Information and Communication Technology	2021-2025	GRP-1773299543068	f
sprof-9	std-user-9	2101010109	Computer Science and Engineering	2021-2025	GRP-1773299543068	f
\.


--
-- Data for Name: StudentTask; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."StudentTask" (id, "studentId", title, status, "createdAt", "updatedAt") FROM stdin;
cmm23ec8p0008h466emg9klj3	sprof-0	Setup Git	pending	2026-02-25 13:51:01.753	2026-02-25 13:51:01.753
cmm23ec8z0009h466zdl0hgrn	sprof-0	Install Dependencies	pending	2026-02-25 13:51:01.763	2026-02-25 13:51:01.763
cmm23ec92000ah4665cwn7kd2	sprof-0	Define Schema	pending	2026-02-25 13:51:01.766	2026-02-25 13:51:01.766
cmm23ec97000bh466kocqdqxd	sprof-0	Login Page UI	completed	2026-02-25 13:51:01.77	2026-02-25 13:51:01.77
cmm23ec9c000ch466wdt6kqi5	sprof-1	Setup Git	completed	2026-02-25 13:51:01.776	2026-02-25 13:51:01.776
cmm23ec9m000eh4661lot8iu6	sprof-1	Define Schema	completed	2026-02-25 13:51:01.786	2026-02-25 13:51:01.786
cmm23ec9r000fh46613x5oga5	sprof-1	Login Page UI	completed	2026-02-25 13:51:01.791	2026-02-25 13:51:01.791
cmm23ec9w000gh46664r9cdkm	sprof-3	Setup Git	pending	2026-02-25 13:51:01.796	2026-02-25 13:51:01.796
cmm23eca2000hh466l0vjmdi1	sprof-3	Install Dependencies	pending	2026-02-25 13:51:01.801	2026-02-25 13:51:01.801
cmm23eca5000ih466yx9v87br	sprof-3	Define Schema	completed	2026-02-25 13:51:01.805	2026-02-25 13:51:01.805
cmm23eca8000jh4667ns7o8y4	sprof-3	Login Page UI	completed	2026-02-25 13:51:01.808	2026-02-25 13:51:01.808
cmm23ecab000kh4669hf3x0qw	sprof-4	Setup Git	pending	2026-02-25 13:51:01.811	2026-02-25 13:51:01.811
cmm23ecaf000lh466iaaz2bxw	sprof-4	Install Dependencies	pending	2026-02-25 13:51:01.815	2026-02-25 13:51:01.815
cmm23ecai000mh466uuc7qgcp	sprof-4	Define Schema	completed	2026-02-25 13:51:01.818	2026-02-25 13:51:01.818
cmm23ecam000nh466jax1kox2	sprof-4	Login Page UI	pending	2026-02-25 13:51:01.822	2026-02-25 13:51:01.822
cmm23ecaq000oh466t4asw1w3	sprof-5	Setup Git	completed	2026-02-25 13:51:01.826	2026-02-25 13:51:01.826
cmm23ecau000ph466j4bitczu	sprof-5	Install Dependencies	completed	2026-02-25 13:51:01.83	2026-02-25 13:51:01.83
cmm23ecay000qh4669z5f1ebc	sprof-5	Define Schema	pending	2026-02-25 13:51:01.834	2026-02-25 13:51:01.834
cmm23ecb3000rh4662weg3t2v	sprof-5	Login Page UI	pending	2026-02-25 13:51:01.839	2026-02-25 13:51:01.839
cmm23ecb8000sh4663i6pz81z	sprof-6	Setup Git	completed	2026-02-25 13:51:01.844	2026-02-25 13:51:01.844
cmm23ecbc000th466u3r33ped	sprof-6	Install Dependencies	completed	2026-02-25 13:51:01.847	2026-02-25 13:51:01.847
cmm23ecbf000uh46671t72zhy	sprof-6	Define Schema	completed	2026-02-25 13:51:01.851	2026-02-25 13:51:01.851
cmm23ecbi000vh4668s49y7qj	sprof-6	Login Page UI	pending	2026-02-25 13:51:01.854	2026-02-25 13:51:01.854
cmm23ecbm000wh466mezrx0gb	sprof-8	Setup Git	completed	2026-02-25 13:51:01.858	2026-02-25 13:51:01.858
cmm23ecbp000xh466z2vfal8g	sprof-8	Install Dependencies	pending	2026-02-25 13:51:01.861	2026-02-25 13:51:01.861
cmm23ecbu000yh466q6kid2wc	sprof-8	Define Schema	completed	2026-02-25 13:51:01.866	2026-02-25 13:51:01.866
cmm23ecbx000zh466nv7tzuge	sprof-8	Login Page UI	completed	2026-02-25 13:51:01.869	2026-02-25 13:51:01.869
cmm23ecc00010h466kfyejvqt	sprof-9	Setup Git	completed	2026-02-25 13:51:01.872	2026-02-25 13:51:01.872
cmm23ecc30011h4660u64ds1q	sprof-9	Install Dependencies	pending	2026-02-25 13:51:01.875	2026-02-25 13:51:01.875
cmm23ecc70012h466v8zt628o	sprof-9	Define Schema	completed	2026-02-25 13:51:01.879	2026-02-25 13:51:01.879
cmm23ecc90013h4664krsgfs6	sprof-9	Login Page UI	pending	2026-02-25 13:51:01.881	2026-02-25 13:51:01.881
cmm23eccd0014h466barvpfao	sprof-10	Setup Git	completed	2026-02-25 13:51:01.885	2026-02-25 13:51:01.885
cmm23eccf0015h466eml6d4s7	sprof-10	Install Dependencies	completed	2026-02-25 13:51:01.887	2026-02-25 13:51:01.887
cmm23ecci0016h466ms44arbg	sprof-10	Define Schema	completed	2026-02-25 13:51:01.89	2026-02-25 13:51:01.89
cmm23ecco0017h4668n1ie54a	sprof-10	Login Page UI	completed	2026-02-25 13:51:01.896	2026-02-25 13:51:01.896
cmm23ecct0018h4666d12wtzk	sprof-11	Setup Git	pending	2026-02-25 13:51:01.901	2026-02-25 13:51:01.901
cmm23eccx0019h466s0t737lb	sprof-11	Install Dependencies	pending	2026-02-25 13:51:01.905	2026-02-25 13:51:01.905
cmm23ecd3001ah466kvx1d54p	sprof-11	Define Schema	completed	2026-02-25 13:51:01.911	2026-02-25 13:51:01.911
cmm23ecd9001bh466ezyh0t3n	sprof-11	Login Page UI	pending	2026-02-25 13:51:01.917	2026-02-25 13:51:01.917
cmm23ecdc001ch466h5stxg6d	sprof-12	Setup Git	completed	2026-02-25 13:51:01.92	2026-02-25 13:51:01.92
cmm23ecdf001dh4662s258zyr	sprof-12	Install Dependencies	pending	2026-02-25 13:51:01.923	2026-02-25 13:51:01.923
cmm23ecdh001eh466xgmy778y	sprof-12	Define Schema	pending	2026-02-25 13:51:01.925	2026-02-25 13:51:01.925
cmm23ecdj001fh4666ai59ya8	sprof-12	Login Page UI	pending	2026-02-25 13:51:01.927	2026-02-25 13:51:01.927
cmm23ecdn001hh4666lrq3p3p	sprof-2	Install Dependencies	completed	2026-02-25 13:51:01.931	2026-02-25 13:51:01.931
cmm23ecdu001jh466i57g76oe	sprof-2	Login Page UI	pending	2026-02-25 13:51:01.938	2026-02-25 13:51:01.938
cmm23ece8001kh466xg17trus	sprof-7	Setup Git	pending	2026-02-25 13:51:01.952	2026-02-25 13:51:01.952
cmm23ecea001lh4667orhvfyr	sprof-7	Install Dependencies	pending	2026-02-25 13:51:01.954	2026-02-25 13:51:01.954
cmm23eced001mh466p45hix61	sprof-7	Define Schema	pending	2026-02-25 13:51:01.957	2026-02-25 13:51:01.957
cmm23ecef001nh466b4uzcbqu	sprof-7	Login Page UI	pending	2026-02-25 13:51:01.959	2026-02-25 13:51:01.959
cmm23ecdm001gh466gxarnwta	sprof-2	Setup Git	completed	2026-02-25 13:51:01.929	2026-02-25 15:34:49.482
cmm23ec9h000dh466rnmsbl01	sprof-1	Install Dependencies	completed	2026-02-25 13:51:01.781	2026-03-11 13:18:01.24
cmm23ecdq001ih466vdqencd2	sprof-2	Define Schema	completed	2026-02-25 13:51:01.934	2026-03-12 06:57:20.804
cmmn48e2k0000kc664i0m8b7l	sprof-2	Database	completed	2026-03-12 06:57:33.499	2026-03-12 07:35:46.111
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."User" (id, email, password, "fullName", role, "avatarUrl", "createdAt", "updatedAt", "isActive") FROM stdin;
admin-1	admin@spms.edu	$2b$10$9gQemT8CRy42ISWJcgZZyOOdI8G4wxN9P3aoG5W6ZO5BW.EA0PcB.	System Admin	ADMIN	\N	2026-02-25 13:26:50.295	2026-02-25 13:26:50.295	t
fac-user-0	fac0@darshan.ac.in	$2b$10$9gQemT8CRy42ISWJcgZZyOOdI8G4wxN9P3aoG5W6ZO5BW.EA0PcB.	Dr. Nilesh Advani	FACULTY	\N	2026-02-25 13:26:50.321	2026-02-25 13:26:50.321	t
fac-user-1	fac1@darshan.ac.in	$2b$10$9gQemT8CRy42ISWJcgZZyOOdI8G4wxN9P3aoG5W6ZO5BW.EA0PcB.	Prof. Gopi Sanghani	FACULTY	\N	2026-02-25 13:26:50.33	2026-02-25 13:26:50.33	t
fac-user-3	fac3@darshan.ac.in	$2b$10$9gQemT8CRy42ISWJcgZZyOOdI8G4wxN9P3aoG5W6ZO5BW.EA0PcB.	Dr. Vijay Gadhavi	FACULTY	\N	2026-02-25 13:26:50.34	2026-02-25 13:26:50.34	t
fac-user-4	fac4@darshan.ac.in	$2b$10$9gQemT8CRy42ISWJcgZZyOOdI8G4wxN9P3aoG5W6ZO5BW.EA0PcB.	Prof. Rupesh Gajjar	FACULTY	\N	2026-02-25 13:26:50.345	2026-02-25 13:26:50.345	t
fac-user-5	fac5@darshan.ac.in	$2b$10$9gQemT8CRy42ISWJcgZZyOOdI8G4wxN9P3aoG5W6ZO5BW.EA0PcB.	Dr. Swati Sharma	FACULTY	\N	2026-02-25 13:26:50.352	2026-02-25 13:26:50.352	t
std-user-0	std0@darshan.ac.in	$2b$10$9gQemT8CRy42ISWJcgZZyOOdI8G4wxN9P3aoG5W6ZO5BW.EA0PcB.	Rahul Mehta	STUDENT	\N	2026-02-25 13:26:50.362	2026-02-25 13:26:50.362	t
std-user-1	std1@darshan.ac.in	$2b$10$9gQemT8CRy42ISWJcgZZyOOdI8G4wxN9P3aoG5W6ZO5BW.EA0PcB.	Sneha Patel	STUDENT	\N	2026-02-25 13:26:50.37	2026-02-25 13:26:50.37	t
std-user-2	std2@darshan.ac.in	$2b$10$9gQemT8CRy42ISWJcgZZyOOdI8G4wxN9P3aoG5W6ZO5BW.EA0PcB.	Amit Shah	STUDENT	\N	2026-02-25 13:26:50.376	2026-02-25 13:26:50.376	t
std-user-3	std3@darshan.ac.in	$2b$10$9gQemT8CRy42ISWJcgZZyOOdI8G4wxN9P3aoG5W6ZO5BW.EA0PcB.	Priya Sharma	STUDENT	\N	2026-02-25 13:26:50.384	2026-02-25 13:26:50.384	t
std-user-4	std4@darshan.ac.in	$2b$10$9gQemT8CRy42ISWJcgZZyOOdI8G4wxN9P3aoG5W6ZO5BW.EA0PcB.	Rajiv Joshi	STUDENT	\N	2026-02-25 13:26:50.39	2026-02-25 13:26:50.39	t
std-user-5	std5@darshan.ac.in	$2b$10$9gQemT8CRy42ISWJcgZZyOOdI8G4wxN9P3aoG5W6ZO5BW.EA0PcB.	Kavita Vyas	STUDENT	\N	2026-02-25 13:26:50.396	2026-02-25 13:26:50.396	t
std-user-6	std6@darshan.ac.in	$2b$10$9gQemT8CRy42ISWJcgZZyOOdI8G4wxN9P3aoG5W6ZO5BW.EA0PcB.	Siddharth Rana	STUDENT	\N	2026-02-25 13:26:50.403	2026-02-25 13:26:50.403	t
std-user-7	std7@darshan.ac.in	$2b$10$9gQemT8CRy42ISWJcgZZyOOdI8G4wxN9P3aoG5W6ZO5BW.EA0PcB.	Anjali Gupta	STUDENT	\N	2026-02-25 13:26:50.407	2026-02-25 13:26:50.407	t
std-user-8	std8@darshan.ac.in	$2b$10$9gQemT8CRy42ISWJcgZZyOOdI8G4wxN9P3aoG5W6ZO5BW.EA0PcB.	Manish Varma	STUDENT	\N	2026-02-25 13:26:50.411	2026-02-25 13:26:50.411	t
std-user-9	std9@darshan.ac.in	$2b$10$9gQemT8CRy42ISWJcgZZyOOdI8G4wxN9P3aoG5W6ZO5BW.EA0PcB.	Deepak Chawla	STUDENT	\N	2026-02-25 13:26:50.416	2026-02-25 13:26:50.416	t
std-user-10	std10@darshan.ac.in	$2b$10$9gQemT8CRy42ISWJcgZZyOOdI8G4wxN9P3aoG5W6ZO5BW.EA0PcB.	Ritu Singhal	STUDENT	\N	2026-02-25 13:26:50.421	2026-02-25 13:26:50.421	t
std-user-11	std11@darshan.ac.in	$2b$10$9gQemT8CRy42ISWJcgZZyOOdI8G4wxN9P3aoG5W6ZO5BW.EA0PcB.	Vikram Rathod	STUDENT	\N	2026-02-25 13:26:50.426	2026-02-25 13:26:50.426	t
std-user-12	std12@darshan.ac.in	$2b$10$9gQemT8CRy42ISWJcgZZyOOdI8G4wxN9P3aoG5W6ZO5BW.EA0PcB.	Neha Deshmukh	STUDENT	\N	2026-02-25 13:26:50.434	2026-02-25 13:26:50.434	t
fac-user-2	fac2@darshan.ac.in	$2b$10$9gQemT8CRy42ISWJcgZZyOOdI8G4wxN9P3aoG5W6ZO5BW.EA0PcB.	Prof. Alpesh Vaghasiya	FACULTY	\N	2026-02-25 13:26:50.335	2026-03-11 13:16:30.674	t
\.


--
-- Name: AcademicYear AcademicYear_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."AcademicYear"
    ADD CONSTRAINT "AcademicYear_name_key" UNIQUE (name);


--
-- Name: AcademicYear AcademicYear_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."AcademicYear"
    ADD CONSTRAINT "AcademicYear_pkey" PRIMARY KEY (id);


--
-- Name: AcademicYear AcademicYear_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."AcademicYear"
    ADD CONSTRAINT "AcademicYear_slug_key" UNIQUE (slug);


--
-- Name: ActivityLog ActivityLog_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ActivityLog"
    ADD CONSTRAINT "ActivityLog_pkey" PRIMARY KEY (id);


--
-- Name: Department Department_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Department"
    ADD CONSTRAINT "Department_code_key" UNIQUE (code);


--
-- Name: Department Department_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Department"
    ADD CONSTRAINT "Department_name_key" UNIQUE (name);


--
-- Name: Department Department_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Department"
    ADD CONSTRAINT "Department_pkey" PRIMARY KEY (id);


--
-- Name: Document Document_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Document"
    ADD CONSTRAINT "Document_pkey" PRIMARY KEY (id);


--
-- Name: FacultyProfile FacultyProfile_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."FacultyProfile"
    ADD CONSTRAINT "FacultyProfile_pkey" PRIMARY KEY (id);


--
-- Name: FacultyProfile FacultyProfile_userId_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."FacultyProfile"
    ADD CONSTRAINT "FacultyProfile_userId_key" UNIQUE ("userId");


--
-- Name: Grade Grade_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Grade"
    ADD CONSTRAINT "Grade_pkey" PRIMARY KEY (id);


--
-- Name: MeetingAttendance MeetingAttendance_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."MeetingAttendance"
    ADD CONSTRAINT "MeetingAttendance_pkey" PRIMARY KEY (id);


--
-- Name: Meeting Meeting_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Meeting"
    ADD CONSTRAINT "Meeting_pkey" PRIMARY KEY (id);


--
-- Name: Message Message_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Message"
    ADD CONSTRAINT "Message_pkey" PRIMARY KEY (id);


--
-- Name: Milestone Milestone_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Milestone"
    ADD CONSTRAINT "Milestone_pkey" PRIMARY KEY (id);


--
-- Name: Notification Notification_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Notification"
    ADD CONSTRAINT "Notification_pkey" PRIMARY KEY (id);


--
-- Name: ProjectGroup ProjectGroup_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ProjectGroup"
    ADD CONSTRAINT "ProjectGroup_pkey" PRIMARY KEY (id);


--
-- Name: ProjectType ProjectType_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ProjectType"
    ADD CONSTRAINT "ProjectType_name_key" UNIQUE (name);


--
-- Name: ProjectType ProjectType_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ProjectType"
    ADD CONSTRAINT "ProjectType_pkey" PRIMARY KEY (id);


--
-- Name: Project Project_groupId_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Project"
    ADD CONSTRAINT "Project_groupId_key" UNIQUE ("groupId");


--
-- Name: Project Project_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Project"
    ADD CONSTRAINT "Project_pkey" PRIMARY KEY (id);


--
-- Name: StudentProfile StudentProfile_idNumber_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."StudentProfile"
    ADD CONSTRAINT "StudentProfile_idNumber_key" UNIQUE ("idNumber");


--
-- Name: StudentProfile StudentProfile_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."StudentProfile"
    ADD CONSTRAINT "StudentProfile_pkey" PRIMARY KEY (id);


--
-- Name: StudentProfile StudentProfile_userId_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."StudentProfile"
    ADD CONSTRAINT "StudentProfile_userId_key" UNIQUE ("userId");


--
-- Name: StudentTask StudentTask_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."StudentTask"
    ADD CONSTRAINT "StudentTask_pkey" PRIMARY KEY (id);


--
-- Name: User User_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_email_key" UNIQUE (email);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: ActivityLog ActivityLog_projectId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ActivityLog"
    ADD CONSTRAINT "ActivityLog_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES public."Project"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ActivityLog ActivityLog_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ActivityLog"
    ADD CONSTRAINT "ActivityLog_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Document Document_projectId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Document"
    ADD CONSTRAINT "Document_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES public."Project"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: FacultyProfile FacultyProfile_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."FacultyProfile"
    ADD CONSTRAINT "FacultyProfile_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Grade Grade_projectId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Grade"
    ADD CONSTRAINT "Grade_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES public."Project"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Grade Grade_studentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Grade"
    ADD CONSTRAINT "Grade_studentId_fkey" FOREIGN KEY ("studentId") REFERENCES public."StudentProfile"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: MeetingAttendance MeetingAttendance_meetingId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."MeetingAttendance"
    ADD CONSTRAINT "MeetingAttendance_meetingId_fkey" FOREIGN KEY ("meetingId") REFERENCES public."Meeting"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: MeetingAttendance MeetingAttendance_studentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."MeetingAttendance"
    ADD CONSTRAINT "MeetingAttendance_studentId_fkey" FOREIGN KEY ("studentId") REFERENCES public."StudentProfile"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Meeting Meeting_projectId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Meeting"
    ADD CONSTRAINT "Meeting_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES public."Project"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Message Message_senderId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Message"
    ADD CONSTRAINT "Message_senderId_fkey" FOREIGN KEY ("senderId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Milestone Milestone_projectId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Milestone"
    ADD CONSTRAINT "Milestone_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES public."Project"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Notification Notification_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Notification"
    ADD CONSTRAINT "Notification_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Project Project_groupId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Project"
    ADD CONSTRAINT "Project_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES public."ProjectGroup"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Project Project_guideId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Project"
    ADD CONSTRAINT "Project_guideId_fkey" FOREIGN KEY ("guideId") REFERENCES public."FacultyProfile"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Project Project_typeId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Project"
    ADD CONSTRAINT "Project_typeId_fkey" FOREIGN KEY ("typeId") REFERENCES public."ProjectType"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: StudentProfile StudentProfile_groupId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."StudentProfile"
    ADD CONSTRAINT "StudentProfile_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES public."ProjectGroup"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: StudentProfile StudentProfile_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."StudentProfile"
    ADD CONSTRAINT "StudentProfile_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: StudentTask StudentTask_studentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."StudentTask"
    ADD CONSTRAINT "StudentTask_studentId_fkey" FOREIGN KEY ("studentId") REFERENCES public."StudentProfile"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict DLknUCS5dtvLDHq2Q4klk3IdOK0vNM9IFd1CnfHMRB42bklqaqPPib0g9tOwwxv

