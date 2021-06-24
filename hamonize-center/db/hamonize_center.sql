-- public.tbl_act_backup_recovery_log definition

-- Drop table

-- DROP TABLE public.tbl_act_backup_recovery_log;

CREATE TABLE public.tbl_act_backup_recovery_log (
	seq bigserial NOT NULL,
	org_seq int8 NULL,
	uuid varchar(200) NULL,
	hostname varchar(100) NULL,
	datetime varchar(100) NULL,
	status varchar(100) NULL,
	"result" varchar(100) NULL,
	ins_date timestamp NULL,
	CONSTRAINT tbl_act_backup_recovery_log_pkey PRIMARY KEY (seq)
);

-- Permissions

ALTER TABLE public.tbl_act_backup_recovery_log OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_act_backup_recovery_log TO ivs;


-- public.tbl_act_device_log definition

-- Drop table

-- DROP TABLE public.tbl_act_device_log;

CREATE TABLE public.tbl_act_device_log (
	seq bigserial NOT NULL,
	org_seq int8 NULL,
	uuid varchar(200) NULL,
	hostname varchar(100) NULL,
	status varchar(10) NULL,
	product varchar(200) NULL,
	vendorcode varchar(100) NULL,
	productcode varchar(100) NULL,
	ins_date timestamp NULL,
	CONSTRAINT tbl_act_device_log_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_act_device_log IS '디바이스 허용 배포 결과';

-- Permissions

ALTER TABLE public.tbl_act_device_log OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_act_device_log TO ivs;


-- public.tbl_act_firewall_log definition

-- Drop table

-- DROP TABLE public.tbl_act_firewall_log;

CREATE TABLE public.tbl_act_firewall_log (
	seq bigserial NOT NULL,
	org_seq int8 NULL,
	uuid varchar(200) NULL,
	hostname varchar(100) NULL,
	datetime varchar(100) NULL,
	status varchar(10) NULL,
	retport varchar(300) NULL,
	status_yn varchar(10) NULL,
	ins_date timestamp NULL,
	CONSTRAINT tbl_act_firewall_log_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_act_firewall_log IS '방화벽 정책 배포 결과';

-- Permissions

ALTER TABLE public.tbl_act_firewall_log OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_act_firewall_log TO ivs;


-- public.tbl_act_nxss_log definition

-- Drop table

-- DROP TABLE public.tbl_act_nxss_log;

CREATE TABLE public.tbl_act_nxss_log (
	seq bigserial NOT NULL,
	org_seq int8 NULL,
	uuid varchar(200) NULL,
	hostname varchar(100) NULL,
	file_gubun varchar(100) NULL,
	filedate varchar(100) NULL,
	ins_date timestamp NULL,
	CONSTRAINT tbl_act_nxss_log_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_act_nxss_log IS '유해사이트 차단 배포 결과';

-- Permissions

ALTER TABLE public.tbl_act_nxss_log OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_act_nxss_log TO ivs;


-- public.tbl_act_progrm_log definition

-- Drop table

-- DROP TABLE public.tbl_act_progrm_log;

CREATE TABLE public.tbl_act_progrm_log (
	seq bigserial NOT NULL,
	org_seq int8 NULL,
	uuid varchar(200) NULL,
	datetime varchar(100) NULL,
	hostname varchar(100) NULL,
	status_yn varchar(100) NULL,
	status varchar(100) NULL,
	progrmname varchar(200) NULL,
	ins_date timestamp NULL,
	CONSTRAINT tbl_act_progrm_log_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_act_progrm_log IS '프로그램 업데이트 배포 결과';

-- Permissions

ALTER TABLE public.tbl_act_progrm_log OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_act_progrm_log TO ivs;


-- public.tbl_admin_login_history definition

-- Drop table

-- DROP TABLE public.tbl_admin_login_history;

CREATE TABLE public.tbl_admin_login_history (
	seq bigserial NOT NULL,
	user_id varchar(50) NULL,
	conn_ip varchar(30) NULL,
	login_date timestamp NULL,
	logout_date timestamp NULL,
	time_spent time NULL, -- 머문 시간
	CONSTRAINT tbl_admin_login_history_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_admin_login_history IS '관리자 로그인 로그';

-- Column comments

COMMENT ON COLUMN public.tbl_admin_login_history.time_spent IS '머문 시간';

-- Permissions

ALTER TABLE public.tbl_admin_login_history OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_admin_login_history TO ivs;


-- public.tbl_admin_user definition

-- Drop table

-- DROP TABLE public.tbl_admin_user;

CREATE TABLE public.tbl_admin_user (
	user_id varchar(50) NOT NULL,
	user_name varchar(50) NOT NULL,
	pass_wd varchar(300) NOT NULL,
	dept_name varchar(50) NULL,
	ins_date timestamp NULL,
	upd_date timestamp NULL,
	gubun bpchar(1) NOT NULL,
	CONSTRAINT tbl_admin_user_pkey PRIMARY KEY (user_id)
);
COMMENT ON TABLE public.tbl_admin_user IS '관리자 정보';

-- Permissions

ALTER TABLE public.tbl_admin_user OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_admin_user TO ivs;


-- public.tbl_agent_job definition

-- Drop table

-- DROP TABLE public.tbl_agent_job;

CREATE TABLE public.tbl_agent_job (
	seq bigserial NOT NULL,
	ins_date timestamp NULL,
	aj_return_val varchar NULL,
	aj_table_gubun varchar(50) NULL,
	ppa_seq varchar(500) NULL,
	aj_ppa_org_seq varchar(100) NULL,
	aj_table_seq int8 NULL,
	CONSTRAINT tbl_agent_job_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_agent_job IS 'agent 정책파일';

-- Permissions

ALTER TABLE public.tbl_agent_job OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_agent_job TO ivs;


-- public.tbl_answer definition

-- Drop table

-- DROP TABLE public.tbl_answer;

CREATE TABLE public.tbl_answer (
	seq bigserial NOT NULL,
	tcng_seq int8 NULL,
	"content" text NULL,
	ins_date timestamp NULL DEFAULT now(),
	upd_date timestamp NULL DEFAULT now(),
	admin_id varchar(100) NULL,
	admin_name varchar(100) NULL,
	CONSTRAINT tbl_answer_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_answer IS '댓글';

-- Permissions

ALTER TABLE public.tbl_answer OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_answer TO ivs;


-- public.tbl_backup_agent_job definition

-- Drop table

-- DROP TABLE public.tbl_backup_agent_job;

CREATE TABLE public.tbl_backup_agent_job (
	seq bigserial NOT NULL,
	bac_seq int8 NULL,
	org_seq int8 NULL,
	uuid varchar(100) NULL,
	pcm_name varchar(100) NULL,
	ins_date timestamp NULL,
	status varchar(10) NULL,
	CONSTRAINT tbl_backup_agent_job_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_backup_agent_job IS '에이전트 백업';

-- Permissions

ALTER TABLE public.tbl_backup_agent_job OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_backup_agent_job TO ivs;


-- public.tbl_backup_applc definition

-- Drop table

-- DROP TABLE public.tbl_backup_applc;

CREATE TABLE public.tbl_backup_applc (
	seq bigserial NOT NULL,
	org_seq int8 NULL,
	bac_cycle_option varchar(50) NULL,
	bac_cycle_time varchar(50) NULL,
	bac_gubun varchar(10) NULL,
	CONSTRAINT tbl_backup_applc_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_backup_applc IS '백업주기 설정';

-- Permissions

ALTER TABLE public.tbl_backup_applc OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_backup_applc TO ivs;


-- public.tbl_backup_applc_history definition

-- Drop table

-- DROP TABLE public.tbl_backup_applc_history;

CREATE TABLE public.tbl_backup_applc_history (
	seq bigserial NOT NULL,
	bac_seq int8 NULL,
	org_seq int8 NULL,
	bac_cycle_option varchar(100) NULL,
	bac_cycle_time varchar(100) NULL,
	bac_gubun varchar(10) NULL,
	ins_date timestamp NULL,
	CONSTRAINT tbl_backup_applc_history_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_backup_applc_history IS '백업주기 히스토리';

-- Permissions

ALTER TABLE public.tbl_backup_applc_history OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_backup_applc_history TO ivs;


-- public.tbl_backup_recovery_mngr definition

-- Drop table

-- DROP TABLE public.tbl_backup_recovery_mngr;

CREATE TABLE public.tbl_backup_recovery_mngr (
	seq bigserial NOT NULL,
	org_seq int8 NULL,
	br_backup_path varchar(100) NULL,
	br_backup_iso_dt timestamp NULL DEFAULT now(),
	br_backup_gubun varchar(10) NULL,
	br_backup_name varchar(100) NULL,
	object_seq int8 NULL,
	CONSTRAINT tbl_backup_recovery_mngr_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_backup_recovery_mngr IS '백업 이미지 정보 테이블';

-- Permissions

ALTER TABLE public.tbl_backup_recovery_mngr OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_backup_recovery_mngr TO ivs;


-- public.tbl_board_files definition

-- Drop table

-- DROP TABLE public.tbl_board_files;

CREATE TABLE public.tbl_board_files (
	seq bigserial NOT NULL,
	board_seq int8 NOT NULL,
	filerealname varchar(200) NULL,
	filemakename varchar(200) NULL,
	filapath varchar(200) NULL,
	filesize varchar(200) NULL,
	ins_date timestamp NULL,
	upd_date timestamp NULL,
	CONSTRAINT tbl_board_files_pkey PRIMARY KEY (seq)
);

-- Permissions

ALTER TABLE public.tbl_board_files OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_board_files TO ivs;


-- public.tbl_comm_code definition

-- Drop table

-- DROP TABLE public.tbl_comm_code;

CREATE TABLE public.tbl_comm_code (
	seq serial NOT NULL,
	attr_code varchar(50) NULL,
	attr_name varchar(50) NULL,
	attr_value_code varchar(50) NULL,
	attr_value_name varchar(100) NULL,
	CONSTRAINT tbl_comm_code_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_comm_code IS '공통코드관리';

-- Permissions

ALTER TABLE public.tbl_comm_code OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_comm_code TO ivs;


-- public.tbl_device_agent_job definition

-- Drop table

-- DROP TABLE public.tbl_device_agent_job;

CREATE TABLE public.tbl_device_agent_job (
	seq serial NOT NULL,
	sm_seq int8 NULL,
	org_seq int8 NULL,
	dvc_seq int8 NULL,
	pcm_uuid varchar(100) NULL,
	pcm_name varchar(100) NULL,
	status varchar(30) NULL,
	insert_dt timestamp NULL,
	CONSTRAINT tbl_device_agent_job_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_device_agent_job IS '에이전트 디바이스 비교 테이블';

-- Permissions

ALTER TABLE public.tbl_device_agent_job OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_device_agent_job TO ivs;


-- public.tbl_device_applc definition

-- Drop table

-- DROP TABLE public.tbl_device_applc;

CREATE TABLE public.tbl_device_applc (
	seq serial NOT NULL,
	org_seq int8 NULL,
	ppm_seq varchar(100) NULL, -- 디바이스 번호
	CONSTRAINT tbl_device_applc_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_device_applc IS '디바이스 정책 현황';

-- Column comments

COMMENT ON COLUMN public.tbl_device_applc.ppm_seq IS '디바이스 번호';

-- Permissions

ALTER TABLE public.tbl_device_applc OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_device_applc TO ivs;


-- public.tbl_device_applc_history definition

-- Drop table

-- DROP TABLE public.tbl_device_applc_history;

CREATE TABLE public.tbl_device_applc_history (
	seq bigserial NOT NULL,
	org_seq int8 NULL,
	ppm_seq varchar(100) NULL,
	dvc_seq int8 NULL,
	insert_dt timestamp NULL,
	CONSTRAINT tbl_device_applc_history_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_device_applc_history IS '디바이스 정책 로그';

-- Permissions

ALTER TABLE public.tbl_device_applc_history OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_device_applc_history TO ivs;


-- public.tbl_files definition

-- Drop table

-- DROP TABLE public.tbl_files;

CREATE TABLE public.tbl_files (
	seq serial NOT NULL,
	org_seq int8 NULL,
	filerealname varchar(100) NULL,
	filemakename varchar(100) NULL,
	filepath varchar(100) NULL,
	filesize varchar(100) NULL,
	ins_date timestamp NULL,
	upd_date timestamp NULL,
	CONSTRAINT tbl_files_pkey PRIMARY KEY (seq)
);

-- Permissions

ALTER TABLE public.tbl_files OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_files TO ivs;


-- public.tbl_frwl_agent_job definition

-- Drop table

-- DROP TABLE public.tbl_frwl_agent_job;

CREATE TABLE public.tbl_frwl_agent_job (
	seq serial NOT NULL,
	sm_seq int8 NULL,
	org_seq int8 NULL,
	fa_seq int8 NULL,
	pcm_uuid varchar(100) NULL, -- PC 관리번호
	pcm_name varchar(100) NULL,
	status varchar(50) NULL,
	insert_dt timestamp NULL,
	CONSTRAINT tbl_frwl_agent_job_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_frwl_agent_job IS '방화벽 에이전트 작업';

-- Column comments

COMMENT ON COLUMN public.tbl_frwl_agent_job.pcm_uuid IS 'PC 관리번호';

-- Permissions

ALTER TABLE public.tbl_frwl_agent_job OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_frwl_agent_job TO ivs;


-- public.tbl_frwl_applc definition

-- Drop table

-- DROP TABLE public.tbl_frwl_applc;

CREATE TABLE public.tbl_frwl_applc (
	org_seq int4 NULL, -- 부서 관리번호
	ppm_seq varchar(100) NULL, -- 방화벽 번호
	seq bigserial NOT NULL -- 시리얼 번호
);
COMMENT ON TABLE public.tbl_frwl_applc IS '방화벽 정책 현황';

-- Column comments

COMMENT ON COLUMN public.tbl_frwl_applc.org_seq IS '부서 관리번호';
COMMENT ON COLUMN public.tbl_frwl_applc.ppm_seq IS '방화벽 번호';
COMMENT ON COLUMN public.tbl_frwl_applc.seq IS '시리얼 번호';

-- Permissions

ALTER TABLE public.tbl_frwl_applc OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_frwl_applc TO ivs;


-- public.tbl_frwl_applc_history definition

-- Drop table

-- DROP TABLE public.tbl_frwl_applc_history;

CREATE TABLE public.tbl_frwl_applc_history (
	seq bigserial NOT NULL,
	org_seq int8 NULL,
	insert_dt timestamp NULL,
	frwl_seq int8 NULL,
	ppm_seq varchar(100) NULL,
	CONSTRAINT tbl_frwl_applc_history_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_frwl_applc_history IS '방화벽 정책 적용 로그';

-- Permissions

ALTER TABLE public.tbl_frwl_applc_history OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_frwl_applc_history TO ivs;


-- public.tbl_hamonize_version_chk definition

-- Drop table

-- DROP TABLE public.tbl_hamonize_version_chk;

CREATE TABLE public.tbl_hamonize_version_chk (
	debseq bigserial NOT NULL,
	debname varchar(100) NULL,
	debversion varchar(20) NOT NULL,
	debstatus varchar(20) NULL,
	pcuuid varchar(100) NULL,
	insert_dt timestamptz NULL,
	last_dt timestamptz(0) NULL,
	CONSTRAINT tbl_hamonize_version_chk_pkey PRIMARY KEY (debseq)
);
COMMENT ON TABLE public.tbl_hamonize_version_chk IS '하모나이즈 버전 체크';

-- Permissions

ALTER TABLE public.tbl_hamonize_version_chk OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_hamonize_version_chk TO ivs;


-- public.tbl_inet_log definition

-- Drop table

-- DROP TABLE public.tbl_inet_log;

CREATE TABLE public.tbl_inet_log (
	inet_seq bigserial NOT NULL, -- 고유번호
	user_id varchar(50) NULL, -- 사용자 아이디
	pc_ip varchar(50) NULL, -- 사용자 pc ip
	cnnc_url varchar(300) NULL, -- 인터넷 사용 url
	pc_uuid varchar(100) NULL, -- pc uuid
	hostname varchar(50) NULL, -- PC 호스트명
	state varchar(10) NULL, -- start:브라우저시작,stop:브라우저 종료,connect:인터넷접속,illegal:유해사이트접속
	reg_dt timestamp NULL, -- state별 시간
	insert_dt timestamp NULL, -- 사용일
	CONSTRAINT tbl_inet_log_pkey PRIMARY KEY (inet_seq)
);
CREATE INDEX tbl_inet_log_reg_dt_index ON public.tbl_inet_log USING btree (reg_dt);
COMMENT ON TABLE public.tbl_inet_log IS '인터넷 사용로그';

-- Column comments

COMMENT ON COLUMN public.tbl_inet_log.inet_seq IS '고유번호';
COMMENT ON COLUMN public.tbl_inet_log.user_id IS '사용자 아이디';
COMMENT ON COLUMN public.tbl_inet_log.pc_ip IS '사용자 pc ip';
COMMENT ON COLUMN public.tbl_inet_log.cnnc_url IS '인터넷 사용 url';
COMMENT ON COLUMN public.tbl_inet_log.pc_uuid IS 'pc uuid';
COMMENT ON COLUMN public.tbl_inet_log.hostname IS 'PC 호스트명';
COMMENT ON COLUMN public.tbl_inet_log.state IS 'start:브라우저시작,stop:브라우저 종료,connect:인터넷접속,illegal:유해사이트접속';
COMMENT ON COLUMN public.tbl_inet_log.reg_dt IS 'state별 시간';
COMMENT ON COLUMN public.tbl_inet_log.insert_dt IS '사용일';

-- Permissions

ALTER TABLE public.tbl_inet_log OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_inet_log TO ivs;


-- public.tbl_ip definition

-- Drop table

-- DROP TABLE public.tbl_ip;

CREATE TABLE public.tbl_ip (
	seq serial NOT NULL,
	ipaddress varchar(30) NULL,
	gubun varchar(2) NULL,
	info varchar(50) NULL,
	ins_date date NULL,
	upd_date date NULL,
	macaddress varchar(100) NULL,
	CONSTRAINT tbl_ip_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_ip IS '클라우드컴퓨팅 통합관제시스템 접근 허용 IP';

-- Permissions

ALTER TABLE public.tbl_ip OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_ip TO ivs;


-- public.tbl_loginout definition

-- Drop table

-- DROP TABLE public.tbl_loginout;

CREATE TABLE public.tbl_loginout (
	seq bigserial NOT NULL, -- 시리얼 번호
	user_seq int8 NULL, -- 사용자 번호
	login_dt timestamptz NULL DEFAULT now(), -- 로그인 시간
	logout_dt timestamptz NULL, -- 로그아웃 시간
	uuid varchar(100) NULL, -- PC 관리번호
	CONSTRAINT tbl_loginout_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_loginout IS '로그인/아웃 로그';

-- Column comments

COMMENT ON COLUMN public.tbl_loginout.seq IS '시리얼 번호';
COMMENT ON COLUMN public.tbl_loginout.user_seq IS '사용자 번호';
COMMENT ON COLUMN public.tbl_loginout.login_dt IS '로그인 시간';
COMMENT ON COLUMN public.tbl_loginout.logout_dt IS '로그아웃 시간';
COMMENT ON COLUMN public.tbl_loginout.uuid IS 'PC 관리번호';

-- Permissions

ALTER TABLE public.tbl_loginout OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_loginout TO ivs;


-- public.tbl_manager definition

-- Drop table

-- DROP TABLE public.tbl_manager;

CREATE TABLE public.tbl_manager (
	seq int8 NOT NULL, -- 시리얼 번호
	user_id varchar(30) NULL, -- 부서 관리자 아이디
	pass_wd varchar(300) NULL, -- 비밀번호
	user_name varchar(50) NULL, -- 부서 관리자 이름
	insert_dt timestamp NULL, -- 등록일
	update_dt timestamp NULL, -- 수정일
	"rank" varchar(30) NULL, -- 직급
	tel_num varchar(20) NULL, -- 유선 전화번호
	phone_num varchar(30) NULL, -- 핸드폰번호
	arr_org_seq varchar(30) NULL, -- 부서방 관리번호
	manager_yn varchar(3) NULL, -- 상위 부문 관리자 여부
	general_yn varchar(2) NULL, -- 최상위 부문 관리자 여부
	CONSTRAINT tbl_manager_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_manager IS '부서 관리자 정보';

-- Column comments

COMMENT ON COLUMN public.tbl_manager.seq IS '시리얼 번호';
COMMENT ON COLUMN public.tbl_manager.user_id IS '부서 관리자 아이디';
COMMENT ON COLUMN public.tbl_manager.pass_wd IS '비밀번호';
COMMENT ON COLUMN public.tbl_manager.user_name IS '부서 관리자 이름';
COMMENT ON COLUMN public.tbl_manager.insert_dt IS '등록일';
COMMENT ON COLUMN public.tbl_manager.update_dt IS '수정일';
COMMENT ON COLUMN public.tbl_manager."rank" IS '직급';
COMMENT ON COLUMN public.tbl_manager.tel_num IS '유선 전화번호';
COMMENT ON COLUMN public.tbl_manager.phone_num IS '핸드폰번호';
COMMENT ON COLUMN public.tbl_manager.arr_org_seq IS '부서방 관리번호';
COMMENT ON COLUMN public.tbl_manager.manager_yn IS '상위 부문 관리자 여부';
COMMENT ON COLUMN public.tbl_manager.general_yn IS '최상위 부문 관리자 여부';

-- Permissions

ALTER TABLE public.tbl_manager OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_manager TO ivs;


-- public.tbl_manager_orgseq definition

-- Drop table

-- DROP TABLE public.tbl_manager_orgseq;

CREATE TABLE public.tbl_manager_orgseq (
	seq int8 NULL,
	user_id varchar(100) NULL,
	org_seq int4 NULL
);
COMMENT ON TABLE public.tbl_manager_orgseq IS '(미사용)';

-- Permissions

ALTER TABLE public.tbl_manager_orgseq OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_manager_orgseq TO ivs;


-- public.tbl_notice definition

-- Drop table

-- DROP TABLE public.tbl_notice;

CREATE TABLE public.tbl_notice (
	seq serial NOT NULL,
	title varchar(500) NULL,
	contents text NULL,
	writer_id varchar NULL,
	"group" varchar NULL,
	ins_date date NULL,
	upd_date date NULL,
	"rank" varchar(30) NULL,
	org_seq int8 NULL,
	orguppercode int4 NULL,
	hit int8 NULL,
	CONSTRAINT tbl_notice_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_notice IS '공지사항';

-- Permissions

ALTER TABLE public.tbl_notice OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_notice TO ivs;


-- public.tbl_object definition

-- Drop table

-- DROP TABLE public.tbl_object;

CREATE TABLE public.tbl_object (
	seq serial NOT NULL,
	status varchar(300) NULL,
	cpu varchar(300) NULL,
	memory varchar(300) NULL,
	disk varchar(300) NULL,
	macaddress varchar(300) NULL,
	ipaddress varchar(300) NULL,
	ins_date timestamp NULL,
	upd_date timestamp NULL,
	hostname varchar(300) NULL,
	org_seq int8 NULL,
	disk_id varchar(100) NULL,
	cpu_id varchar(100) NULL,
	uuid varchar(100) NULL,
	"change" varchar(2) NULL,
	vpnip varchar(20) NULL,
	sn varchar(100) NULL,
	os varchar(100) NULL,
	public_ip varchar(20) NULL,
	"type" varchar(20) NOT NULL,
	CONSTRAINT tbl_object_pkey PRIMARY KEY (seq)
);

-- Permissions

ALTER TABLE public.tbl_object OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_object TO ivs;


-- public.tbl_org definition

-- Drop table

-- DROP TABLE public.tbl_org;

CREATE TABLE public.tbl_org (
	seq serial NOT NULL,
	p_seq int8 NULL,
	org_nm varchar(100) NULL,
	org_ordr int4 NULL,
	writer_id varchar(30) NULL,
	ins_date date NULL,
	writer_ip varchar(30) NULL,
	update_writer_id varchar(30) NULL,
	upd_date date NULL,
	update_writer_ip varchar(30) NULL,
	"section" varchar(100) NULL,
	p_org_nm varchar(100) NULL,
	sido varchar(100) NULL,
	gugun varchar(100) NULL,
	org_num varchar(100) NULL,
	xpoint varchar(100) NULL,
	ypoint varchar(100) NULL,
	all_org_nm varchar(300) NULL, -- 전체경로
	CONSTRAINT tbl_org_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_org IS '조직 정보';

-- Column comments

COMMENT ON COLUMN public.tbl_org.all_org_nm IS '전체경로';

-- Permissions

ALTER TABLE public.tbl_org OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_org TO ivs;


-- public.tbl_pc_amt_json definition

-- Drop table

-- DROP TABLE public.tbl_pc_amt_json;

CREATE TABLE public.tbl_pc_amt_json (
	seq int8 NOT NULL DEFAULT nextval('tbl_pc_amt_json_seq'::regclass),
	pc_status varchar(300) NULL,
	pc_cpu varchar(300) NULL,
	pc_memory varchar(300) NULL,
	pc_disk varchar(300) NULL,
	pc_macaddress varchar(300) NULL,
	pc_ip varchar(300) NULL,
	first_date date NULL,
	last_date date NULL,
	pc_hostname varchar(300) NULL,
	pc_guid varchar(300) NULL,
	org_seq int4 NULL,
	pc_disk_id varchar(100) NULL,
	pc_cpu_id varchar(100) NULL,
	pc_uuid varchar(100) NULL,
	pc_change varchar(2) NULL,
	pc_vpnip varchar(20) NULL,
	pc_os varchar(10) NULL,
	pc_sn varchar(50) NULL,
	CONSTRAINT tbl_pc_amt_json_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_pc_amt_json IS '(미사용)';

-- Permissions

ALTER TABLE public.tbl_pc_amt_json OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_pc_amt_json TO ivs;


-- public.tbl_pc_block definition

-- Drop table

-- DROP TABLE public.tbl_pc_block;

CREATE TABLE public.tbl_pc_block (
	seq int8 NULL,
	org_seq int4 NULL,
	block_dt timestamp NULL,
	unblock_dt timestamp NULL,
	status varchar(20) NULL,
	pc_ip varchar(50) NULL,
	insert_dt timestamp NULL
);
COMMENT ON TABLE public.tbl_pc_block IS '(미사용)';

-- Permissions

ALTER TABLE public.tbl_pc_block OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_pc_block TO ivs;


-- public.tbl_pc_change_info definition

-- Drop table

-- DROP TABLE public.tbl_pc_change_info;

CREATE TABLE public.tbl_pc_change_info (
	seq bigserial NOT NULL, -- 시리얼 번호
	pc_cpu varchar(100) NULL, -- cpu
	pc_memory varchar(100) NULL, -- memory
	pc_disk varchar(100) NULL, -- disk
	pc_macaddress varchar(100) NULL, -- macaddress
	pc_ip varchar(100) NULL, -- ip
	pc_hostname varchar(100) NULL, -- PC 호스트명
	pc_disk_id varchar(100) NULL, -- disk_id
	pc_cpu_id varchar(100) NULL, -- cpu_id
	pc_uuid varchar(100) NULL, -- PC 관리번호
	org_seq int8 NULL, -- 부서 관리번호
	insert_dt timestamp NULL, -- 변경일
	pc_user varchar(50) NULL, -- 사용자 아이디
	CONSTRAINT tbl_pc_change_info_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_pc_change_info IS '부서 pc hw 상태 변경 기록';

-- Column comments

COMMENT ON COLUMN public.tbl_pc_change_info.seq IS '시리얼 번호';
COMMENT ON COLUMN public.tbl_pc_change_info.pc_cpu IS 'cpu';
COMMENT ON COLUMN public.tbl_pc_change_info.pc_memory IS 'memory';
COMMENT ON COLUMN public.tbl_pc_change_info.pc_disk IS 'disk';
COMMENT ON COLUMN public.tbl_pc_change_info.pc_macaddress IS 'macaddress';
COMMENT ON COLUMN public.tbl_pc_change_info.pc_ip IS 'ip';
COMMENT ON COLUMN public.tbl_pc_change_info.pc_hostname IS 'PC 호스트명';
COMMENT ON COLUMN public.tbl_pc_change_info.pc_disk_id IS 'disk_id';
COMMENT ON COLUMN public.tbl_pc_change_info.pc_cpu_id IS 'cpu_id';
COMMENT ON COLUMN public.tbl_pc_change_info.pc_uuid IS 'PC 관리번호';
COMMENT ON COLUMN public.tbl_pc_change_info.org_seq IS '부서 관리번호';
COMMENT ON COLUMN public.tbl_pc_change_info.insert_dt IS '변경일';
COMMENT ON COLUMN public.tbl_pc_change_info.pc_user IS '사용자 아이디';

-- Permissions

ALTER TABLE public.tbl_pc_change_info OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_pc_change_info TO ivs;


-- public.tbl_pc_influxdata definition

-- Drop table

-- DROP TABLE public.tbl_pc_influxdata;

CREATE TABLE public.tbl_pc_influxdata (
	pc_uuid varchar(100) NULL, -- PC 관리번호
	insert_dt timestamp NULL, -- 사용일
	pc_status varchar(20) NULL -- 사용여부
);
COMMENT ON TABLE public.tbl_pc_influxdata IS '사용중인 pc 현황';

-- Column comments

COMMENT ON COLUMN public.tbl_pc_influxdata.pc_uuid IS 'PC 관리번호';
COMMENT ON COLUMN public.tbl_pc_influxdata.insert_dt IS '사용일';
COMMENT ON COLUMN public.tbl_pc_influxdata.pc_status IS '사용여부';

-- Permissions

ALTER TABLE public.tbl_pc_influxdata OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_pc_influxdata TO ivs;


-- public.tbl_pc_mangr definition

-- Drop table

-- DROP TABLE public.tbl_pc_mangr;

CREATE TABLE public.tbl_pc_mangr (
	seq bigserial NOT NULL, -- 시리얼 번호
	pc_status varchar(300) NULL,
	pc_cpu varchar(300) NULL, -- cpu
	pc_memory varchar(300) NULL, -- memory
	pc_disk varchar(300) NULL, -- disk
	pc_macaddress varchar(300) NULL, -- macaddress
	pc_ip varchar(300) NULL, -- ip
	first_date timestamp NULL, -- 설치일
	last_date timestamp NULL, -- 수정일
	pc_hostname varchar(300) NULL, -- PC 호스트명
	pc_guid varchar(300) NULL,
	org_seq int4 NULL, -- 부서 관리번호
	pc_disk_id varchar(100) NULL, -- disk_id
	pc_cpu_id varchar(100) NULL, -- cpu_id
	pc_uuid varchar(100) NULL, -- PC 관리번호
	pc_change varchar(2) NULL, -- R:신청 P:허가 C:완료
	pc_vpnip varchar(20) NULL, -- vpn_ip
	pc_sn varchar(30) NULL, -- PC SN
	pc_os varchar(10) NULL, -- OS 구분
	CONSTRAINT tbl_pc_mangr_pkey PRIMARY KEY (seq)
);
CREATE INDEX tbl_pc_mangr_idx_uuid ON public.tbl_pc_mangr USING btree (pc_uuid);
COMMENT ON TABLE public.tbl_pc_mangr IS 'PC H/W 정보 관리';

-- Column comments

COMMENT ON COLUMN public.tbl_pc_mangr.seq IS '시리얼 번호';
COMMENT ON COLUMN public.tbl_pc_mangr.pc_cpu IS 'cpu';
COMMENT ON COLUMN public.tbl_pc_mangr.pc_memory IS 'memory';
COMMENT ON COLUMN public.tbl_pc_mangr.pc_disk IS 'disk';
COMMENT ON COLUMN public.tbl_pc_mangr.pc_macaddress IS 'macaddress';
COMMENT ON COLUMN public.tbl_pc_mangr.pc_ip IS 'ip';
COMMENT ON COLUMN public.tbl_pc_mangr.first_date IS '설치일';
COMMENT ON COLUMN public.tbl_pc_mangr.last_date IS '수정일';
COMMENT ON COLUMN public.tbl_pc_mangr.pc_hostname IS 'PC 호스트명';
COMMENT ON COLUMN public.tbl_pc_mangr.org_seq IS '부서 관리번호';
COMMENT ON COLUMN public.tbl_pc_mangr.pc_disk_id IS 'disk_id';
COMMENT ON COLUMN public.tbl_pc_mangr.pc_cpu_id IS 'cpu_id';
COMMENT ON COLUMN public.tbl_pc_mangr.pc_uuid IS 'PC 관리번호';
COMMENT ON COLUMN public.tbl_pc_mangr.pc_change IS 'R:신청 P:허가 C:완료';
COMMENT ON COLUMN public.tbl_pc_mangr.pc_vpnip IS 'vpn_ip';
COMMENT ON COLUMN public.tbl_pc_mangr.pc_sn IS 'PC SN';
COMMENT ON COLUMN public.tbl_pc_mangr.pc_os IS 'OS 구분';

-- Permissions

ALTER TABLE public.tbl_pc_mangr OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_pc_mangr TO ivs;


-- public.tbl_pc_mangr_history definition

-- Drop table

-- DROP TABLE public.tbl_pc_mangr_history;

CREATE TABLE public.tbl_pc_mangr_history (
	seq int8 NOT NULL DEFAULT nextval('tbl_pc_mangr_history_seq'::regclass), -- 시리얼번호
	pc_seq int8 NOT NULL, -- pc 번호
	pc_status varchar(300) NULL,
	pc_cpu varchar(300) NULL, -- cpu
	pc_memory varchar(300) NULL, -- memory
	pc_disk varchar(300) NULL, -- disk
	pc_macaddress varchar(300) NULL, -- macaddress
	pc_ip varchar(300) NULL, -- ip
	first_date date NULL, -- 설치일
	last_date date NULL, -- 수정일
	pc_hostname varchar(300) NULL, -- PC 호스트명
	pc_guid varchar(300) NULL,
	org_seq int4 NULL, -- 부서 관리번호
	pc_disk_id varchar(100) NULL, -- disk_id
	pc_cpu_id varchar(100) NULL, -- cpu_id
	pc_uuid varchar(100) NULL, -- PC 관리번호
	pc_change varchar(2) NULL, -- R:신청 P:허가 C:완료
	move_org_nm varchar(300) NULL, -- 이동할 부서명
	move_org_seq int4 NULL, -- 이동할부서관리번호
	pc_os varchar(10) NULL, -- os구분
	pc_sn varchar(50) NULL,
	CONSTRAINT tbl_pc_mangr_history_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_pc_mangr_history IS 'PC H/W 정보 로그관리';

-- Column comments

COMMENT ON COLUMN public.tbl_pc_mangr_history.seq IS '시리얼번호';
COMMENT ON COLUMN public.tbl_pc_mangr_history.pc_seq IS 'pc 번호';
COMMENT ON COLUMN public.tbl_pc_mangr_history.pc_cpu IS 'cpu';
COMMENT ON COLUMN public.tbl_pc_mangr_history.pc_memory IS 'memory';
COMMENT ON COLUMN public.tbl_pc_mangr_history.pc_disk IS 'disk';
COMMENT ON COLUMN public.tbl_pc_mangr_history.pc_macaddress IS 'macaddress';
COMMENT ON COLUMN public.tbl_pc_mangr_history.pc_ip IS 'ip';
COMMENT ON COLUMN public.tbl_pc_mangr_history.first_date IS '설치일';
COMMENT ON COLUMN public.tbl_pc_mangr_history.last_date IS '수정일';
COMMENT ON COLUMN public.tbl_pc_mangr_history.pc_hostname IS 'PC 호스트명';
COMMENT ON COLUMN public.tbl_pc_mangr_history.org_seq IS '부서 관리번호';
COMMENT ON COLUMN public.tbl_pc_mangr_history.pc_disk_id IS 'disk_id';
COMMENT ON COLUMN public.tbl_pc_mangr_history.pc_cpu_id IS 'cpu_id';
COMMENT ON COLUMN public.tbl_pc_mangr_history.pc_uuid IS 'PC 관리번호';
COMMENT ON COLUMN public.tbl_pc_mangr_history.pc_change IS 'R:신청 P:허가 C:완료';
COMMENT ON COLUMN public.tbl_pc_mangr_history.move_org_nm IS '이동할 부서명';
COMMENT ON COLUMN public.tbl_pc_mangr_history.move_org_seq IS '이동할부서관리번호';
COMMENT ON COLUMN public.tbl_pc_mangr_history.pc_os IS 'os구분';

-- Permissions

ALTER TABLE public.tbl_pc_mangr_history OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_pc_mangr_history TO ivs;


-- public.tbl_prcss_block_log definition

-- Drop table

-- DROP TABLE public.tbl_prcss_block_log;

CREATE TABLE public.tbl_prcss_block_log (
	seq serial NOT NULL,
	hostname varchar(200) NULL,
	prcssname varchar(200) NULL,
	ipaddress varchar(50) NULL,
	macaddress varchar(100) NULL,
	uuid varchar(200) NULL,
	org_seq int8 NULL,
	insert_dt timestamp NULL,
	user_id varchar(100) NULL,
	CONSTRAINT tbl_prcss_block_log_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_prcss_block_log IS '프로그램 차단 로그';

-- Permissions

ALTER TABLE public.tbl_prcss_block_log OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_prcss_block_log TO ivs;


-- public.tbl_program_mngr definition

-- Drop table

-- DROP TABLE public.tbl_program_mngr;

CREATE TABLE public.tbl_program_mngr (
	pcm_name varchar(500) NULL, -- 프로그램명
	pcm_status varchar(10) NULL,
	pcm_dc varchar(500) NULL, -- 프로그램설명
	pcm_seq bigserial NULL, -- 시리얼번호
	pcm_path varchar(100) NULL,
	insert_dt timestamp NULL -- 등록일
);
COMMENT ON TABLE public.tbl_program_mngr IS 'pc 프로그램 리스트 관리';

-- Column comments

COMMENT ON COLUMN public.tbl_program_mngr.pcm_name IS '프로그램명';
COMMENT ON COLUMN public.tbl_program_mngr.pcm_dc IS '프로그램설명';
COMMENT ON COLUMN public.tbl_program_mngr.pcm_seq IS '시리얼번호';
COMMENT ON COLUMN public.tbl_program_mngr.insert_dt IS '등록일';

-- Permissions

ALTER TABLE public.tbl_program_mngr OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_program_mngr TO ivs;


-- public.tbl_progrm_agent_job definition

-- Drop table

-- DROP TABLE public.tbl_progrm_agent_job;

CREATE TABLE public.tbl_progrm_agent_job (
	seq serial NOT NULL, -- 시리얼번호
	pcm_seq int8 NULL, -- 프로그램 번호
	org_seq int8 NULL, -- 부서관리번호
	pa_seq int8 NULL, -- 작업 번호
	pcm_uuid varchar(100) NULL, -- PC 관리번호
	pcm_name varchar(100) NULL, -- 프로그램명
	insert_dt timestamp NULL,
	status varchar(20) NULL,
	CONSTRAINT tbl_progrm_agent_job_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_progrm_agent_job IS '에이전트 현황';

-- Column comments

COMMENT ON COLUMN public.tbl_progrm_agent_job.seq IS '시리얼번호';
COMMENT ON COLUMN public.tbl_progrm_agent_job.pcm_seq IS '프로그램 번호';
COMMENT ON COLUMN public.tbl_progrm_agent_job.org_seq IS '부서관리번호';
COMMENT ON COLUMN public.tbl_progrm_agent_job.pa_seq IS '작업 번호';
COMMENT ON COLUMN public.tbl_progrm_agent_job.pcm_uuid IS 'PC 관리번호';
COMMENT ON COLUMN public.tbl_progrm_agent_job.pcm_name IS '프로그램명';

-- Permissions

ALTER TABLE public.tbl_progrm_agent_job OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_progrm_agent_job TO ivs;


-- public.tbl_progrm_applc definition

-- Drop table

-- DROP TABLE public.tbl_progrm_applc;

CREATE TABLE public.tbl_progrm_applc (
	seq serial NOT NULL,
	org_seq int8 NULL,
	ppm_seq varchar(100) NULL,
	CONSTRAINT tbl_progrm_applc_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_progrm_applc IS '프로그램 적용 테이블';

-- Permissions

ALTER TABLE public.tbl_progrm_applc OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_progrm_applc TO ivs;


-- public.tbl_progrm_applc_history definition

-- Drop table

-- DROP TABLE public.tbl_progrm_applc_history;

CREATE TABLE public.tbl_progrm_applc_history (
	seq bigserial NOT NULL,
	pa_seq int8 NULL,
	org_seq int8 NULL,
	ppm_seq varchar(100) NULL,
	insert_dt timestamp NULL,
	CONSTRAINT tbl_progrm_applc_history_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_progrm_applc_history IS '프로그램 적용 히스토리';

-- Permissions

ALTER TABLE public.tbl_progrm_applc_history OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_progrm_applc_history TO ivs;


-- public.tbl_progrm_udpt definition

-- Drop table

-- DROP TABLE public.tbl_progrm_udpt;

CREATE TABLE public.tbl_progrm_udpt (
	pu_seq int8 NOT NULL DEFAULT nextval('tbl_progrm_udpt_seq_seq1'::regclass), -- 시리얼 번호
	pu_name varchar(100) NULL, -- 프로그램명
	pu_status varchar(10) NULL, -- 작업 상태값 (I-insert,U-update)
	pu_dc varchar(500) NULL, -- 설명
	status varchar(10) NULL, -- 업데이트 실행 여부
	deb_apply_name varchar(100) NULL, -- 패키지명
	deb_new_version varchar(100) NULL, -- 패키지 신규버전
	deb_now_version varchar(100) NULL, -- 패키지 현재버전
	base_deb_yn varchar(10) NULL, -- 설치파일유무
	CONSTRAINT tbl_progrm_udpt_pkey PRIMARY KEY (pu_seq)
);
COMMENT ON TABLE public.tbl_progrm_udpt IS '프로그램 / OS 업데이트 목록';

-- Column comments

COMMENT ON COLUMN public.tbl_progrm_udpt.pu_seq IS '시리얼 번호';
COMMENT ON COLUMN public.tbl_progrm_udpt.pu_name IS '프로그램명';
COMMENT ON COLUMN public.tbl_progrm_udpt.pu_status IS '작업 상태값 (I-insert,U-update)';
COMMENT ON COLUMN public.tbl_progrm_udpt.pu_dc IS '설명';
COMMENT ON COLUMN public.tbl_progrm_udpt.status IS '업데이트 실행 여부';
COMMENT ON COLUMN public.tbl_progrm_udpt.deb_apply_name IS '패키지명';
COMMENT ON COLUMN public.tbl_progrm_udpt.deb_new_version IS '패키지 신규버전';
COMMENT ON COLUMN public.tbl_progrm_udpt.deb_now_version IS '패키지 현재버전';
COMMENT ON COLUMN public.tbl_progrm_udpt.base_deb_yn IS '설치파일유무';

-- Permissions

ALTER TABLE public.tbl_progrm_udpt OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_progrm_udpt TO ivs;


-- public.tbl_recovery_agent_job definition

-- Drop table

-- DROP TABLE public.tbl_recovery_agent_job;

CREATE TABLE public.tbl_recovery_agent_job (
	seq serial NOT NULL,
	org_seq int8 NULL, -- 부서 번호
	pc_seq int8 NULL, -- PC 번호
	br_seq int8 NULL,
	br_backup_gubun varchar(10) NULL,
	br_backup_path varchar(100) NULL,
	br_backup_name varchar(100) NULL,
	insert_dt timestamp NULL,
	pc_uuid varchar(100) NULL,
	recv_applc_seq int8 NULL,
	status varchar(10) NULL,
	CONSTRAINT tbl_recovery_agent_job_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_recovery_agent_job IS '백업본 복원 에이전트';

-- Column comments

COMMENT ON COLUMN public.tbl_recovery_agent_job.org_seq IS '부서 번호';
COMMENT ON COLUMN public.tbl_recovery_agent_job.pc_seq IS 'PC 번호';

-- Permissions

ALTER TABLE public.tbl_recovery_agent_job OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_recovery_agent_job TO ivs;


-- public.tbl_recovery_applc definition

-- Drop table

-- DROP TABLE public.tbl_recovery_applc;

CREATE TABLE public.tbl_recovery_applc (
	seq serial NOT NULL, -- 시리얼 번호
	pc_seq int8 NULL, -- pc 번호
	org_seq int8 NULL, -- 부서 번호
	br_seq int8 NULL, -- 백업 이미지 시퀀스
	CONSTRAINT tbl_recovery_applc_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_recovery_applc IS '복구 적용 테이블';

-- Column comments

COMMENT ON COLUMN public.tbl_recovery_applc.seq IS '시리얼 번호';
COMMENT ON COLUMN public.tbl_recovery_applc.pc_seq IS 'pc 번호';
COMMENT ON COLUMN public.tbl_recovery_applc.org_seq IS '부서 번호';
COMMENT ON COLUMN public.tbl_recovery_applc.br_seq IS '백업 이미지 시퀀스';

-- Permissions

ALTER TABLE public.tbl_recovery_applc OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_recovery_applc TO ivs;


-- public.tbl_recovery_applc_history definition

-- Drop table

-- DROP TABLE public.tbl_recovery_applc_history;

CREATE TABLE public.tbl_recovery_applc_history (
	seq bigserial NOT NULL, -- 시리얼 번호
	recv_applc_seq int8 NULL, -- 복원 번호
	insert_dt timestamp NULL, -- 복원일
	CONSTRAINT tbl_recovery_applc_history_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_recovery_applc_history IS '복원 로그';

-- Column comments

COMMENT ON COLUMN public.tbl_recovery_applc_history.seq IS '시리얼 번호';
COMMENT ON COLUMN public.tbl_recovery_applc_history.recv_applc_seq IS '복원 번호';
COMMENT ON COLUMN public.tbl_recovery_applc_history.insert_dt IS '복원일';

-- Permissions

ALTER TABLE public.tbl_recovery_applc_history OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_recovery_applc_history TO ivs;


-- public.tbl_recovery_log definition

-- Drop table

-- DROP TABLE public.tbl_recovery_log;

CREATE TABLE public.tbl_recovery_log (
	seq bigserial NOT NULL,
	org_seq int8 NULL,
	br_seq int8 NULL, -- 백업이미지 인덱스
	status varchar(10) NULL,
	ins_date timestamp NULL DEFAULT now(),
	pc_seq int4 NULL, -- 복구pc번호
	CONSTRAINT tbl_recovery_log_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_recovery_log IS '복구관리 로그 테이블';

-- Column comments

COMMENT ON COLUMN public.tbl_recovery_log.br_seq IS '백업이미지 인덱스';
COMMENT ON COLUMN public.tbl_recovery_log.pc_seq IS '복구pc번호';

-- Permissions

ALTER TABLE public.tbl_recovery_log OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_recovery_log TO ivs;


-- public.tbl_security_agentjob definition

-- Drop table

-- DROP TABLE public.tbl_security_agentjob;

CREATE TABLE public.tbl_security_agentjob (
	seq serial NOT NULL,
	pcm_seq int8 NULL,
	syname varchar(50) NULL,
	systatus varchar(10) NULL,
	org_seq int8 NULL,
	sm_gubun varchar(10) NULL,
	sm_port varchar(10) NULL,
	CONSTRAINT tbl_security_agentjob_pkey PRIMARY KEY (seq)
);

-- Permissions

ALTER TABLE public.tbl_security_agentjob OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_security_agentjob TO ivs;


-- public.tbl_security_mngr definition

-- Drop table

-- DROP TABLE public.tbl_security_mngr;

CREATE TABLE public.tbl_security_mngr (
	sm_seq int4 NOT NULL DEFAULT nextval('tbl_security_mngr_seq_seq1'::regclass), -- 시리얼 번호
	sm_name varchar(50) NULL, -- 시리얼 번호
	sm_status varchar(10) NULL,
	sm_dc varchar(100) NULL, -- 시리얼 번호
	sm_port varchar(10) NULL, -- 포트
	sm_gubun varchar(10) NULL, -- 보안제품 구분
	sm_device_code varchar(20) NULL, -- 벤더코드/제품코드
	CONSTRAINT tbl_security_mngr_pkey PRIMARY KEY (sm_seq)
);
COMMENT ON TABLE public.tbl_security_mngr IS '보안관리';

-- Column comments

COMMENT ON COLUMN public.tbl_security_mngr.sm_seq IS '시리얼 번호';
COMMENT ON COLUMN public.tbl_security_mngr.sm_name IS '시리얼 번호';
COMMENT ON COLUMN public.tbl_security_mngr.sm_dc IS '시리얼 번호';
COMMENT ON COLUMN public.tbl_security_mngr.sm_port IS '포트';
COMMENT ON COLUMN public.tbl_security_mngr.sm_gubun IS '보안제품 구분';
COMMENT ON COLUMN public.tbl_security_mngr.sm_device_code IS '벤더코드/제품코드';

-- Permissions

ALTER TABLE public.tbl_security_mngr OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_security_mngr TO ivs;


-- public.tbl_site_agent_job definition

-- Drop table

-- DROP TABLE public.tbl_site_agent_job;

CREATE TABLE public.tbl_site_agent_job (
	seq serial NOT NULL,
	sma_seq int8 NULL,
	sma_history_seq int8 NULL,
	pc_uuid varchar(100) NULL,
	insert_dt timestamp NULL,
	CONSTRAINT tbl_site_agent_job_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_site_agent_job IS '유해사이트 에이전트 작업';

-- Permissions

ALTER TABLE public.tbl_site_agent_job OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_site_agent_job TO ivs;


-- public.tbl_site_mngr_applc definition

-- Drop table

-- DROP TABLE public.tbl_site_mngr_applc;

CREATE TABLE public.tbl_site_mngr_applc (
	sma_seq int4 NOT NULL DEFAULT nextval('tbl_site_mngr_applc_seq_seq1'::regclass), -- 시리얼 번호
	sma_ipaddress varchar(50) NULL, -- 사이트IP관리-IP주소
	sma_macaddress varchar(100) NULL, -- 사이트IP관리-맥어드레스
	sma_domain varchar(200) NULL, -- 유해사이트-주소
	sma_info varchar(200) NULL, -- 설명
	sma_insert_dt timestamp NULL DEFAULT now(), -- 등록일
	sma_update_dt timestamp NULL DEFAULT now(), -- 수정일
	sma_gubun varchar(10) NULL, -- 분류 A:허용사이트 // B:유해사이트 // F:유해사이트포워딩주소(1개)
	CONSTRAINT tbl_site_mngr_applc_pkey PRIMARY KEY (sma_seq)
);
COMMENT ON TABLE public.tbl_site_mngr_applc IS '사이트IP관리 및 유해사이트관리';

-- Column comments

COMMENT ON COLUMN public.tbl_site_mngr_applc.sma_seq IS '시리얼 번호';
COMMENT ON COLUMN public.tbl_site_mngr_applc.sma_ipaddress IS '사이트IP관리-IP주소';
COMMENT ON COLUMN public.tbl_site_mngr_applc.sma_macaddress IS '사이트IP관리-맥어드레스';
COMMENT ON COLUMN public.tbl_site_mngr_applc.sma_domain IS '유해사이트-주소';
COMMENT ON COLUMN public.tbl_site_mngr_applc.sma_info IS '설명';
COMMENT ON COLUMN public.tbl_site_mngr_applc.sma_insert_dt IS '등록일';
COMMENT ON COLUMN public.tbl_site_mngr_applc.sma_update_dt IS '수정일';
COMMENT ON COLUMN public.tbl_site_mngr_applc.sma_gubun IS '분류 A:허용사이트 // B:유해사이트 // F:유해사이트포워딩주소(1개)';

-- Permissions

ALTER TABLE public.tbl_site_mngr_applc OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_site_mngr_applc TO ivs;


-- public.tbl_site_mngr_applc_history definition

-- Drop table

-- DROP TABLE public.tbl_site_mngr_applc_history;

CREATE TABLE public.tbl_site_mngr_applc_history (
	seq bigserial NOT NULL, -- 시리얼 번호
	sma_seq int8 NULL, -- 관리번호
	insert_dt timestamp NULL, -- 등록일
	sma_gubun varchar(10) NULL, -- 유해사이트구분
	sma_status varchar(10) NULL, -- 상태값
	CONSTRAINT tbl_site_mngr_applc_history_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_site_mngr_applc_history IS '유해사이트 로그';

-- Column comments

COMMENT ON COLUMN public.tbl_site_mngr_applc_history.seq IS '시리얼 번호';
COMMENT ON COLUMN public.tbl_site_mngr_applc_history.sma_seq IS '관리번호';
COMMENT ON COLUMN public.tbl_site_mngr_applc_history.insert_dt IS '등록일';
COMMENT ON COLUMN public.tbl_site_mngr_applc_history.sma_gubun IS '유해사이트구분';
COMMENT ON COLUMN public.tbl_site_mngr_applc_history.sma_status IS '상태값';

-- Permissions

ALTER TABLE public.tbl_site_mngr_applc_history OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_site_mngr_applc_history TO ivs;


-- public.tbl_svrlst definition

-- Drop table

-- DROP TABLE public.tbl_svrlst;

CREATE TABLE public.tbl_svrlst (
	seq serial NOT NULL,
	"name" varchar(100) NULL,
	"domain" varchar(100) NULL,
	ipaddress varchar(100) NULL,
	svr_dc varchar(300) NULL,
	ins_date timestamp NULL,
	svr_port varchar(10) NULL,
	CONSTRAINT tbl_svrlst_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_svrlst IS '서버 정보';

-- Permissions

ALTER TABLE public.tbl_svrlst OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_svrlst TO ivs;


-- public.tbl_tchnlgy definition

-- Drop table

-- DROP TABLE public.tbl_tchnlgy;

CREATE TABLE public.tbl_tchnlgy (
	seq serial NOT NULL, -- 인덱스
	org_seq int8 NULL, -- 조직 인덱스
	object_seq int8 NULL, -- 부서 인덱스
	user_seq int8 NULL, -- 요청자 인덱스
	title varchar(100) NULL,
	"content" text NULL,
	ins_date timestamp NULL DEFAULT now(),
	upd_date timestamp NULL DEFAULT now(),
	"type" varchar(20) NULL, -- 요청 종류
	status varchar(5) NULL DEFAULT '접수'::character varying,
	type_detail varchar(50) NULL, -- 원격지원여부
	tel_num varchar(100) NULL,
	state varchar(10) NULL, -- 상태값
	CONSTRAINT tbl_tchnlgy_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_tchnlgy IS '기술지원';

-- Column comments

COMMENT ON COLUMN public.tbl_tchnlgy.seq IS '인덱스';
COMMENT ON COLUMN public.tbl_tchnlgy.org_seq IS '조직 인덱스';
COMMENT ON COLUMN public.tbl_tchnlgy.object_seq IS '부서 인덱스';
COMMENT ON COLUMN public.tbl_tchnlgy.user_seq IS '요청자 인덱스';
COMMENT ON COLUMN public.tbl_tchnlgy."type" IS '요청 종류';
COMMENT ON COLUMN public.tbl_tchnlgy.type_detail IS '원격지원여부';
COMMENT ON COLUMN public.tbl_tchnlgy.state IS '상태값';

-- Permissions

ALTER TABLE public.tbl_tchnlgy OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_tchnlgy TO ivs;


-- public.tbl_unauthroized definition

-- Drop table

-- DROP TABLE public.tbl_unauthroized;

CREATE TABLE public.tbl_unauthroized (
	seq serial NOT NULL,
	org_seq int8 NULL,
	uuid varchar NULL,
	vendor varchar(50) NULL,
	product varchar(50) NULL,
	info varchar(50) NULL,
	pc_user varchar(50) NULL,
	insert_dt timestamp NULL,
	CONSTRAINT tbl_unauthroized_pkey PRIMARY KEY (seq)
);

-- Permissions

ALTER TABLE public.tbl_unauthroized OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_unauthroized TO ivs;


-- public.tbl_updt_agent_job definition

-- Drop table

-- DROP TABLE public.tbl_updt_agent_job;

CREATE TABLE public.tbl_updt_agent_job (
	seq serial NOT NULL, -- 시리얼번호
	pu_seq int8 NULL, -- 작업번호
	org_seq int8 NULL, -- 부서번호
	updt_ap_seq int8 NULL, -- 업데이트 관리번호
	pcm_uuid varchar(100) NULL, -- PC 관리번호
	pcm_name varchar(100) NULL, -- 프로그램 명
	status varchar(10) NULL, -- 상태값
	insert_dt timestamp NULL, -- 등록일
	CONSTRAINT tbl_updt_agent_job_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_updt_agent_job IS 'agent get data updt';

-- Column comments

COMMENT ON COLUMN public.tbl_updt_agent_job.seq IS '시리얼번호';
COMMENT ON COLUMN public.tbl_updt_agent_job.pu_seq IS '작업번호';
COMMENT ON COLUMN public.tbl_updt_agent_job.org_seq IS '부서번호';
COMMENT ON COLUMN public.tbl_updt_agent_job.updt_ap_seq IS '업데이트 관리번호';
COMMENT ON COLUMN public.tbl_updt_agent_job.pcm_uuid IS 'PC 관리번호';
COMMENT ON COLUMN public.tbl_updt_agent_job.pcm_name IS '프로그램 명';
COMMENT ON COLUMN public.tbl_updt_agent_job.status IS '상태값';
COMMENT ON COLUMN public.tbl_updt_agent_job.insert_dt IS '등록일';

-- Permissions

ALTER TABLE public.tbl_updt_agent_job OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_updt_agent_job TO ivs;


-- public.tbl_updt_applc definition

-- Drop table

-- DROP TABLE public.tbl_updt_applc;

CREATE TABLE public.tbl_updt_applc (
	seq serial NOT NULL,
	org_seq int8 NOT NULL,
	ppm_seq varchar(100) NULL,
	CONSTRAINT tbl_updt_applc_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_updt_applc IS '업데이트 적용 테이블';

-- Permissions

ALTER TABLE public.tbl_updt_applc OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_updt_applc TO ivs;


-- public.tbl_updt_applc_history definition

-- Drop table

-- DROP TABLE public.tbl_updt_applc_history;

CREATE TABLE public.tbl_updt_applc_history (
	seq bigserial NOT NULL,
	org_seq int8 NULL,
	ppm_seq varchar(100) NULL,
	updt_seq int8 NULL,
	insert_dt timestamp NULL,
	CONSTRAINT tbl_updt_applc_history_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_updt_applc_history IS '업데이트 정책 히스토리';

-- Permissions

ALTER TABLE public.tbl_updt_applc_history OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_updt_applc_history TO ivs;


-- public.tbl_updt_policy_action_result definition

-- Drop table

-- DROP TABLE public.tbl_updt_policy_action_result;

CREATE TABLE public.tbl_updt_policy_action_result (
	seq bigserial NOT NULL, -- 시리얼 번호
	debname varchar(100) NULL, -- 패키지명
	state varchar(10) NULL, -- 상태값
	"path" varchar(100) NULL, -- 경로
	gubun varchar(10) NULL, -- 작업구분
	pc_uuid varchar(300) NULL, -- PC관리번호
	org_seq int8 NULL, -- 부서번호
	insert_dt timestamptz NULL,
	debver varchar(100) NULL, -- 패키지 버전
	CONSTRAINT tbl_updt_policy_action_result_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_updt_policy_action_result IS '업데이트 정책 적용 결과';

-- Column comments

COMMENT ON COLUMN public.tbl_updt_policy_action_result.seq IS '시리얼 번호';
COMMENT ON COLUMN public.tbl_updt_policy_action_result.debname IS '패키지명';
COMMENT ON COLUMN public.tbl_updt_policy_action_result.state IS '상태값';
COMMENT ON COLUMN public.tbl_updt_policy_action_result."path" IS '경로';
COMMENT ON COLUMN public.tbl_updt_policy_action_result.gubun IS '작업구분';
COMMENT ON COLUMN public.tbl_updt_policy_action_result.pc_uuid IS 'PC관리번호';
COMMENT ON COLUMN public.tbl_updt_policy_action_result.org_seq IS '부서번호';
COMMENT ON COLUMN public.tbl_updt_policy_action_result.debver IS '패키지 버전';

-- Permissions

ALTER TABLE public.tbl_updt_policy_action_result OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_updt_policy_action_result TO ivs;


-- public.tbl_user definition

-- Drop table

-- DROP TABLE public.tbl_user;

CREATE TABLE public.tbl_user (
	seq serial NOT NULL, -- 사용자 번호
	user_id varchar(50) NOT NULL, -- 사용자 아이디
	pass_wd varchar(100) NOT NULL, -- 사용자 비밀번호
	user_name varchar(100) NOT NULL, -- 사용자 이름
	ins_date timestamp NULL DEFAULT now(), -- 가입일
	upd_date timestamp NULL DEFAULT now(), -- 수정일
	kind varchar(10) NULL, -- 구분
	"rank" varchar(10) NULL, -- 직급
	org_seq int8 NULL, -- 부서번호
	"position" varchar(20) NULL, -- 부서 관리자 여부
	agree_dt timestamp NULL, -- 정보 동의일
	user_sabun varchar(30) NOT NULL, -- 사번
	discharge_dt varchar(20) NULL, -- 퇴사일
	CONSTRAINT tbl_user_pkey PRIMARY KEY (seq),
	CONSTRAINT tbl_user_user_id_key UNIQUE (user_id)
);
COMMENT ON TABLE public.tbl_user IS '사용자 정보';

-- Column comments

COMMENT ON COLUMN public.tbl_user.seq IS '사용자 번호';
COMMENT ON COLUMN public.tbl_user.user_id IS '사용자 아이디';
COMMENT ON COLUMN public.tbl_user.pass_wd IS '사용자 비밀번호';
COMMENT ON COLUMN public.tbl_user.user_name IS '사용자 이름';
COMMENT ON COLUMN public.tbl_user.ins_date IS '가입일';
COMMENT ON COLUMN public.tbl_user.upd_date IS '수정일';
COMMENT ON COLUMN public.tbl_user.kind IS '구분';
COMMENT ON COLUMN public.tbl_user."rank" IS '직급';
COMMENT ON COLUMN public.tbl_user.org_seq IS '부서번호';
COMMENT ON COLUMN public.tbl_user."position" IS '부서 관리자 여부';
COMMENT ON COLUMN public.tbl_user.agree_dt IS '정보 동의일';
COMMENT ON COLUMN public.tbl_user.user_sabun IS '사번';
COMMENT ON COLUMN public.tbl_user.discharge_dt IS '퇴사일';

-- Permissions

ALTER TABLE public.tbl_user OWNER TO ivs;
GRANT ALL ON TABLE public.tbl_user TO ivs;


INSERT INTO public.tbl_admin_login_history (user_id,conn_ip,login_date,logout_date,time_spent) VALUES
	 ('ivs','192.168.0.146','2021-06-23 05:34:34.206617',NULL,NULL),
	 ('ivs','192.168.0.146','2021-06-23 07:10:54.757181',NULL,NULL),
	 ('ivs','192.168.0.146','2021-06-23 07:11:07.419726',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 16:19:31.181803',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 16:21:34.363202',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 16:21:35.984577',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 16:40:33.030163',NULL,NULL),
	 ('ivs','61.32.208.27','2021-06-23 07:57:58.596665',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 17:13:30.920336','2021-06-23 17:15:31.965882','00:02:01.045546'),
	 ('ivs','127.0.0.1','2021-06-23 17:17:05.967269',NULL,NULL);
INSERT INTO public.tbl_admin_login_history (user_id,conn_ip,login_date,logout_date,time_spent) VALUES
	 ('ivs','192.168.0.146','2021-06-23 08:26:09.69427',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 17:31:53.840597',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 18:24:25.388361',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 18:38:32.969645',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 18:38:35.570258',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 19:40:50.592971',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 19:45:47.347905',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 20:09:16.080897',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 20:09:22.733207',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 20:09:24.510965',NULL,NULL);
INSERT INTO public.tbl_admin_login_history (user_id,conn_ip,login_date,logout_date,time_spent) VALUES
	 ('ivs','127.0.0.1','2021-06-23 20:11:19.352581',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 20:11:21.885742',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 20:13:13.168237',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 20:22:15.216557',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 20:36:28.863178',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 21:07:07.829751',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 21:07:13.60163',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 21:08:36.09485',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 21:09:57.881127',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 21:35:47.594761',NULL,NULL);
INSERT INTO public.tbl_admin_login_history (user_id,conn_ip,login_date,logout_date,time_spent) VALUES
	 ('ivs','127.0.0.1','2021-06-23 21:41:09.389536',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 21:59:55.826495',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 21:59:55.989323',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 21:59:56.196751',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 22:00:03.854192',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 22:00:11.856638',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 22:09:19.540737',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-23 22:10:05.87516',NULL,NULL),
	 ('ivs','192.168.0.146','2021-06-24 01:19:57.171802',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-24 10:29:21.740579',NULL,NULL);
INSERT INTO public.tbl_admin_login_history (user_id,conn_ip,login_date,logout_date,time_spent) VALUES
	 ('ivs','127.0.0.1','2021-06-24 10:43:07.436635',NULL,NULL),
	 ('ivs','61.32.208.27','2021-06-24 01:47:54.271115',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-24 10:59:43.297726',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-24 11:13:41.684182',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-24 11:37:49.162261',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-24 11:44:45.945594',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-24 11:52:14.031666',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-24 11:52:14.335397',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-24 12:13:22.557749',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-24 12:37:14.295444',NULL,NULL);
INSERT INTO public.tbl_admin_login_history (user_id,conn_ip,login_date,logout_date,time_spent) VALUES
	 ('ivs','127.0.0.1','2021-06-24 13:18:02.446228',NULL,NULL),
	 ('ivs','127.0.0.1','2021-06-24 14:14:33.850204',NULL,NULL);INSERT INTO public.tbl_admin_user (user_id,user_name,pass_wd,dept_name,ins_date,upd_date,gubun) VALUES
	 ('ivs','관리자','518c84bc0dc5d7830ea10a5958343e5c706c057e1197318a8b07ae5aa624b04a','관리자','2021-06-15 14:18:14','2021-06-15 14:18:14','A'),
	 ('admin','관리자계정','c1a6dc631dfed24284f30e9517b305a995985bb7c95cde85be1f640275e97ae9','개발','2021-06-17 16:58:28.063635',NULL,'A');INSERT INTO public.tbl_device_agent_job (sm_seq,org_seq,dvc_seq,pcm_uuid,pcm_name,status,insert_dt) VALUES
	 (3,4,3,'2c6777e5d8a349fb92a14e65ad961447','USB',NULL,'2021-06-24 14:20:20.013209');INSERT INTO public.tbl_device_applc (org_seq,ppm_seq) VALUES
	 (4,'3');INSERT INTO public.tbl_device_applc_history (org_seq,ppm_seq,dvc_seq,insert_dt) VALUES
	 (4,'3',3,'2021-06-24 14:20:14.049201');INSERT INTO public.tbl_frwl_agent_job (sm_seq,org_seq,fa_seq,pcm_uuid,pcm_name,status,insert_dt) VALUES
	 (NULL,4,11,'2c6777e5d8a349fb92a14e65ad961447',NULL,NULL,'2021-06-24 12:50:59.656686'),
	 (NULL,4,12,'2c6777e5d8a349fb92a14e65ad961447','test',NULL,'2021-06-24 14:14:55.933021'),
	 (NULL,4,15,'2c6777e5d8a349fb92a14e65ad961447','test2',NULL,'2021-06-24 14:17:16.495316');INSERT INTO public.tbl_frwl_applc (org_seq,ppm_seq) VALUES
	 (4,'5,6');INSERT INTO public.tbl_frwl_applc_history (org_seq,insert_dt,frwl_seq,ppm_seq) VALUES
	 (4,'2021-06-24 14:14:53.885338',12,'4'),
	 (4,'2021-06-24 14:15:27.726917',13,'4,5'),
	 (4,'2021-06-24 14:15:28.623472',14,'4,5'),
	 (4,'2021-06-24 14:17:08.191505',15,'5'),
	 (4,'2021-06-24 14:18:30.006117',16,'5,6');INSERT INTO public.tbl_hamonize_version_chk (debname,debversion,debstatus,pcuuid,insert_dt,last_dt) VALUES
	 ('hamonize-agent','1.0.0','running','a928a9b1b25048caa132c3d4804cd43b','2021-06-23 18:41:35.287464+09',NULL),
	 ('hamonize-agent','1.0.0','running','2c6777e5d8a349fb92a14e65ad961447','2021-06-23 18:42:26.476275+09','2021-06-24 14:17:17+09');INSERT INTO public.tbl_ip (ipaddress,gubun,info,ins_date,upd_date,macaddress) VALUES
	 ('127.0.0.1','Y','localhost','2021-06-15','2021-06-15',NULL),
	 ('192.168.0.*','Y','내부망','2021-06-15','2021-06-15',NULL),
	 ('61.32.208.27','Y','invesume','2021-06-15','2021-06-15',NULL),
	 ('10.8.0.*','Y','VPN','2021-06-21','2021-06-21',NULL),
	 ('172.17.0.*','Y','Docker','2021-06-21','2021-06-21',NULL);INSERT INTO public.tbl_org (p_seq,org_nm,org_ordr,writer_id,ins_date,writer_ip,update_writer_id,upd_date,update_writer_ip,"section",p_org_nm,sido,gugun,org_num,xpoint,ypoint,all_org_nm) VALUES
	 (1,'test_under',1,NULL,'2021-06-23',NULL,NULL,'2021-06-23',NULL,'S','test - 1','영등포구','서울시',NULL,NULL,NULL,'test|test_under'),
	 (0,'test',NULL,NULL,'2021-06-23',NULL,NULL,'2021-06-23',NULL,'','',NULL,NULL,NULL,NULL,NULL,NULL),
	 (1,'test_dept',2,NULL,'2021-06-23',NULL,NULL,'2021-06-23',NULL,'','test - 1',NULL,NULL,NULL,NULL,NULL,'test|test_dept'),
	 (3,'test_lee',1,NULL,'2021-06-23',NULL,NULL,'2021-06-23',NULL,'S','test_dept - 3','서울','서초구',NULL,NULL,NULL,'test|testdept|test_lee');INSERT INTO public.tbl_pc_block (seq,org_seq,block_dt,unblock_dt,status,pc_ip,insert_dt) VALUES
	 (2,NULL,NULL,NULL,'Y',NULL,'2021-06-24 12:22:57.269446');INSERT INTO public.tbl_pc_influxdata (pc_uuid,insert_dt,pc_status) VALUES
	 ('a928a9b1b25048caa132c3d4804cd43b','2021-06-23 12:15:47','true'),
	 ('2c6777e5d8a349fb92a14e65ad961447','2021-06-23 12:15:47','true');INSERT INTO public.tbl_pc_mangr (pc_status,pc_cpu,pc_memory,pc_disk,pc_macaddress,pc_ip,first_date,last_date,pc_hostname,pc_guid,org_seq,pc_disk_id,pc_cpu_id,pc_uuid,pc_change,pc_vpnip,pc_sn,pc_os) VALUES
	 ('N','Intel(R) Core(TM) i5-8500 CPU @ 3.00GHz','3.60G      ','SAMSUNG MZ7LN128HAHQ-00000        ','10:02:b5:02:b3:bd','192.168.0.212','2021-06-23 18:09:23','2021-06-23 18:09:23','hamolee',NULL,4,NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447',NULL,NULL,'hamolee','H');INSERT INTO public.tbl_program_mngr (pcm_name,pcm_status,pcm_dc,pcm_path,insert_dt) VALUES
	 ('htop',NULL,NULL,NULL,'0202-06-24 00:00:00');INSERT INTO public.tbl_progrm_agent_job (pcm_seq,org_seq,pa_seq,pcm_uuid,pcm_name,insert_dt,status) VALUES
	 (1,4,1,'2c6777e5d8a349fb92a14e65ad961447','htop','2021-06-24 14:35:41.99456',NULL),
	 (0,4,2,'2c6777e5d8a349fb92a14e65ad961447',NULL,'2021-06-24 14:36:36.673194',NULL);INSERT INTO public.tbl_progrm_applc (org_seq,ppm_seq) VALUES
	 (4,'');INSERT INTO public.tbl_progrm_applc_history (pa_seq,org_seq,ppm_seq,insert_dt) VALUES
	 (1,4,'1','2021-06-24 14:34:28.685953'),
	 (2,4,'','2021-06-24 14:36:24.580959');INSERT INTO public.tbl_progrm_udpt (pu_name,pu_status,pu_dc,status,deb_apply_name,deb_new_version,deb_now_version,base_deb_yn) VALUES
	 ('hamonize','I',NULL,'N','hamonize','4.2.0.0',NULL,'Y'),
	 ('atom','I',NULL,'N','atom','1.57.0',NULL,'Y'),
	 ('atom-beta','I',NULL,'N','atom-beta','1.58.0-beta0',NULL,'Y'),
	 ('atom-nightly','I',NULL,'N','atom-nightly','1.59.0-nightly11',NULL,'Y'),
	 ('htop','I',NULL,'N','htop','2.2.0-2build1',NULL,'Y'),
	 ('skypeforlinux','I',NULL,'N','skypeforlinux','8.73.0.92',NULL,'Y'),
	 ('yarn','I',NULL,'N','yarn','1.22.5-1',NULL,'Y');INSERT INTO public.tbl_security_mngr (sm_name,sm_status,sm_dc,sm_port,sm_gubun,sm_device_code) VALUES
	 ('USB',NULL,'Kingston USB',NULL,'D','0951:1666'),
	 ('test',NULL,'test','11100','P',NULL),
	 ('test2',NULL,'11112','11112','P',NULL),
	 ('test3',NULL,'test','11113','P',NULL);INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:39:09.130865'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:39:46.090778'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:39:46.842725'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:39:56.887045'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:40:07.089567'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:40:18.301324'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:40:29.256188'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:40:37.30942'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:40:47.352191'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:40:57.434736');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:41:07.47215'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:41:26.688993'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:41:27.612669'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:41:37.690633'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:42:05.124862'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:42:07.821269'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:42:08.425174'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:42:17.834467'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:42:37.895905'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:42:41.702277');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:42:47.950419'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:42:58.388859'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:43:08.010763'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:43:18.025311'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:43:29.437029'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:43:38.114979'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:43:48.149531'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:43:59.260424'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:44:08.494094'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:44:18.29249');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:44:38.38469'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:44:42.716724'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:44:48.441017'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:45:04.03096'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:45:08.533844'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:45:19.020808'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:45:34.176135'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:45:48.730739'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:46:05.484243'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:46:08.789749');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:46:18.824561'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:46:38.911387'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:46:42.347217'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:46:48.950144'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:47:00.471684'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:47:09.040714'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:47:26.398643'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:47:34.821247'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:47:39.160596'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:47:49.217313');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:48:12.711792'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:48:13.229582'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:48:19.344611'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:48:29.384317'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:48:46.247524'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:51:29.086529'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:51:35.0692'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:51:45.616002'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:51:55.19646'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:52:05.213051');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:52:15.254484'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:52:25.303178'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:52:52.534426'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:52:55.471091'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:53:02.762876'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:53:05.495856'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:53:15.564731'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:53:25.599505'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:53:35.63007'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:53:45.686822');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:53:56.58226'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 19:54:05.833521'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:09:11.896374'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:09:21.699305'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:09:29.991238'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:09:40.424765'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:09:50.028356'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:11:22.572444'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:11:30.517513'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:11:40.542863');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:11:50.570417'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:12:02.969662'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:12:11.806453'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:12:20.715439'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:12:30.750937'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:12:51.709597'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:13:11.24484'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:13:20.974518'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:13:36.025846'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:13:41.072892');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:13:52.537973'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:14:01.140684'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:14:18.144709'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:14:21.204497'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:14:31.273571'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:14:41.962537'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:15:01.41534'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:15:04.992243'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:15:11.473105'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:15:21.485781');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:15:38.011027'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:15:41.562467'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:15:51.641991'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:16:01.669929'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:16:17.434549'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:16:22.473634'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:16:31.789112'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:16:50.974945'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:16:51.842419'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:17:02.787286');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:17:12.375836'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:17:21.989032'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:17:32.016538'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:17:44.540551'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:17:52.055215'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:18:02.091209'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:18:22.161643'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:18:25.953697'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:18:32.192962'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:18:49.755326');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:18:52.273971'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:19:02.323549'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:19:20.479878'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:19:22.414123'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:19:33.255439'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:19:44.796653'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:19:52.509703'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:20:02.54546'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:20:18.751885'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:20:22.635081');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:20:32.639254'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:20:53.668341'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:20:53.742091'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 20:21:02.725462'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:12:36.15261'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:12:40.004775'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:12:49.412748'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:12:59.447593'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:13:19.60786'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:13:20.95485');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:13:29.667658'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:13:39.696443'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:14:05.53434'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:14:09.860143'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:14:17.01765'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:14:19.885198'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:14:30.377312'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:14:39.96576'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:14:49.993319'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:15:00.322818');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:19:14.521449'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:24:13.747233'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:24:13.867393'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:24:32.437675'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:24:33.93345'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:24:43.973955'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:24:54.442938'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:25:04.915845'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:25:14.067857'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:25:24.10749');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:25:36.844062'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:25:51.323917'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:25:54.176989'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:26:04.193151'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:26:21.230805'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:26:24.225177'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:26:35.099185'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:26:44.287188'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:26:54.305712'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:27:08.026789');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:27:14.357911'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:27:24.404926'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:27:35.037067'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:27:44.467392'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:27:58.66723'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:28:04.803008'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:28:14.528927'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:28:24.539852'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:28:35.563349'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:28:53.807673');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:28:54.60488'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:29:05.920207'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:29:14.648283'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:29:24.672105'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:29:37.116715'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:29:44.718102'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:29:54.760759'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:30:04.981579'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:30:14.783693'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:30:26.935187');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:30:34.815723'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:30:44.83073'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:30:55.387377'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:31:04.877813'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:31:20.842947'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:31:25.988417'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:31:34.960413'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:31:44.98289'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:31:54.994312'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:32:09.907374');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:32:15.78874'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:32:25.054765'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:32:35.082637'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:32:55.121218'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:32:55.214638'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:33:05.840963'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:33:15.168519'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:33:25.201467'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:33:35.215016'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:33:45.232534');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:34:03.058408'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:34:05.276934'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:34:15.306888'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:34:25.340476'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:34:36.642689'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:34:45.373932'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:34:56.301926'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:35:05.437026'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:35:28.049209'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:35:31.377676');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:35:46.178152'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:35:55.521965'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:36:05.575523'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:36:15.592041'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:36:25.621461'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:36:38.082213'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:36:45.643317'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:36:55.68196'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:37:07.402887'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:37:15.721765');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:37:25.720899'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:37:48.84578'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:37:51.152072'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:37:59.334633'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:38:05.826606'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:38:16.538308'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:38:25.858663'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:38:35.923855'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:38:51.822794'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:38:55.952828');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:39:13.579135'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:39:15.973387'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:39:26.240299'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:39:36.017132'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:39:46.053369'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:40:04.020391'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:40:06.096492'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:40:16.111409'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:40:26.130672'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:40:37.227059');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:40:56.402571'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:41:12.886483'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:41:16.285231'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 21:41:32.267182'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 22:11:46.877125'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 22:11:57.770159'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 22:12:06.904679'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 22:12:16.929292'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 22:12:26.963016'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 22:12:37.001864');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 22:12:47.027351'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 22:12:57.064733'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 22:13:07.112971'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 22:13:17.161321'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 22:13:27.175045'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-23 22:13:37.193105'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:42:27.427426'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:42:41.370408'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:42:52.95117'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:43:03.706772');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:43:20.232909'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:43:29.206905'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:43:39.916317'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:43:50.720093'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:44:11.482258'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:44:14.764852'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:44:23.708431'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:44:34.193141'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:44:44.953974'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:45:15.79699');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:45:19.274951'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:45:23.118612'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:45:26.439054'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:45:43.855917'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:46:06.103571'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:46:21.438607'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:46:23.020139'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:46:33.036627'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:46:43.047746'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:46:59.107188');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:47:02.23273'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:47:12.259736'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:47:23.138588'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:47:32.282065'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:47:42.304985'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:47:59.275761'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:48:02.335436'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:48:12.356029'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:48:22.959267'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:48:33.258343');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:48:42.408901'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:49:03.948284'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:49:05.922364'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:49:12.467766'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:49:48.333688'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:49:53.744824'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:50:03.77527'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:50:13.801253'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:50:27.243313'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:50:33.897591');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:50:43.957843'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:50:54.461713'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:51:03.981956'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:51:14.001781'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:51:24.036269'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:51:34.749027'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:51:44.071749'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:51:54.119708'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:52:12.200846'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:52:14.185405');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:52:24.205992'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:52:34.234101'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:52:55.328794'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:52:58.026389'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:53:04.310439'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:53:14.331684'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:53:31.305374'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:53:34.382307'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:53:44.406703'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:53:54.465671');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:54:07.817123'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:54:14.489403'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:54:54.557291'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:55:01.153651'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:55:05.021423'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:55:14.603723'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:55:35.426'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:55:44.698622'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:55:54.738709'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:56:13.097341');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:56:14.758836'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:56:44.824953'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:56:54.884947'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:57:24.940937'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:57:41.924929'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:57:44.979091'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:58:06.073125'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:58:15.051288'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:58:25.110522'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:58:42.343264');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:58:45.185703'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:59:09.08973'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:59:15.246733'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 13:00:06.33744'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 13:00:15.367976'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 13:00:28.417166'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 13:00:35.411044'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 13:01:46.688554'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 13:01:54.142086'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:54:24.52819');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:54:45.0924'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:55:24.639112'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:56:25.441215'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:56:39.457758'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:57:11.97372'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:57:14.929146'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:57:55.237044'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:58:55.212983'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:59:25.681881'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:59:35.286904');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 12:59:55.822043'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 13:00:06.023245'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 13:00:45.446965'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 13:00:56.100381'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 13:01:05.475341'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 13:02:04.176888'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:14:42.743122'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:14:45.894624'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:14:55.934454'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:15:13.967717');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:15:15.976363'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:15:26.274871'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:15:36.020363'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:17:05.917347'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:17:16.497605'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:17:28.134564'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:17:36.541059'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:17:46.561347'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:17:56.577257'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:18:06.601347');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:18:16.612342'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:18:26.626798'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:18:38.111731'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:18:53.470566'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:19:04.262284'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:19:25.005771'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:19:33.292334'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:19:35.731353'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:19:46.467416'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:19:57.227402');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:20:07.973339'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:20:20.024218'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:20:30.478284'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:20:41.215842'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:35:40.714319'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:35:50.945611'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:36:11.748693'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:36:16.048581'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:36:22.454454'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:36:33.855711');
INSERT INTO public.tbl_site_agent_job (sma_seq,sma_history_seq,pc_uuid,insert_dt) VALUES
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:36:50.102832'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:37:02.093185'),
	 (NULL,NULL,'2c6777e5d8a349fb92a14e65ad961447','2021-06-24 14:37:13.781306');INSERT INTO public.tbl_updt_agent_job (pu_seq,org_seq,updt_ap_seq,pcm_uuid,pcm_name,status,insert_dt) VALUES
	 (0,4,4,'2c6777e5d8a349fb92a14e65ad961447',NULL,NULL,'2021-06-23 18:37:55.258747'),
	 (1,4,5,'2c6777e5d8a349fb92a14e65ad961447','hamonize',NULL,'2021-06-23 19:46:05.548106'),
	 (0,4,6,'2c6777e5d8a349fb92a14e65ad961447',NULL,NULL,'2021-06-23 19:53:02.766694'),
	 (1,4,7,'2c6777e5d8a349fb92a14e65ad961447','hamonize',NULL,'2021-06-23 19:53:45.693913'),
	 (0,4,8,'2c6777e5d8a349fb92a14e65ad961447',NULL,NULL,'2021-06-23 22:11:46.880073'),
	 (5,4,9,'2c6777e5d8a349fb92a14e65ad961447','htop',NULL,'2021-06-24 12:43:18.129407'),
	 (2,4,9,'2c6777e5d8a349fb92a14e65ad961447','atom',NULL,'2021-06-24 12:43:18.129407');INSERT INTO public.tbl_updt_applc (org_seq,ppm_seq) VALUES
	 (2,'0'),
	 (4,'5,2');INSERT INTO public.tbl_updt_applc_history (org_seq,ppm_seq,updt_seq,insert_dt) VALUES
	 (2,'0',1,'2021-06-23 17:18:44.210531'),
	 (2,'0',2,'2021-06-23 17:32:39.423439'),
	 (4,'0',3,'2021-06-23 17:38:25.826102'),
	 (4,'',4,'2021-06-23 18:06:07.730574'),
	 (4,'1',5,'2021-06-23 19:46:02.896326'),
	 (4,'',6,'2021-06-23 19:53:01.717511'),
	 (4,'1',7,'2021-06-23 19:53:41.643305'),
	 (4,'',8,'2021-06-23 22:11:25.257027'),
	 (4,'5,2',9,'2021-06-24 12:43:13.886402');INSERT INTO public.tbl_updt_policy_action_result (debname,state,"path",gubun,pc_uuid,org_seq,insert_dt,debver) VALUES
	 ('hamonize','1','','DELETE','2c6777e5d8a349fb92a14e65ad961447',4,'2021-06-23 22:11:53.208208+09','');
