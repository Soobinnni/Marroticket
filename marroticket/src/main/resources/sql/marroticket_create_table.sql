--삭제는 다음 순서에 따르면 됨
drop table payment purge;
drop table reservation purge;
drop table play purge;
drop table umember_auth purge;
drop table tmember_auth purge;
drop table umember purge;
drop table tmember purge;

--순서에 상관 없는 테이블들
drop table tfaq purge;
drop table ufaq purge;
drop table notice purge;
drop table chat purge;

--시퀀스 삭제
drop sequence notice_seq;
drop sequence tfaq_seq;
drop sequence ufaq_seq;
drop sequence pay_seq;
drop sequence play_seq;
drop sequence reservation_seq;
drop sequence tmember_seq;
drop sequence umember_seq;
drop sequence chat_seq;

--일반 회원 테이블
create table UMEMBER(
u_number number(38)NOT NULL primary KEY ,--일반 회원 번호
u_id VARCHAR2(20) UNIQUE NOT NULL,--아이디
u_password VARCHAR2(100) NOT NULL,--비밀번호
u_name VARCHAR2(20) NOT NULL ,--이름
u_phoneNumber VARCHAR2(11) NOT NULL,-- 일반 사용자 휴대전화 번호
u_birthday VARCHAR2(10) NOT NULL,--생년월일
u_gender VARCHAR2(10) NOT NULL,--성별
u_email VARCHAR2(50) NOT NULL,--이메일
u_joinDate date DEFAULT sysdate NOT NULL,--가입일
u_unjoin VARCHAR2(10),--탈퇴여부
u_unjoinDate date DEFAULT sysdate,--탈퇴일
u_genre VARCHAR2(1) NOT NULL,--관심 장르
u_agree VARCHAR2(1) NOT NULL--약관 동의여부
);

--일반 회원 시퀀스 생성 
create sequence UMEMBER_seq
start with 1
increment by 1;

--일반 회원 권한 테이블
CREATE TABLE umember_auth (
u_number NUMBER(38) NOT NULL,
umember_auth VARCHAR2(50) NOT NULL,
FOREIGN KEY ( u_number ) REFERENCES umember ( u_number )
);

