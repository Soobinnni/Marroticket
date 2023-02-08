<<<<<<< HEAD
--�Ϲ� ȸ�� ���̺�
create table UMEMBER(
u_number number(38)NOT NULL primary KEY ,--�Ϲ� ȸ�� ��ȣ
u_id VARCHAR2(20) UNIQUE NOT NULL,--���̵�
u_password VARCHAR2(20) NOT NULL,--��й�ȣ
u_name VARCHAR2(6) NOT NULL ,--�̸�
u_phoneNumber VARCHAR2(11) NOT NULL,-- �Ϲ� ����� �޴���ȭ ��ȣ
u_birthday VARCHAR2(8) NOT NULL,--�������
u_gender VARCHAR2(10) NOT NULL,--����
u_email VARCHAR2(50) NOT NULL,--�̸���
u_joinDate date DEFAULT sysdate NOT NULL,--������
u_unjoin VARCHAR2(10),--Ż�𿩺�
u_unjoinDate date DEFAULT sysdate,--Ż����
u_genre number(1) NOT NULL,--���� �帣
u_agree number(1) NOT NULL--��� ���ǿ���
);

--�Ϲ� ȸ�� ������ ���� 
create sequence u_number
start with 1
increment by 1;

--�ش� ȸ�� ���̺�
create table TMEMBER(
t_number number(38)NOT NULL primary KEY,--�ش� ȸ�� ��ȣ
t_id VARCHAR2(20) UNIQUE NOT NULL,--���̵�
t_password VARCHAR2(20) NOT NULL,--��й���ȣ
t_name VARCHAR2(50) NOT NULL ,--�شܸ�
t_address VARCHAR2(100) NOT NULL,--�ش��ּ�
t_ownerName VARCHAR2(6) NOT NULL,--��ǥ�ڸ�
t_ownerPhoneNumber VARCHAR2(11) NOT NULL,--��ǥ�� �޴���ȭ��ȣ
t_ownerEmail VARCHAR2(50) NOT NULL,--��ǥ�� �̸���
t_businessRegistration number(1) NOT NULL,--����� ��� ���� (����/���)
t_businessRegistrationNumber VARCHAR2(10) NOT NULL,--����� ��Ϲ�ȣ
t_establishmentDate date DEFAULT sysdate NOT NULL,--������
t_bank VARCHAR2(50) NOT NULL,--�ŷ� ����
t_bankNumber VARCHAR2(50) NOT NULL,--���¹�ȣ
t_bankOwner VARCHAR2(50) NOT NULL,--������
t_businessRegistrationImage VARCHAR2(100) NOT NULL,--����ڵ���� �纻
t_agree number(1) NOT NULL--��� ���ǿ���
);
-- �ش� ȸ�� ������ ���� 
create sequence t_number 
start with 1
increment by 1;

