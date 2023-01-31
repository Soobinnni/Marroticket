--������ ���� ������ ������ ��
drop table payment purge;
drop table reservation purge;
drop table play purge;
drop table umember_auth purge;
drop table tmember_auth purge;
drop table umember purge;
drop table tmember purge;

--������ ��� ���� ���̺��
drop table tfaq purge;
drop table notice purge;
drop table ufaq purge;

--������ ����
drop sequence notice_seq;
drop sequence tfaq_seq;
drop sequence ufaq_seq;
drop sequence pay_seq;
drop sequence play_seq;
drop sequence reservation_seq;
drop sequence tmember_seq;
drop sequence umember_seq;

--�Ϲ� ȸ�� ���̺�
create table UMEMBER(
u_number number(38)NOT NULL primary KEY ,--�Ϲ� ȸ�� ��ȣ
u_id VARCHAR2(20) UNIQUE NOT NULL,--���̵�
u_password VARCHAR2(100) NOT NULL,--��й�ȣ
u_name VARCHAR2(20) NOT NULL ,--�̸�
u_phoneNumber VARCHAR2(11) NOT NULL,-- �Ϲ� ����� �޴���ȭ ��ȣ
u_birthday VARCHAR2(10) NOT NULL,--�������
u_gender VARCHAR2(10) NOT NULL,--����
u_email VARCHAR2(50) NOT NULL,--�̸���
u_joinDate date DEFAULT sysdate NOT NULL,--������
u_unjoin VARCHAR2(10),--Ż�𿩺�
u_unjoinDate date DEFAULT sysdate,--Ż����
u_genre VARCHAR2(1) NOT NULL,--���� �帣
u_agree VARCHAR2(1) NOT NULL--��� ���ǿ���
);

--�Ϲ� ȸ�� ������ ���� 
create sequence UMEMBER_seq
start with 1
increment by 1;

--�Ϲ� ȸ�� ���� ���̺�
CREATE TABLE umember_auth (
u_number NUMBER(5) NOT NULL,
u_auth VARCHAR2(50) NOT NULL,
FOREIGN KEY ( u_number ) REFERENCES umember ( u_number )
);