--극단 회원 테이블
create table TMEMBER(
t_number number(38)NOT NULL primary KEY,--극단 회원 번호
t_id VARCHAR2(20) UNIQUE NOT NULL,--아이디
t_password VARCHAR2(100) NOT NULL,--비밀번단호
t_name VARCHAR2(50) NOT NULL ,--극단명
t_address VARCHAR2(100) NOT NULL,--극단주소
t_ownerName VARCHAR2(20) NOT NULL,--대표자명
t_ownerPhoneNumber VARCHAR2(11) NOT NULL,--대표자 휴대전화번호
t_ownerEmail VARCHAR2(50) NOT NULL,--대표자 이메일
t_businessRegistration VARCHAR2(1) NOT NULL,--사업자 등록 구분 (개인/기업)
t_businessRegistrationNumber VARCHAR2(10) NOT NULL,--사업자 등록번호
t_establishmentDate date DEFAULT sysdate NOT NULL,--설립일
t_bank VARCHAR2(50) NOT NULL,--거래 은행
t_bankNumber VARCHAR2(50) NOT NULL,--계좌번호
t_bankOwner VARCHAR2(50) NOT NULL,--예금주
t_businessRegistrationImage VARCHAR2(100) NOT NULL,--사업자등록증 사본
t_fileurl VARCHAR2(100) NOT NULL ,
t_filename VARCHAR2(100) NOT NULL,
t_auth  VARCHAR2(10) NOT NULL,--극단 회원 상태(가입승인예정/가입승인완료/계약종료
t_agree VARCHAR2(1) NOT NULL--약관 동의여부
);
-- 극단 회원 시퀀스 생성 
create sequence TMEMBER_seq
start with 1
increment by 1;


--극단 회원 권한 테이블
CREATE TABLE tmember_auth (
t_number NUMBER(38) NOT NULL,
tmember_auth VARCHAR2(50) NOT NULL,
FOREIGN KEY ( t_number ) REFERENCES tmember ( t_number )
);

--PLAY(연극) 테이블
CREATE TABLE play (
    p_number                 NUMBER(38) NOT NULL, --연극 번호
    p_name                   VARCHAR2(50) NOT NULL, --연극명
    p_startdate              DATE NOT NULL, --연극 시작일
    p_closedate              DATE NOT NULL, --연극 종료일
    p_runningtime            VARCHAR2(3) NOT NULL, --연극 소요시간(러닝타임)
    p_theatername            VARCHAR2(20) NOT NULL, --극장 이름
    p_theateraddress         VARCHAR2(100) NOT NULL, --극장 주소
    p_theatermapurl     VARCHAR2(100) NOT NULL,--극장 약도 url
    p_agency                 VARCHAR2(20) NOT NULL, --기획사 정보
    p_ratings                VARCHAR2(1) NOT NULL, --관람 등급
    p_casting                VARCHAR2(2000) NOT NULL, --캐스팅 데이터
    p_ticketopendate         DATE NOT NULL, --예매 오픈 희망일
    p_plot                   VARCHAR2(4000) NOT NULL, --공연 줄거리
    p_seatnumber             NUMBER(20) NOT NULL, --좌석 개수
    p_ticketprice            NUMBER(7) NOT NULL, --티켓 가격
    p_genre                  VARCHAR2(1) NOT NULL, --장르 정보
    p_posterurl         VARCHAR2(100) NOT NULL, --연극 포스터 url
    p_amendmentapproved      VARCHAR2(1), --공연 수정 승인 여부
    p_registrationapproval   VARCHAR2(1), --공연 등록 승인 여부
    p_firststarttime         VARCHAR2(10) NOT NULL, -- 1회차 상연 시작 시각 
    p_secondstarttime        VARCHAR2(10), -- 2회차 상연 시작 시각 
    p_agree                  VARCHAR2(1) NOT NULL, --약관 동의 여부
    t_number                 NUMBER(38) NOT NULL, --극단 회원 번호
    PRIMARY KEY ( p_number ),
    FOREIGN KEY ( t_number )
        REFERENCES tmember ( t_number )
);


--연극 시퀀스 생성 
CREATE SEQUENCE play_seq START WITH 1 INCREMENT BY 1;


--예매 테이블 생성
CREATE TABLE RESERVATION (
R_NUMBER NUMBER(38) NOT NULL PRIMARY KEY, -- 예매번호
R_DATE DATE default sysdate NOT NULL, -- 예매일
R_PAYSTATE NUMBER(5) NOT NULL, -- 예매진행중 여부
R_FEE NUMBER(3) NOT NULL, -- 예매 수수료
R_CANCELSTATE NUMBER(5) NOT NULL, -- 예매 취소 여부
R_CANCELDATE DATE DEFAULT sysdate, -- 예매 취소일
R_TICKETFIRST VARCHAR2(38) NOT NULL, -- 티켓번호1
R_TICKETSECOND VARCHAR2(38), -- 티켓번호2
R_TICKETTHIRD VARCHAR2(38), -- 티켓번호3
R_TICKETFOURTH VARCHAR2(38), -- 티켓번호4
R_TICKETCOUNT NUMBER(38), -- 티켓개수
R_TOTALPAYMENT NUMBER(10) NOT NULL, -- 결제 총액
U_NUMBER NUMBER(38) NOT NULL, -- 일반 회원 번호
P_NUMBER NUMBER(38) NOT NULL, -- 연극번호

FOREIGN KEY(U_NUMBER) REFERENCES UMEMBER(U_NUMBER), -- 일반 회원 번호 외래키 설정
FOREIGN KEY(P_NUMBER) REFERENCES PLAY(P_NUMBER) -- 연극 번호 외래키 설정
);

-- 예매 시퀀스 생성
CREATE SEQUENCE RESERVATION_SEQ
START WITH 1 INCREMENT BY 1;

insert into RESERVATION
VALUES(reservation_seq.nextval,sysdate,1,500,0,null,'2023020931a1','2023020931a2',null,null,2,12000,1,2);
--marroticket
-->2023년 2월 9일 공연/공연번호3번/1회차/a1좌석
insert into RESERVATION
VALUES(reservation_seq.nextval,sysdate,1,500,0,null,'2023020931a1','2023020931a2','2023020931a3',null,2,12000,1,3);
insert into RESERVATION
VALUES(reservation_seq.nextval,sysdate,1,500,0,null,'2023020931a1','2023020931a2','2023020931a3','2023020931a4',2,12000,1,2);

insert into RESERVATION
VALUES(reservation_seq.nextval,sysdate,1,500,1,null,'2023020931a4',null,null,null,1,18000,1,3);

UPDATE RESERVATION SET R_CANCELSTATE = 1
WHERE R_NUMBER =7 AND U_NUMBER =1;
  
commit;
select * from RESERVATION;


--정산 테이블 생성
CREATE TABLE PAYMENT (
PAY_NUMBER NUMBER(38) NOT NULL PRIMARY KEY, -- 정산 번호
PAY_CALCULATE DATE DEFAULT sysDate NOT NULL, -- 정산 일자
PAY_PAYDATE DATE NOT NULL, -- 지급일
PAY_PAYMENT NUMBER(20) NOT NULL, -- 금액
P_NUMBER NUMBER(38) NOT NULL, -- 연극 번호
R_NUMBER NUMBER(38) NOT NULL, -- 예매 번호
T_NUMBER NUMBER(38) NOT NULL, -- 극단 회원 번호

FOREIGN KEY(P_NUMBER) REFERENCES PLAY(P_NUMBER), -- 연극 번호 외래키 설정
FOREIGN KEY(R_NUMBER) REFERENCES RESERVATION(R_NUMBER), -- 예매 번호 외래키 설정
FOREIGN KEY(T_NUMBER) REFERENCES TMEMBER(T_NUMBER) -- 극단 회원 번호 외래키 설정
);

-- 정산 시퀀스 생성
CREATE SEQUENCE PAY_SEQ
START WITH 1 INCREMENT BY 1;

--일반회원 FAQ 테이블 생성
CREATE TABLE UFAQ(
UF_number number(38) not null, --게시글 번호/PK
UF_title varchar2(100) not null, -- 글 제목
UF_content varchar2(4000) not null, -- 글 내용
UF_date Date DEFAULT sysdate  not null, -- 등록일
primary key(UF_number)
);
--일반회원 FAQ 시퀀스 생성
CREATE SEQUENCE ufaq_seq START WITH 1 INCREMENT BY 1;


--극단회원 FAQ 테이블 생성
CREATE TABLE TFAQ(
TF_number number(38) not null, --게시글 번호/PK
TF_title varchar2(100) not null, -- 글 제목
TF_content varchar2(4000) not null, -- 글 내용
TF_date Date DEFAULT sysdate not null, -- 등록일
primary key(TF_number)
);
--극단회원 FAQ 시퀀스 생성
CREATE SEQUENCE tfaq_seq START WITH 1 INCREMENT BY 1;

--공지사항 테이블 생성
CREATE TABLE NOTICE(
N_number number(38) not null, --게시글 번호/PK
N_title varchar2(100) not null, -- 글 제목
N_content varchar2(4000) not null, -- 글 내용
N_date Date DEFAULT sysdate not null, -- 등록일
primary key(N_number)
);
--공지사항 시퀀스 생성
CREATE SEQUENCE notice_seq START WITH 1 INCREMENT BY 1;

--쿠키 저장 테이블
CREATE TABLE persistent_logins (
username VARCHAR2(64) NOT NULL,
series VARCHAR2(64) NOT NULL,
token VARCHAR2(64) NOT NULL,
last_used DATE NOT NULL,
PRIMARY KEY (series)
);

--chat table
create table CHAT(
    chat_number number(5)NOT NULL primary KEY ,--chat 시퀀스번호
    u_id VARCHAR2(20),--회원 아이디
    chat_recommend NUMBER(1),--자리 추천
    chat_check NUMBER(1)--예매 여부 확인
);
--chat sequence
create sequence CHAT_seq
start with 1
increment by 1;

-- 시퀀스 번호 넘어가는 오류 방지
alter sequence notice_seq nocache;
alter sequence tfaq_seq nocache;
alter sequence ufaq_seq nocache;
alter sequence pay_seq nocache;
alter sequence play_seq nocache;
alter sequence reservation_seq nocache;
alter sequence tmember_seq nocache;
alter sequence umember_seq nocache;
alter sequence chat_seq nocache;