--PLAY(����) ���̺�
CREATE TABLE play(
   p_number NUMBER(38) NOT NULL, --���� ��ȣ
   p_name VARCHAR2(50) NOT NULL, --���ظ�
   p_startDate DATE NOT NULL, --���� ������
   p_closeDate DATE NOT NULL, --���� ������
   p_runningtime NUMBER(3) NOT NULL, --���� �ҿ�ð�(����Ÿ��)
   p_eachDate DATE NOT NULL, --�󿬳�¥
   p_startTime VARCHAR2(5) NOT NULL, --�� ���� �ð�
   p_closeTime VARCHAR2(5) NOT NULL, --�� ���� �ð�
   p_theaterName VARCHAR2(20) NOT NULL, --���� �̸�
   p_theaterAddress VARCHAR2(100) NOT NULL, --���� �ּ�
   p_theaterMap VARCHAR2(100) NOT NULL, --���� �൵ �̹���
   p_agency VARCHAR2(20) NOT NULL, --��ȹ�� ����
   p_ratings NUMBER(1) NOT NULL, --���� ���
   p_casting VARCHAR2(2000) NOT NULL, --ĳ���� ������
   p_ticketOpenDate DATE NOT NULL, --���� ���� �����
   p_plot VARCHAR2(4000) NOT NULL, --���� �ٰŸ�
   p_seatType VARCHAR2(10) NOT NULL, --�¼� ����
   p_seatNumber NUMBER(20) NOT NULL, --�¼� ����
   p_ticketPrice NUMBER(7) NOT NULL, --Ƽ�� ����
   p_genre NUMBER(1) NOT NULL, --�帣 ����
   p_poster VARCHAR2(100) NOT NULL, --���� ������
   p_firstPlay NUMBER(1), --1ȸ�� ����
   p_secondPlay NUMBER(1), --2ȸ�� ����
   p_agree NUMBER(1) NOT NULL, --��� ���� ����
   p_amendmentApproved NUMBER(1), --���� ���� ���� ����
   p_registrationApproval NUMBER(1), --���� ��� ���� ����
   t_number NUMBER(38) NOT NULL, --�ش� ȸ�� ��ȣ
   PRIMARY KEY(p_number),
   FOREIGN KEY(t_number) REFERENCES tmember(t_number)
);
=======
--������ ���� ������ ������ ��
drop table payment purge;
drop table reservation purge;
drop table play purge;
drop table umember purge;
drop table tmember purge;

--������ ��� ���� ���̺��
drop table notice purge;
drop table tfaq purge;
drop table ufaq purge;

--������ ����
drop sequence notice_seq;
drop sequence tfaq_seq;
drop sequence ufaq_seq;
drop sequence payment_seq;
drop sequence play_seq;
drop sequence reservation_seq;
drop sequence tmember_seq;
drop sequence umember_seq;

--�Ϲ� ȸ�� ���̺�
CREATE TABLE umember (
    u_number      NUMBER(38) NOT NULL PRIMARY KEY,--�Ϲ� ȸ�� ��ȣ
    u_id          VARCHAR2(20) UNIQUE NOT NULL,--���̵�
    u_password    VARCHAR2(20) NOT NULL,--��й�ȣ
    u_name        VARCHAR2(20) NOT NULL,--�̸�
    u_phonenumber VARCHAR2(11) NOT NULL,-- �Ϲ� ����� �޴���ȭ ��ȣ
    u_birthday    VARCHAR2(8) NOT NULL,--�������
    u_gender      VARCHAR2(10) NOT NULL,--����
    u_email       VARCHAR2(50) NOT NULL,--�̸���
    u_joindate    DATE DEFAULT sysdate NOT NULL,--������
    u_unjoin      VARCHAR2(10),--Ż�𿩺�
    u_unjoindate  DATE DEFAULT sysdate,--Ż����
    u_genre       NUMBER(1) NOT NULL,--���� �帣
    u_agree       NUMBER(1) NOT NULL--��� ���ǿ���
);

--�Ϲ� ȸ�� ������ ���� 
CREATE SEQUENCE umember_seq START WITH 1 INCREMENT BY 1;

--�ش� ȸ�� ���̺�
CREATE TABLE tmember (
    t_number                     NUMBER(38) NOT NULL PRIMARY KEY,--�ش� ȸ�� ��ȣ
    t_id                         VARCHAR2(20) UNIQUE NOT NULL,--���̵�
    t_password                   VARCHAR2(20) NOT NULL,--��й���ȣ
    t_name                       VARCHAR2(50) NOT NULL,--�شܸ�
    t_address                    VARCHAR2(100) NOT NULL,--�ش��ּ�
    t_ownername                  VARCHAR2(20) NOT NULL,--��ǥ�ڸ�
    t_ownerphonenumber           VARCHAR2(11) NOT NULL,--��ǥ�� �޴���ȭ��ȣ
    t_owneremail                 VARCHAR2(50) NOT NULL,--��ǥ�� �̸���
    t_businessregistration       NUMBER(1) NOT NULL,--����� ��� ���� (����/���)
    t_businessregistrationnumber VARCHAR2(10) NOT NULL,--����� ��Ϲ�ȣ
    t_establishmentdate          DATE DEFAULT sysdate NOT NULL,--������
    t_bank                       VARCHAR2(50) NOT NULL,--�ŷ� ����
    t_banknumber                 VARCHAR2(50) NOT NULL,--���¹�ȣ
    t_bankowner                  VARCHAR2(50) NOT NULL,--������
    t_businessregistrationimage  VARCHAR2(100) NOT NULL,--����ڵ���� �纻
    t_fileurl                    VARCHAR2(100) NOT NULL, --���� ��� 
    t_filename                   VARCHAR2(100) NOT NULL, --���� �̸� 
    t_auth                       VARCHAR2(10) NOT NULL, --�ش� ���� ���� ����
    t_agree                      NUMBER(1) NOT NULL--��� ���ǿ���
);

