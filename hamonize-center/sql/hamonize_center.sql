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

ALTER TABLE public.tbl_act_backup_recovery_log OWNER TO hamonize;


-- public.tbl_act_device_log definition

-- Drop table

-- DROP TABLE public.tbl_act_device_log;

CREATE TABLE public.tbl_act_device_log (
	seq bigserial NOT NULL,
	org_seq int8 NULL,
	uuid varchar(200) NULL,
	hostname varchar(100) NULL,
	status_yn varchar(10) NULL,
	product varchar(200) NULL,
	vendorcode varchar(100) NULL,
	productcode varchar(100) NULL,
	ins_date timestamp NULL
);
COMMENT ON TABLE public.tbl_act_device_log IS '디바이스 허용 배포 결과';

-- Permissions

ALTER TABLE public.tbl_act_device_log OWNER TO hamonize;


-- public.tbl_act_firewall_log definition

-- Drop table

-- DROP TABLE public.tbl_act_firewall_log;

CREATE TABLE public.tbl_act_firewall_log (
	seq bigserial NOT NULL,
	orgseq int8 NULL,
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

ALTER TABLE public.tbl_act_firewall_log OWNER TO hamonize;


-- public.tbl_act_progrm_log definition

-- Drop table

-- DROP TABLE public.tbl_act_progrm_log;

CREATE TABLE public.tbl_act_progrm_log (
	seq bigserial NOT NULL,
	orgseq int8 NULL,
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

ALTER TABLE public.tbl_act_progrm_log OWNER TO hamonize;


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

ALTER TABLE public.tbl_admin_login_history OWNER TO hamonize;


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
	salt varchar(300) NULL,
	CONSTRAINT tbl_admin_user_pkey PRIMARY KEY (user_id)
);
COMMENT ON TABLE public.tbl_admin_user IS '관리자 정보';

-- Permissions

ALTER TABLE public.tbl_admin_user OWNER TO hamonize;


-- public.tbl_agent_job definition

-- Drop table

-- DROP TABLE public.tbl_agent_job;

CREATE TABLE public.tbl_agent_job (
	seq bigserial NOT NULL,
	ins_date timestamp NULL,
	aj_return_val varchar NULL,
	aj_table_sabun varchar(50) NULL,
	ppa_seq varchar(500) NULL,
	aj_ppa_org_seq varchar(100) NULL,
	aj_table_seq int8 NULL,
	CONSTRAINT tbl_agent_job_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_agent_job IS 'agent 정책파일';

-- Permissions

ALTER TABLE public.tbl_agent_job OWNER TO hamonize;


-- public.tbl_backup_agent_job definition

-- Drop table

-- DROP TABLE public.tbl_backup_agent_job;

CREATE TABLE public.tbl_backup_agent_job (
	seq bigserial NOT NULL,
	bac_seq int8 NULL,
	org_seq int8 NULL,
	pcm_uuid varchar(100) NULL,
	pcm_name varchar(100) NULL,
	insert_dt timestamp NULL,
	status varchar(10) NULL,
	CONSTRAINT tbl_backup_agent_job_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_backup_agent_job IS '에이전트 백업';

-- Permissions

ALTER TABLE public.tbl_backup_agent_job OWNER TO hamonize;


-- public.tbl_backup_applc definition

-- Drop table

-- DROP TABLE public.tbl_backup_applc;

CREATE TABLE public.tbl_backup_applc (
	bac_seq bigserial NOT NULL,
	org_seq int8 NULL,
	bac_cycle_option varchar(50) NULL,
	bac_cycle_time varchar(50) NULL,
	bac_gubun varchar(10) NULL,
	CONSTRAINT tbl_backup_applc_pkey PRIMARY KEY (bac_seq)
);
COMMENT ON TABLE public.tbl_backup_applc IS '백업주기 설정';

-- Permissions

ALTER TABLE public.tbl_backup_applc OWNER TO hamonize;


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
	insert_dt timestamp NULL,
	CONSTRAINT tbl_backup_applc_history_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_backup_applc_history IS '백업주기 히스토리';

-- Permissions

ALTER TABLE public.tbl_backup_applc_history OWNER TO hamonize;


-- public.tbl_backup_recovery_mngr definition

-- Drop table

-- DROP TABLE public.tbl_backup_recovery_mngr;

CREATE TABLE public.tbl_backup_recovery_mngr (
	br_seq bigserial NOT NULL, -- 시리얼 번호
	br_org_seq int8 NULL, -- 부서 번호
	br_backup_path varchar(100) NULL, -- 백업 이미지 경로 및 iso 파일 이름
	br_backup_iso_dt timestamp NULL DEFAULT now(), -- 백업일시
	br_backup_gubun varchar(10) NULL, -- 백업구분(A:초기백업본, B: 일반백업본)
	br_backup_name varchar(100) NULL, -- 백업명
	dept_seq int8 NULL, -- pc 시퀀스 번호
	CONSTRAINT tbl_backup_recovery_mngr_pkey PRIMARY KEY (br_seq)
);
COMMENT ON TABLE public.tbl_backup_recovery_mngr IS '백업 이미지 정보 테이블';

-- Column comments

COMMENT ON COLUMN public.tbl_backup_recovery_mngr.br_seq IS '시리얼 번호';
COMMENT ON COLUMN public.tbl_backup_recovery_mngr.br_org_seq IS '부서 번호';
COMMENT ON COLUMN public.tbl_backup_recovery_mngr.br_backup_path IS '백업 이미지 경로 및 iso 파일 이름';
COMMENT ON COLUMN public.tbl_backup_recovery_mngr.br_backup_iso_dt IS '백업일시';
COMMENT ON COLUMN public.tbl_backup_recovery_mngr.br_backup_gubun IS '백업구분(A:초기백업본, B: 일반백업본)';
COMMENT ON COLUMN public.tbl_backup_recovery_mngr.br_backup_name IS '백업명';
COMMENT ON COLUMN public.tbl_backup_recovery_mngr.dept_seq IS 'pc 시퀀스 번호';

-- Permissions

ALTER TABLE public.tbl_backup_recovery_mngr OWNER TO hamonize;


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

ALTER TABLE public.tbl_device_agent_job OWNER TO hamonize;


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

ALTER TABLE public.tbl_device_applc OWNER TO hamonize;


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

ALTER TABLE public.tbl_device_applc_history OWNER TO hamonize;


-- public.tbl_files definition

-- Drop table

-- DROP TABLE public.tbl_files;

CREATE TABLE public.tbl_files (
	seq serial NOT NULL,
	filename varchar(100) NULL, -- 저장소에 저장된 파일명
	filerealname varchar(100) NULL, -- 실제 파일명
	filepath varchar(100) NULL, -- 파일 경로
	filesize varchar(100) NULL, -- 파일 크기
	ins_date timestamp NULL,
	keytype varchar(50) NULL,
	CONSTRAINT tbl_files_pkey PRIMARY KEY (seq)
);

-- Column comments

COMMENT ON COLUMN public.tbl_files.filename IS '저장소에 저장된 파일명';
COMMENT ON COLUMN public.tbl_files.filerealname IS '실제 파일명';
COMMENT ON COLUMN public.tbl_files.filepath IS '파일 경로';
COMMENT ON COLUMN public.tbl_files.filesize IS '파일 크기';

-- Permissions

ALTER TABLE public.tbl_files OWNER TO hamonize;


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

ALTER TABLE public.tbl_frwl_agent_job OWNER TO hamonize;


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

ALTER TABLE public.tbl_frwl_applc OWNER TO hamonize;


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

ALTER TABLE public.tbl_frwl_applc_history OWNER TO hamonize;


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

ALTER TABLE public.tbl_hamonize_version_chk OWNER TO hamonize;


-- public.tbl_loginout definition

-- Drop table

-- DROP TABLE public.tbl_loginout;

CREATE TABLE public.tbl_loginout (
	seq bigserial NOT NULL, -- 시리얼 번호
	logout_dt timestamptz NULL, -- 로그아웃 시간
	uuid varchar(100) NULL, -- PC 관리번호
	login_dt timestamptz NULL DEFAULT now(),
	CONSTRAINT tbl_loginout_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_loginout IS '로그인/아웃 로그';

-- Column comments

COMMENT ON COLUMN public.tbl_loginout.seq IS '시리얼 번호';
COMMENT ON COLUMN public.tbl_loginout.logout_dt IS '로그아웃 시간';
COMMENT ON COLUMN public.tbl_loginout.uuid IS 'PC 관리번호';

-- Permissions

ALTER TABLE public.tbl_loginout OWNER TO hamonize;


-- public.tbl_org definition

-- Drop table

-- DROP TABLE public.tbl_org;

CREATE TABLE public.tbl_org (
	seq serial NOT NULL, -- 부문/부서번호
	p_seq int8 NULL DEFAULT 0, -- 상위부서번호
	org_nm varchar(100) NULL, -- 부문명/부서명
	org_ordr int4 NULL, -- 부서순서
	writer_id varchar(30) NULL,
	ins_date date NULL,
	writer_ip varchar(30) NULL,
	update_writer_id varchar(30) NULL,
	upd_date date NULL,
	update_writer_ip varchar(30) NULL,
	"section" varchar(100) NULL, -- 부서여부
	p_org_nm varchar(100) NULL, -- 상위부문명
	sido varchar(100) NULL, -- 지역(시/도)
	gugun varchar(100) NULL, -- 지역(구/군)
	org_num varchar(100) NULL, -- 부서번호
	xpoint varchar(100) NULL,
	ypoint varchar(100) NULL,
	all_org_nm varchar(300) NULL, -- 전체경로
	CONSTRAINT tbl_org_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_org IS '조직 정보';

-- Column comments

COMMENT ON COLUMN public.tbl_org.seq IS '부문/부서번호';
COMMENT ON COLUMN public.tbl_org.p_seq IS '상위부서번호';
COMMENT ON COLUMN public.tbl_org.org_nm IS '부문명/부서명';
COMMENT ON COLUMN public.tbl_org.org_ordr IS '부서순서';
COMMENT ON COLUMN public.tbl_org."section" IS '부서여부';
COMMENT ON COLUMN public.tbl_org.p_org_nm IS '상위부문명';
COMMENT ON COLUMN public.tbl_org.sido IS '지역(시/도)';
COMMENT ON COLUMN public.tbl_org.gugun IS '지역(구/군)';
COMMENT ON COLUMN public.tbl_org.org_num IS '부서번호';
COMMENT ON COLUMN public.tbl_org.all_org_nm IS '전체경로';

-- Permissions

ALTER TABLE public.tbl_org OWNER TO hamonize;


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

ALTER TABLE public.tbl_pc_block OWNER TO hamonize;


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
	pc_user varchar(50) NULL, -- 사용자 os 계정
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
COMMENT ON COLUMN public.tbl_pc_change_info.pc_user IS '사용자 os 계정';

-- Permissions

ALTER TABLE public.tbl_pc_change_info OWNER TO hamonize;


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

ALTER TABLE public.tbl_pc_influxdata OWNER TO hamonize;


-- public.tbl_pc_mangr definition

-- Drop table

-- DROP TABLE public.tbl_pc_mangr;

CREATE TABLE public.tbl_pc_mangr (
	seq bigserial NOT NULL, -- 시리얼 번호
	pc_status varchar(300) NULL, -- 하드웨어 업데이트 여부
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
	pc_change varchar(10) NULL, -- R:신청 P:허가 C:완료
	pc_vpnip varchar(20) NULL, -- vpn_ip
	pc_sn varchar(300) NULL, -- PC SN
	pc_os varchar(50) NULL, -- OS 구분
	CONSTRAINT tbl_pc_mangr_pkey PRIMARY KEY (seq)
);
CREATE INDEX tbl_pc_mangr_idx_uuid ON public.tbl_pc_mangr USING btree (pc_uuid);
COMMENT ON TABLE public.tbl_pc_mangr IS 'PC H/W 정보 관리';

-- Column comments

COMMENT ON COLUMN public.tbl_pc_mangr.seq IS '시리얼 번호';
COMMENT ON COLUMN public.tbl_pc_mangr.pc_status IS '하드웨어 업데이트 여부';
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

ALTER TABLE public.tbl_pc_mangr OWNER TO hamonize;


-- public.tbl_pc_mangr_history definition

-- Drop table

-- DROP TABLE public.tbl_pc_mangr_history;

CREATE TABLE public.tbl_pc_mangr_history (
	seq bigserial NOT NULL, -- 시리얼번호
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

ALTER TABLE public.tbl_pc_mangr_history OWNER TO hamonize;


-- public.tbl_polling_agent_job definition

-- Drop table

-- DROP TABLE public.tbl_polling_agent_job;

CREATE TABLE public.tbl_polling_agent_job (
	seq serial NOT NULL,
	org_seq int8 NULL, -- 부서번호
	polling_tm int8 NULL, -- 적용된 polling time
	uuid varchar(100) NULL, -- PC관리번호
	pu_name varchar(100) NULL, -- 적용프로그램
	status varchar(50) NULL,
	insert_dt timestamp NULL,
	CONSTRAINT tbl_polling_agent_job_pk PRIMARY KEY (seq)
);

-- Column comments

COMMENT ON COLUMN public.tbl_polling_agent_job.org_seq IS '부서번호';
COMMENT ON COLUMN public.tbl_polling_agent_job.polling_tm IS '적용된 polling time';
COMMENT ON COLUMN public.tbl_polling_agent_job.uuid IS 'PC관리번호';
COMMENT ON COLUMN public.tbl_polling_agent_job.pu_name IS '적용프로그램';

-- Permissions

ALTER TABLE public.tbl_polling_agent_job OWNER TO hamonize;


-- public.tbl_polling_applc definition

-- Drop table

-- DROP TABLE public.tbl_polling_applc;

CREATE TABLE public.tbl_polling_applc (
	seq serial NOT NULL,
	pu_name varchar(100) NULL,
	polling_tm int8 NULL,
	insert_dt timestamp NULL,
	CONSTRAINT tbl_polling_applc_pk PRIMARY KEY (seq)
);

-- Permissions

ALTER TABLE public.tbl_polling_applc OWNER TO hamonize;


-- public.tbl_prcss_block_log definition

-- Drop table

-- DROP TABLE public.tbl_prcss_block_log;

CREATE TABLE public.tbl_prcss_block_log (
	seq serial NOT NULL,
	hostname varchar(200) NULL,
	prcssname varchar(200) NULL,
	ipaddress varchar(50) NULL,
	uuid varchar(200) NULL,
	org_seq int8 NULL,
	insert_dt timestamp NULL,
	CONSTRAINT tbl_prcss_block_log_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_prcss_block_log IS '프로그램 차단 로그';

-- Permissions

ALTER TABLE public.tbl_prcss_block_log OWNER TO hamonize;


-- public.tbl_program_mngr definition

-- Drop table

-- DROP TABLE public.tbl_program_mngr;

CREATE TABLE public.tbl_program_mngr (
	pcm_seq bigserial NOT NULL, -- 시리얼번호
	pcm_name varchar(500) NULL, -- 프로그램명
	pcm_status varchar(10) NULL,
	pcm_dc varchar(500) NULL, -- 프로그램설명
	pcm_path varchar(100) NULL,
	insert_dt timestamp NULL -- 등록일
);
COMMENT ON TABLE public.tbl_program_mngr IS 'pc 프로그램 리스트 관리';

-- Column comments

COMMENT ON COLUMN public.tbl_program_mngr.pcm_seq IS '시리얼번호';
COMMENT ON COLUMN public.tbl_program_mngr.pcm_name IS '프로그램명';
COMMENT ON COLUMN public.tbl_program_mngr.pcm_dc IS '프로그램설명';
COMMENT ON COLUMN public.tbl_program_mngr.insert_dt IS '등록일';

-- Permissions

ALTER TABLE public.tbl_program_mngr OWNER TO hamonize;


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

ALTER TABLE public.tbl_progrm_agent_job OWNER TO hamonize;


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

ALTER TABLE public.tbl_progrm_applc OWNER TO hamonize;


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

ALTER TABLE public.tbl_progrm_applc_history OWNER TO hamonize;


-- public.tbl_progrm_udpt definition

-- Drop table

-- DROP TABLE public.tbl_progrm_udpt;

CREATE TABLE public.tbl_progrm_udpt (
	pu_seq bigserial NOT NULL, -- 시리얼 번호
	pu_name varchar(100) NULL, -- 프로그램명
	pu_status varchar(10) NULL, -- 작업 상태값 (I-insert,U-update)
	pu_dc varchar(500) NULL, -- 설명
	status varchar(10) NULL, -- 업데이트 실행 여부
	deb_apply_name varchar(100) NULL, -- 패키지명
	deb_new_version varchar(100) NULL, -- 패키지 신규버전
	deb_now_version varchar(100) NULL, -- 패키지 현재버전
	base_deb_yn varchar(10) NULL, -- 설치파일유무
	polling_tm int8 NOT NULL DEFAULT 0, -- 프로그램 폴링타임/하모나이즈 프로그램만
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
COMMENT ON COLUMN public.tbl_progrm_udpt.polling_tm IS '프로그램 폴링타임/하모나이즈 프로그램만';

-- Permissions

ALTER TABLE public.tbl_progrm_udpt OWNER TO hamonize;


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

ALTER TABLE public.tbl_recovery_agent_job OWNER TO hamonize;


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

ALTER TABLE public.tbl_recovery_applc OWNER TO hamonize;


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

ALTER TABLE public.tbl_recovery_applc_history OWNER TO hamonize;


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

ALTER TABLE public.tbl_recovery_log OWNER TO hamonize;


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

ALTER TABLE public.tbl_security_agentjob OWNER TO hamonize;


-- public.tbl_security_mngr definition

-- Drop table

-- DROP TABLE public.tbl_security_mngr;

CREATE TABLE public.tbl_security_mngr (
	sm_seq bigserial NOT NULL, -- 시리얼 번호
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

ALTER TABLE public.tbl_security_mngr OWNER TO hamonize;


-- public.tbl_svrlst definition

-- Drop table

-- DROP TABLE public.tbl_svrlst;

CREATE TABLE public.tbl_svrlst (
	seq serial NOT NULL,
	svr_nm varchar(100) NULL,
	svr_domain varchar(100) NULL,
	svr_ip varchar(100) NULL, -- 서버 ip
	svr_dc varchar(300) NULL,
	insert_dt timestamp NULL,
	svr_port varchar(10) NULL,
	svr_used int8 NULL DEFAULT 1, -- 1:사용/0:미사용
	svr_vip varchar(100) NULL, -- 서버 vpn ip
	CONSTRAINT tbl_svrlst_pkey PRIMARY KEY (seq)
);
COMMENT ON TABLE public.tbl_svrlst IS '서버 정보';

-- Column comments

COMMENT ON COLUMN public.tbl_svrlst.svr_ip IS '서버 ip';
COMMENT ON COLUMN public.tbl_svrlst.svr_used IS '1:사용/0:미사용';
COMMENT ON COLUMN public.tbl_svrlst.svr_vip IS '서버 vpn ip';

-- Permissions

ALTER TABLE public.tbl_svrlst OWNER TO hamonize;


-- public.tbl_unauthroized definition

-- Drop table

-- DROP TABLE public.tbl_unauthroized;

CREATE TABLE public.tbl_unauthroized (
	seq serial NOT NULL,
	org_seq int8 NULL,
	pc_uuid varchar NULL,
	vendor varchar(50) NULL,
	product varchar(50) NULL,
	info varchar(200) NULL,
	pc_user varchar(50) NULL,
	insert_dt timestamp NULL,
	CONSTRAINT tbl_unauthroized_pkey PRIMARY KEY (seq)
);

-- Permissions

ALTER TABLE public.tbl_unauthroized OWNER TO hamonize;


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

ALTER TABLE public.tbl_updt_agent_job OWNER TO hamonize;


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

ALTER TABLE public.tbl_updt_applc OWNER TO hamonize;


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

ALTER TABLE public.tbl_updt_applc_history OWNER TO hamonize;


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

ALTER TABLE public.tbl_updt_policy_action_result OWNER TO hamonize;


-- public.tbl_user definition

-- Drop table

-- DROP TABLE public.tbl_user;

CREATE TABLE public.tbl_user (
	seq serial NOT NULL, -- 사용자 번호
	user_id varchar(50) NOT NULL, -- 사용자 아이디
	pass_wd varchar(100) NOT NULL, -- 사용자 비밀번호
	user_name varchar(100) NOT NULL, -- 사용자 이름
	ins_date varchar NULL DEFAULT now(), -- 가입일
	upd_date timestamp NULL DEFAULT now(), -- 수정일
	gubun varchar(10) NULL, -- 구분
	"rank" varchar(10) NULL, -- 직급
	org_seq int8 NOT NULL, -- 부서번호
	"position" varchar(20) NULL, -- 부서 관리자 여부
	agree_dt timestamp NULL, -- 정보 동의일
	user_sabun varchar(30) NOT NULL, -- 사번
	discharge_dt varchar(20) NULL, -- 퇴사일
	email varchar(30) NULL, -- 사용자 이메일
	tel varchar(30) NULL, -- 사용자 전화번호
	kind varchar(20) NULL,
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
COMMENT ON COLUMN public.tbl_user.gubun IS '구분';
COMMENT ON COLUMN public.tbl_user."rank" IS '직급';
COMMENT ON COLUMN public.tbl_user.org_seq IS '부서번호';
COMMENT ON COLUMN public.tbl_user."position" IS '부서 관리자 여부';
COMMENT ON COLUMN public.tbl_user.agree_dt IS '정보 동의일';
COMMENT ON COLUMN public.tbl_user.user_sabun IS '사번';
COMMENT ON COLUMN public.tbl_user.discharge_dt IS '퇴사일';
COMMENT ON COLUMN public.tbl_user.email IS '사용자 이메일';
COMMENT ON COLUMN public.tbl_user.tel IS '사용자 전화번호';

-- Permissions

ALTER TABLE public.tbl_user OWNER TO hamonize;

-- backup data 

INSERT INTO public.tbl_admin_user (user_id,user_name,pass_wd,dept_name,ins_date,upd_date,gubun,salt) VALUES
	 ('admin','admin','uor4XWaWKTs4935iVs+1eIIxiymAm4hYJYsSHs/CU5A=',NULL,'2021-08-10 11:33:17.030959',NULL,'A','6a70a227ea35f4d0'),
	 ('test','test','i2c+1cHCD2hMB2klY1Apcg7aZIzHwcOwRsO4RJ8Sj38=',NULL,'2021-08-10 11:33:17.030959','2021-09-03 16:12:55.95216','A','24f9ca45fcbe2903');
INSERT INTO public.tbl_svrlst (svr_nm,svr_domain,svr_ip,svr_dc,insert_dt,svr_port,svr_used,svr_vip) VALUES
	 ('CENTERURL',NULL,'localhost',NULL,NULL,'8080',0,NULL),
	 ('COLLECTDIP',NULL,'localhost',NULL,NULL,NULL,0,NULL),
	 ('APTURL',NULL,'106.254.251.74',NULL,NULL,'28081',0,NULL),
	 ('GRAFANA_URL',NULL,'localhost',NULL,NULL,NULL,0,NULL);

-- add pc

INSERT INTO public.tbl_pc_mangr
(seq, pc_status, pc_cpu, pc_memory, pc_disk, pc_macaddress, pc_ip, first_date, last_date, pc_hostname, pc_guid, org_seq, pc_disk_id, pc_cpu_id, pc_uuid, pc_change, pc_vpnip, pc_sn, pc_os)
VALUES(1, 'N', 'Intel® Core™ i5-7500 3.4GHz 4 (4 Physical)', '8GB', 'ATA QNIX_120GB 112GB SSD (SATA)', '4c:cc:6a:f6:bf:5d', '192.168.0.152', now(), now(), 'hamonize-clientpc2', NULL, 3, '2020061600970', NULL, '7490a9f7d989432b9f0f5314ce82e956', NULL, 'no vpn', 'hamonize-clientpc2', 'H'),
	  (2, 'N', 'Intel® Core™ i5-7400 3GHz 4 (4 Physical)', '8GB', 'SanDisk SanDisk_SD8SBAT128G1122 119GB SSD (SATA)', '10:7b:44:47:4d:79', '192.168.0.150', now(), now(), 'hamonize-clientpc', NULL, 2, '161853402440', NULL, 'a61e750dcf354127a388c66bd4063fde', NULL, 'no vpn', 'hamonize-clientpc', 'H');

-- add device

INSERT INTO public.tbl_security_mngr
(sm_seq, sm_name, sm_status, sm_dc, sm_port, sm_gubun, sm_device_code)
VALUES(1, 'card-usb', NULL, 'invesume-test-usb(cardType)', NULL, 'D', '048d:1234');
