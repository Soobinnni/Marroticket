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
--���� ������ ���� 
CREATE SEQUENCE play_seq START WITH 1 INCREMENT BY 1;

--���� ���̺� ����
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
);
--�Ϲ�ȸ�� FAQ ������ ����
CREATE SEQUENCE ufaq_seq START WITH 1 INCREMENT BY 1;


--�ش�ȸ�� FAQ ���̺� ����
CREATE TABLE TFAQ(
TF_number number(38) not null, --�Խñ� ��ȣ/PK
TF_title varchar2(100) not null, -- �� ����
TF_content varchar2(4000) not null, -- �� ����
TF_date Date not null, -- �����
primary key(TF_number)
);
--�ش�ȸ�� FAQ ������ ����
CREATE SEQUENCE tfaq_seq START WITH 1 INCREMENT BY 1;

--�������� ���̺� ����
CREATE TABLE NOTICE(
N_number number(38) not null, --�Խñ� ��ȣ/PK
N_title varchar2(100) not null, -- �� ����
N_content varchar2(4000) not null, -- �� ����
N_date Date not null, -- �����
primary key(N_number)
);
--�������� ������ ����
CREATE SEQUENCE notice_seq START WITH 1 INCREMENT BY 1;