-- �ش� ȸ�� ������ ���� 
CREATE SEQUENCE tmember_seq START WITH 1 INCREMENT BY 1;

--PLAY(����) ���̺�
CREATE TABLE play (
    p_number                 NUMBER(38) NOT NULL, --���� ��ȣ
    p_name                   VARCHAR2(50) NOT NULL, --���ظ�
    p_startdate              DATE NOT NULL, --���� ������
    p_closedate              DATE NOT NULL, --���� ������
    p_runningtime            VARCHAR2(3) NOT NULL, --���� �ҿ�ð�(����Ÿ��)
    p_theatername            VARCHAR2(20) NOT NULL, --���� �̸�
    p_theateraddress         VARCHAR2(100) NOT NULL, --���� �ּ�
    p_theatermapurl     VARCHAR2(100) NOT NULL,--���� �൵ url
    p_agency                 VARCHAR2(20) NOT NULL, --��ȹ�� ����
    p_ratings                VARCHAR2(1) NOT NULL, --���� ���
    p_casting                VARCHAR2(2000) NOT NULL, --ĳ���� ������
    p_ticketopendate         DATE NOT NULL, --���� ���� �����
    p_plot                   VARCHAR2(4000) NOT NULL, --���� �ٰŸ�
    p_seatnumber             NUMBER(20) NOT NULL, --�¼� ����
    p_ticketprice            NUMBER(7) NOT NULL, --Ƽ�� ����
    p_genre                  VARCHAR2(1) NOT NULL, --�帣 ����
    p_posterurl         VARCHAR2(100) NOT NULL, --���� ������ url
    p_amendmentapproved      VARCHAR2(1), --���� ���� ���� ����
    p_registrationapproval   VARCHAR2(1), --���� ��� ���� ����
    p_firststarttime         VARCHAR2(10) NOT NULL, -- 1ȸ�� �� ���� �ð� 
    p_secondstarttime        VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 
    p_agree                  VARCHAR2(1) NOT NULL, --��� ���� ����
    t_number                 NUMBER(38) NOT NULL, --�ش� ȸ�� ��ȣ
    PRIMARY KEY ( p_number ),
    FOREIGN KEY ( t_number )
        REFERENCES tmember ( t_number )
);

>>>>>>> 47cb8d33ad98e3b2b45f3ef3745e999e5994231a
--���� ������ ���� 
CREATE SEQUENCE play_seq START WITH 1 INCREMENT BY 1;

