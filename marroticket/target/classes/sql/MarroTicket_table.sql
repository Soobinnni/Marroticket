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

--���� ������ ���� 
CREATE SEQUENCE play_seq START WITH 1 INCREMENT BY 1;

--���� ���̺� ����
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
);
--�Ϲ�ȸ�� FAQ ������ ����
CREATE SEQUENCE ufaq_seq START WITH 1 INCREMENT BY 1;


--�ش�ȸ�� FAQ ���̺� ����
CREATE TABLE tfaq (
    tf_number  NUMBER(38) NOT NULL, --�Խñ� ��ȣ/PK
    tf_title   VARCHAR2(100) NOT NULL, -- �� ����
    tf_content VARCHAR2(4000) NOT NULL, -- �� ����
    tf_date    DATE DEFAULT sysdate, -- �����
    PRIMARY KEY ( tf_number )
);
--�ش�ȸ�� FAQ ������ ����
CREATE SEQUENCE tfaq_seq START WITH 1 INCREMENT BY 1;

--�������� ���̺� ����
CREATE TABLE notice (
    n_number  NUMBER(38) NOT NULL, --�Խñ� ��ȣ/PK
    n_title   VARCHAR2(100) NOT NULL, -- �� ����
    n_content VARCHAR2(4000) NOT NULL, -- �� ����
    n_date    DATE DEFAULT sysdate, -- �����
    PRIMARY KEY ( n_number )
);
--�������� ������ ����
CREATE SEQUENCE notice_seq START WITH 1 INCREMENT BY 1;