--�ش� ȸ�� ���̺�
create table TMEMBER(
t_number number(38)NOT NULL primary KEY,--�ش� ȸ�� ��ȣ
t_id VARCHAR2(20) UNIQUE NOT NULL,--���̵�
t_password VARCHAR2(100) NOT NULL,--��й���ȣ
t_name VARCHAR2(50) NOT NULL ,--�شܸ�
t_address VARCHAR2(100) NOT NULL,--�ش��ּ�
t_ownerName VARCHAR2(20) NOT NULL,--��ǥ�ڸ�
t_ownerPhoneNumber VARCHAR2(11) NOT NULL,--��ǥ�� �޴���ȭ��ȣ
t_ownerEmail VARCHAR2(50) NOT NULL,--��ǥ�� �̸���
t_businessRegistration VARCHAR2(1) NOT NULL,--����� ��� ���� (����/���)
t_businessRegistrationNumber VARCHAR2(10) NOT NULL,--����� ��Ϲ�ȣ
t_establishmentDate date DEFAULT sysdate NOT NULL,--������
t_bank VARCHAR2(50) NOT NULL,--�ŷ� ����
t_bankNumber VARCHAR2(50) NOT NULL,--���¹�ȣ
t_bankOwner VARCHAR2(50) NOT NULL,--������
t_businessRegistrationImage VARCHAR2(100) NOT NULL,--����ڵ���� �纻
t_auth  VARCHAR2(10) NOT NULL,--�ش� ȸ�� ����(���Խ��ο���/���Խ��οϷ�/�������
t_agree VARCHAR2(1) NOT NULL--��� ���ǿ���
);
-- �ش� ȸ�� ������ ���� 
create sequence TMEMBER_seq
start with 1
increment by 1;


--�ش� ȸ�� ���� ���̺�
CREATE TABLE tmember_auth (
t_number NUMBER(5) NOT NULL,
t_auth VARCHAR2(50) NOT NULL,
FOREIGN KEY ( t_number ) REFERENCES tmember ( t_number )
);


--PLAY(����) ���̺�
CREATE TABLE play (
    p_number                     NUMBER(38) NOT NULL, --���� ��ȣ
    p_name                       VARCHAR2(50) NOT NULL, --���ظ�
    p_startdate                  DATE NOT NULL, --���� ������
    p_closedate                  DATE NOT NULL, --���� ������
    p_runningtime                NUMBER(3) NOT NULL, --���� �ҿ�ð�(����Ÿ��)
    p_theatername                VARCHAR2(20) NOT NULL, --���� �̸�
    p_theateraddress             VARCHAR2(100) NOT NULL, --���� �ּ�
    p_theatermap                 VARCHAR2(100) NOT NULL, --���� �൵ �̹���
    p_agency                     VARCHAR2(20) NOT NULL, --��ȹ�� ����
    p_ratings                    NUMBER(1) NOT NULL, --���� ���
    p_casting                    VARCHAR2(2000) NOT NULL, --ĳ���� ������
    p_ticketopendate             DATE NOT NULL, --���� ���� �����
    p_plot                       VARCHAR2(4000) NOT NULL, --���� �ٰŸ�
    p_seattype                   VARCHAR2(10) NOT NULL, --�¼� ����
    p_seatnumber                 NUMBER(20) NOT NULL, --�¼� ����
    p_ticketprice                NUMBER(7) NOT NULL, --Ƽ�� ����
    p_genre                      NUMBER(1) NOT NULL, --�帣 ����
    p_poster                     VARCHAR2(100) NOT NULL, --���� ������
    p_amendmentapproved          NUMBER(1), --���� ���� ���� ����
    p_registrationapproval       NUMBER(1), --���� ��� ���� ����
    p_eachdateone                DATE NOT NULL, -- �� ��¥ 1
    p_eachdatetwo                DATE, -- �� ��¥ 2
    p_eachdatethree              DATE, -- �� ��¥ 3
    p_eachdatefour               DATE, -- �� ��¥ 4
    p_eachdatefive               DATE, -- �� ��¥ 5
    p_eachdatesix                DATE, -- �� ��¥ 6
    p_eachdateseven              DATE, -- �� ��¥ 7
    p_eachdateeight              DATE, -- �� ��¥ 8
    p_eachdatenine               DATE, -- �� ��¥ 9
    p_eachdateten                DATE, -- �� ��¥ 10
    p_eachdateeleven             DATE, -- �� ��¥ 11
    p_eachdatetwelve             DATE, -- �� ��¥ 12
    p_eachdatethirteen           DATE, -- �� ��¥ 13
    p_eachdatefourteen           DATE, -- �� ��¥ 14
    p_eachdatefifteen            DATE, -- �� ��¥ 15
    p_eachdatesixteen            DATE, -- �� ��¥ 16
    p_eachdateseventeen          DATE, -- �� ��¥ 17
    p_eachdateeighteen           DATE, -- �� ��¥ 18
    p_eachdatenineteen           DATE, -- �� ��¥ 19
    p_eachdatetwenty             DATE, -- �� ��¥ 20
    p_eachdatetwentyone          DATE, -- �� ��¥ 21
    p_eachdatetwentytwo          DATE, -- �� ��¥ 22
    p_eachdatetwentythree        DATE, -- �� ��¥ 23
    p_eachdatetwentyfour         DATE, -- �� ��¥ 24
    p_eachdatetwentyfive         DATE, -- �� ��¥ 25
    p_eachdatetwentysix          DATE, -- �� ��¥ 26
    p_eachdatetwentyseven        DATE, -- �� ��¥ 27
    p_eachdatetwentyeight        DATE, -- �� ��¥ 28
    p_eachdatetwentynine         DATE, -- �� ��¥ 29
    p_eachdatethirty             DATE, -- �� ��¥ 30
    p_eachdatethirtyone          DATE, -- �� ��¥ 31
    p_eachdatethirtytwo          DATE, -- �� ��¥ 32
    p_eachdatethirtythree        DATE, -- �� ��¥ 33
    p_eachdatethirtyfour         DATE, -- �� ��¥ 34
    p_eachdatethirtyfive         DATE, -- �� ��¥ 35
    p_eachdatethirtysix          DATE, -- �� ��¥ 36
    p_eachdatethirtyseven        DATE, -- �� ��¥ 37
    p_eachdatethirtyeight        DATE, -- �� ��¥ 38
    p_eachdatethirtynine         DATE, -- �� ��¥ 39
    p_eachdateforty              DATE, -- �� ��¥ 40
    p_eachdatefortyone           DATE, -- �� ��¥ 41
    p_eachdatefortytwo           DATE, -- �� ��¥ 42
    p_eachdatefortythree         DATE, -- �� ��¥ 43
    p_eachdatefortyfour          DATE, -- �� ��¥ 44
    p_eachdatefortyfive          DATE, -- �� ��¥ 45
    p_eachdatefortysix           DATE, -- �� ��¥ 46
    p_eachdatefortyseven         DATE, -- �� ��¥ 47
    p_eachdatefortyeight         DATE, -- �� ��¥ 48
    p_eachdatefortynine          DATE, -- �� ��¥ 49
    p_eachdatefifty              DATE, -- �� ��¥ 50
    p_eachdatefiftyone           DATE, -- �� ��¥ 51
    p_eachdatefiftytwo           DATE, -- �� ��¥ 52
    p_eachdatefiftythree         DATE, -- �� ��¥ 53
    p_eachdatefiftyfour          DATE, -- �� ��¥ 54
    p_eachdatefiftyfive          DATE, -- �� ��¥ 55
    p_eachdatefiftysix           DATE, -- �� ��¥ 56
    p_eachdatefiftyseven         DATE, -- �� ��¥ 57
    p_eachdatefiftyeight         DATE, -- �� ��¥ 58
    p_eachdatefiftynine          DATE, -- �� ��¥ 59
    p_eachdatesixty              DATE, -- �� ��¥ 60

    p_firststarttimeone          VARCHAR2(10) NOT NULL, -- 1ȸ�� �� ���� �ð� 1
    p_firststarttimetwo          VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 2
    p_firststarttimethree        VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 3
    p_firststarttimefour         VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 4
    p_firststarttimefive         VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 5
    p_firststarttimesix          VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 6
    p_firststarttimeseven        VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 7
    p_firststarttimeeight        VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 8
    p_firststarttimenine         VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 9
    p_firststarttimeten          VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 10
    p_firststarttimeeleven       VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 11
    p_firststarttimetwelve       VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 12
    p_firststarttimethirteen     VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 13
    p_firststarttimefourteen     VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 14
    p_firststarttimefifteen      VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 15
    p_firststarttimesixteen      VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 16
    p_firststarttimeseventeen    VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 17
    p_firststarttimeeighteen     VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 18
    p_firststarttimenineteen     VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 19
    p_firststarttimetwenty       VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 20
    p_firststarttimetwentyone    VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 21
    p_firststarttimetwentytwo    VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 22
    p_firststarttimetwentythree  VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 23
    p_firststarttimetwentyfour   VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 24
    p_firststarttimetwentyfive   VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 25
    p_firststarttimetwentysix    VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 26
    p_firststarttimetwentyseven  VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 27
    p_firststarttimetwentyeight  VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 28
    p_firststarttimetwentynine   VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 29
    p_firststarttimethirty       VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 30
    p_firststarttimethirtyone    VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 31
    p_firststarttimethirtytwo    VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 32
    p_firststarttimethirtythree  VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 33
    p_firststarttimethirtyfour   VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 34
    p_firststarttimethirtyfive   VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 35
    p_firststarttimethirtysix    VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 36
    p_firststarttimethirtyseven  VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 37
    p_firststarttimethirtyeight  VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 38
    p_firststarttimethirtynine   VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 39
    p_firststarttimeforty        VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 40
    p_firststarttimefortyone     VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 41
    p_firststarttimefortytwo     VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 42
    p_firststarttimefortythree   VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 43
    p_firststarttimefortyfour    VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 44
    p_firststarttimefortyfive    VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 45
    p_firststarttimefortysix     VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 46
    p_firststarttimefortyseven   VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 47
    p_firststarttimefortyeight   VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 48
    p_firststarttimefortynine    VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 49
    p_firststarttimefifty        VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 50
    p_firststarttimefiftyone     VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 51
    p_firststarttimefiftytwo     VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 52
    p_firststarttimefiftythree   VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 53
    p_firststarttimefiftyfour    VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 54
    p_firststarttimefiftyfive    VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 55
    p_firststarttimefiftysix     VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 56
    p_firststarttimefiftyseven   VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 57
    p_firststarttimefiftyeight   VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 58
    p_firststarttimefiftynine    VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 59
    p_firststarttimesixty        VARCHAR2(10), -- 1ȸ�� �� ���� �ð� 60
    p_secondstarttimeone         VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 1
    p_secondstarttimetwo         VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 2
    p_secondstarttimethree       VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 3
    p_secondstarttimefour        VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 4
    p_secondstarttimefive        VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 5
    p_secondstarttimesix         VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 6
    p_secondstarttimeseven       VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 7
    p_secondstarttimeeight       VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 8
    p_secondstarttimenine        VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 9
    p_secondstarttimeten         VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 10
    p_secondstarttimeeleven      VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 11
    p_secondstarttimetwelve      VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 12
    p_secondstarttimethirteen    VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 13
    p_secondstarttimefourteen    VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 14
    p_secondstarttimefifteen     VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 15
    p_secondstarttimesixteen     VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 16
    p_secondstarttimeseventeen   VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 17
    p_secondstarttimeeighteen    VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 18
    p_secondstarttimenineteen    VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 19
    p_secondstarttimetwenty      VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 20
    p_secondstarttimetwentyone   VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 21
    p_secondstarttimetwentytwo   VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 22
    p_secondstarttimetwentythree VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 23
    p_secondstarttimetwentyfour  VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 24
    p_secondstarttimetwentyfive  VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 25
    p_secondstarttimetwentysix   VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 26
    p_secondstarttimetwentyseven VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 27
    p_secondstarttimetwentyeight VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 28
    p_secondstarttimetwentynine  VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 29
    p_secondstarttimethirty      VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 30
    p_secondstarttimethirtyone   VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 31
    p_secondstarttimethirtytwo   VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 32
    p_secondstarttimethirtythree VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 33
    p_secondstarttimethirtyfour  VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 34
    p_secondstarttimethirtyfive  VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 35
    p_secondstarttimethirtysix   VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 36
    p_secondstarttimethirtyseven VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 37
    p_secondstarttimethirtyeight VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 38
    p_secondstarttimethirtynine  VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 39
    p_secondstarttimeforty       VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 40
    p_secondstarttimefortyone    VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 41
    p_secondstarttimefortytwo    VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 42
    p_secondstarttimefortythree  VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 43
    p_secondstarttimefortyfour   VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 44
    p_secondstarttimefortyfive   VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 45
    p_secondstarttimefortysix    VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 46
    p_secondstarttimefortyseven  VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 47
    p_secondstarttimefortyeight  VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 48
    p_secondstarttimefortynine   VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 49
    p_secondstarttimefifty       VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 50
    p_secondstarttimefiftyone    VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 51
    p_secondstarttimefiftytwo    VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 52
    p_secondstarttimefiftythree  VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 53
    p_secondstarttimefiftyfour   VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 54
    p_secondstarttimefiftyfive   VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 55
    p_secondstarttimefiftysix    VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 56
    p_secondstarttimefiftyseven  VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 57
    p_secondstarttimefiftyeight  VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 58
    p_secondstarttimefiftynine   VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 59
    p_secondstarttimesixty       VARCHAR2(10), -- 2ȸ�� �� ���� �ð� 60
    p_seatcolumn                 NUMBER(2), --�¼� ���ο�
    p_seatrow                    NUMBER(2), --�¼� ������
    p_agree                      NUMBER(1) NOT NULL, --��� ���� ����
    t_number                     NUMBER(38) NOT NULL, --�ش� ȸ�� ��ȣ
    PRIMARY KEY ( p_number ),
    FOREIGN KEY ( t_number ) REFERENCES tmember ( t_number )
);

--���� ������ ���� 
CREATE SEQUENCE play_seq START WITH 1 INCREMENT BY 1;


--���� ���̺� ����
CREATE TABLE RESERVATION (
R_NUMBER NUMBER(38) NOT NULL PRIMARY KEY, -- ���Ź�ȣ
R_DATE DATE default sysdate NOT NULL, -- ������
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
PAY_CALCULATE DATE DEFAULT sysDate NOT NULL, -- ���� ����
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
CREATE SEQUENCE PAY_SEQ
START WITH 1 INCREMENT BY 1;

--�Ϲ�ȸ�� FAQ ���̺� ����
CREATE TABLE UFAQ(
UF_number number(38) not null, --�Խñ� ��ȣ/PK
UF_title varchar2(100) not null, -- �� ����
UF_content varchar2(4000) not null, -- �� ����
UF_date Date DEFAULT sysdate  not null, -- �����
primary key(UF_number)
);
--�Ϲ�ȸ�� FAQ ������ ����
CREATE SEQUENCE ufaq_seq START WITH 1 INCREMENT BY 1;


--�ش�ȸ�� FAQ ���̺� ����
CREATE TABLE TFAQ(
TF_number number(38) not null, --�Խñ� ��ȣ/PK
TF_title varchar2(100) not null, -- �� ����
TF_content varchar2(4000) not null, -- �� ����
TF_date Date DEFAULT sysdate not null, -- �����
primary key(TF_number)
);
--�ش�ȸ�� FAQ ������ ����
CREATE SEQUENCE tfaq_seq START WITH 1 INCREMENT BY 1;

--�������� ���̺� ����
CREATE TABLE NOTICE(
N_number number(38) not null, --�Խñ� ��ȣ/PK
N_title varchar2(100) not null, -- �� ����
N_content varchar2(4000) not null, -- �� ����
N_date Date DEFAULT sysdate not null, -- �����
primary key(N_number)
);
--�������� ������ ����
CREATE SEQUENCE notice_seq START WITH 1 INCREMENT BY 1;