--���� ���̺� ����
<<<<<<< HEAD
CREATE TABLE RESERVATION (
R_NUMBER NUMBER(38) NOT NULL PRIMARY KEY, -- ���Ź�ȣ
R_DATE DATE NOT NULL, -- ������
R_PAYSTATE VARCHAR2(10) NOT NULL, -- ���������� ����
R_FEE NUMBER(3) NOT NULL, -- ���� ������
R_CANCELSTATE VARCHAR2(10) NOT NULL, -- ���� ��� ����
R_CANCELDATE DATE, -- ���� �����
R_TICKETFIRST VARCHAR2(10) NOT NULL, -- Ƽ�Ϲ�ȣ1
R_TICKETSECOND VARCHAR2(10), -- Ƽ�Ϲ�ȣ2
R_TICKETTHIRD VARCHAR2(10), -- Ƽ�Ϲ�ȣ3
R_TICKETFORTH VARCHAR2(10), -- Ƽ�Ϲ�ȣ4
R_TOTALPAYMENT NUMBER(38) NOT NULL, -- ���� �Ѿ�
U_NUMBER NUMBER(38) NOT NULL, -- �Ϲ� ȸ�� ��ȣ
P_NUMBER NUMBER(38) NOT NULL, -- ���ع�ȣ

FOREIGN KEY(U_NUMBER) REFERENCES UMEMBER(U_NUMBER), -- �Ϲ� ȸ�� ��ȣ �ܷ�Ű ����
FOREIGN KEY(P_NUMBER) REFERENCES PLAY(P_NUMBER) -- ���� ��ȣ �ܷ�Ű ����
);
-- ���� ������ ����
CREATE SEQUENCE RESERVATION_SEQ
START WITH 1 INCREMENT BY 1;

--���� ���̺� ����
CREATE TABLE PAYMENT (
PAY_NUMBER NUMBER(38) NOT NULL PRIMARY KEY, -- ���� ��ȣ
PAY_CALCULATEDATE DATE NOT NULL, -- ���� ����
PAY_PAYDATE DATE NOT NULL, -- ������
PAY_PAYMENT NUMBER(20) NOT NULL, -- �ݾ�
P_NUMBER NUMBER(38) NOT NULL, -- ���� ��ȣ
R_NUMBER NUMBER(38) NOT NULL, -- ���� ��ȣ
T_NUMBER NUMBER(38) NOT NULL, -- �ش� ȸ�� ��ȣ

FOREIGN KEY(P_NUMBER) REFERENCES PLAY(P_NUMBER), -- ���� ��ȣ �ܷ�Ű ����
FOREIGN KEY(R_NUMBER) REFERENCES RESERVATION(R_NUMBER), -- ���� ��ȣ �ܷ�Ű ����
FOREIGN KEY(T_NUMBER) REFERENCES TMEMBER(T_NUMBER) -- �ش� ȸ�� ��ȣ �ܷ�Ű ����
);

-- ���� ������ ����
CREATE SEQUENCE PLAY_SEQ
START WITH 1 INCREMENT BY 1;

--�Ϲ�ȸ�� FAQ ���̺� ����
CREATE TABLE UFAQ(
UF_number number(38) not null, --�Խñ� ��ȣ/PK
UF_title varchar2(100) not null, -- �� ����
UF_content varchar2(4000) not null, -- �� ����
UF_date Date  not null, -- �����
primary key(UF_number)
=======
CREATE TABLE reservation (
    r_number       NUMBER(38) NOT NULL PRIMARY KEY, -- ���Ź�ȣ
    r_date         DATE NOT NULL, -- ������
    r_paystate     VARCHAR2(10) NOT NULL, -- ���������� ����
    r_fee          NUMBER(3) NOT NULL, -- ���� ������
    r_cancelstate  VARCHAR2(10) NOT NULL, -- ���� ��� ����
    r_canceldate   DATE, -- ���� �����
    r_ticketfirst  VARCHAR2(10) NOT NULL, -- Ƽ�Ϲ�ȣ1
    r_ticketsecond VARCHAR2(10), -- Ƽ�Ϲ�ȣ2
    r_ticketthird  VARCHAR2(10), -- Ƽ�Ϲ�ȣ3
    r_ticketforth  VARCHAR2(10), -- Ƽ�Ϲ�ȣ4
    r_totalpayment NUMBER(38) NOT NULL, -- ���� �Ѿ�
    u_number       NUMBER(38) NOT NULL, -- �Ϲ� ȸ�� ��ȣ
    p_number       NUMBER(38) NOT NULL, -- ���ع�ȣ

    FOREIGN KEY ( u_number )
        REFERENCES umember ( u_number ), -- �Ϲ� ȸ�� ��ȣ �ܷ�Ű ����
    FOREIGN KEY ( p_number )
        REFERENCES play ( p_number ) -- ���� ��ȣ �ܷ�Ű ����
);
-- ���� ������ ����
CREATE SEQUENCE reservation_seq START WITH 1 INCREMENT BY 1;

--���� ���̺� ����
CREATE TABLE payment (
    pay_number        NUMBER(38) NOT NULL PRIMARY KEY, -- ���� ��ȣ
    pay_calculatedate DATE NOT NULL, -- ���� ����
    pay_paydate       DATE NOT NULL, -- ������
    pay_payment       NUMBER(20) NOT NULL, -- �ݾ�
    p_number          NUMBER(38) NOT NULL, -- ���� ��ȣ
    r_number          NUMBER(38) NOT NULL, -- ���� ��ȣ
    t_number          NUMBER(38) NOT NULL, -- �ش� ȸ�� ��ȣ

    FOREIGN KEY ( p_number )
        REFERENCES play ( p_number ), -- ���� ��ȣ �ܷ�Ű ����
    FOREIGN KEY ( r_number )
        REFERENCES reservation ( r_number ), -- ���� ��ȣ �ܷ�Ű ����
    FOREIGN KEY ( t_number )
        REFERENCES tmember ( t_number ) -- �ش� ȸ�� ��ȣ �ܷ�Ű ����
);

-- ���� ������ ����
CREATE SEQUENCE payment_seq START WITH 1 INCREMENT BY 1;

--�Ϲ�ȸ�� FAQ ���̺� ����
CREATE TABLE ufaq (
    uf_number  NUMBER(38) NOT NULL, --�Խñ� ��ȣ/PK
    uf_title   VARCHAR2(100) NOT NULL, -- �� ����
    uf_content VARCHAR2(4000) NOT NULL, -- �� ����
    uf_date    DATE DEFAULT sysdate, -- �����
    PRIMARY KEY ( uf_number )
>>>>>>> 47cb8d33ad98e3b2b45f3ef3745e999e5994231a
);
--�Ϲ�ȸ�� FAQ ������ ����
CREATE SEQUENCE ufaq_seq START WITH 1 INCREMENT BY 1;


--�ش�ȸ�� FAQ ���̺� ����
<<<<<<< HEAD
CREATE TABLE TFAQ(
TF_number number(38) not null, --�Խñ� ��ȣ/PK
TF_title varchar2(100) not null, -- �� ����
TF_content varchar2(4000) not null, -- �� ����
TF_date Date not null, -- �����
primary key(TF_number)
=======
CREATE TABLE tfaq (
    tf_number  NUMBER(38) NOT NULL, --�Խñ� ��ȣ/PK
    tf_title   VARCHAR2(100) NOT NULL, -- �� ����
    tf_content VARCHAR2(4000) NOT NULL, -- �� ����
    tf_date    DATE DEFAULT sysdate, -- �����
    PRIMARY KEY ( tf_number )
>>>>>>> 47cb8d33ad98e3b2b45f3ef3745e999e5994231a
);
--�ش�ȸ�� FAQ ������ ����
CREATE SEQUENCE tfaq_seq START WITH 1 INCREMENT BY 1;

--�������� ���̺� ����
<<<<<<< HEAD
CREATE TABLE NOTICE(
N_number number(38) not null, --�Խñ� ��ȣ/PK
N_title varchar2(100) not null, -- �� ����
N_content varchar2(4000) not null, -- �� ����
N_date Date not null, -- �����
primary key(N_number)
=======
CREATE TABLE notice (
    n_number  NUMBER(38) NOT NULL, --�Խñ� ��ȣ/PK
    n_title   VARCHAR2(100) NOT NULL, -- �� ����
    n_content VARCHAR2(4000) NOT NULL, -- �� ����
    n_date    DATE DEFAULT sysdate, -- �����
    PRIMARY KEY ( n_number )
>>>>>>> 47cb8d33ad98e3b2b45f3ef3745e999e5994231a
);
--�������� ������ ����
CREATE SEQUENCE notice_seq START WITH 1 INCREMENT BY 1;