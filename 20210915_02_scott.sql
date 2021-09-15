SELECT USER
FROM DUAL;
--==>> SCOTT

--�� ������ �Լ�(FN_GENDER())�� ����� �۵��ϴ����� ���� Ȯ��
SELECT NAME, SSN, FN_GENDER(SSN)"�Լ�ȣ����"
FROM TBL_INSA;
--==>>
/*
ȫ�浿	771212-1022432	����
�̼���	801007-1544236	����
�̼���	770922-2312547	����
������	790304-1788896	����
�Ѽ���	811112-1566789	����
�̱���	780505-2978541	����
����ö	780506-1625148	����
�迵��	821011-2362514	����
������	810810-1552147	����
������	751010-1122233	����
������	801010-2987897	����
���ѱ�	760909-1333333	����
���̼�	790102-2777777	����
Ȳ����	810707-2574812	����
������	800606-2954687	����
�̻���	781010-1666678	����
�����	820507-1452365	����
�̼���	801028-1849534	����
�ڹ���	780710-1985632	����
������	800304-2741258	����
ȫ�泲	801010-1111111	����
�̿���	800501-2312456	����
���μ�	731211-1214576	����
�踻��	830225-2633334	����
�����	801103-1654442	����
�����	810907-2015457	����
�迵��	801216-1898752	����
�̳���	810101-1010101	����
�踻��	800301-2020202	����
������	790210-2101010	����
����ȯ	771115-1687988	����
�ɽ���	810206-2222222	����
��̳�	780505-2999999	����
������	820505-1325468	����
������	831010-2153252	����
���翵	701126-2852147	����
�ּ���	770129-1456987	����
���μ�	791009-2321456	����
������	800504-2000032	����
�ڼ���	790509-1635214	����
�����	721217-1951357	����
ä����	810709-2000054	����
��̿�	830504-2471523	����
����ȯ	820305-1475286	����
ȫ����	690906-1985214	����
����	760105-1458752	����
�긶��	780505-1234567	����
�̱��	790604-1415141	����
�̹̼�	830908-2456548	����
�̹���	810403-2828287	����
�ǿ���	790303-2155554	����
�ǿ���	820406-2000456	����
��̽�	800715-1313131	����
����ȣ	810705-1212141	����
���ѳ�	820506-2425153	����
������	800605-1456987	����
�̹̰�	780406-2003214	����
�����	800709-1321456	����
�Ӽ���	810809-2121244	����
��ž�	810809-2111111	����
*/

--�� ������ �Լ�(FN_POW())�� ����� �۵��ϴ����� ���� Ȯ��
SELECT FN_POW(10,3)"�Լ�ȣ����"
FROM DUAL;
--==>> 1000

SELECT FN_POW(2,8)"�Լ�ȣ����"
FROM DUAL;
--==>> 256

SELECT FN_POW(3,3)"�Լ�ȣ����"
FROM DUAL;
--==>> 27


-- ���ν��� ���� �ǽ�

-- �ǽ� ���̺� ����(TBL_STUDENTS)

-- �ǽ� ���̺� ����(TBL_STUDENTS)
CREATE TABLE TBL_STUDENTS
( ID    VARCHAR2(10)
, NAME  VARCHAR2(40)
, TEL   VARCHAR2(20)
, ADDR  VARCHAR2(100)
);
--==>> Table TBL_STUDENTS��(��) �����Ǿ����ϴ�.
--@ PLSQL������ ������Ƽ� �����ؾ��ϴ°� ����...! �ƴϰ� ��ü�ع����� �� ������ ��ü �ԷµǴ°� ��׷���
--@ ���̺� �� ���κ� �ٽ� �����ؾ���!

-- �ǽ� ���̺� ����
CREATE TABLE TBL_IDPW
( ID    VARCHAR2(10)
, PW    VARCHAR2(20)
, CONSTRAINT IDPW_ID_PK PRIMARY KEY(ID)
);
--==>> Table TBL_IDPW��(��) �����Ǿ����ϴ�.

-- �� ���̺��� ������ �Է�
INSERT INTO TBL_STUDENTS(ID, NAME, TEL, ADDR)
VALUES('superman', '�չ���', '010-1111-1111', '���� ������...');
INSERT INTO TBL_IDPW(ID, PW)
VALUES('superman', 'java006$');
--==>> 1 �� ��(��) ���ԵǾ����ϴ�. *2

SELECT *
FROM TBL_STUDENTS;
--==>> superman	�չ���	010-1111-1111	���� ������...

SELECT *
FROM TBL_IDPW;
--==>> superman	java006$

-- ���� ������ ���ν���(INSERT ���ν���, �Է� ���ν���)�� �����ϰ� �Ǹ�
EXEC PRC_STUDENTS_INSERT('batman', 'java006$', '���ش�', '010-2222-2222', '��⵵ �����');
-- �̿� ���� ���� �� �ٷ� ���� ���̺��� �����͸� ��� ����� �Է��� �� �ִ�.


DESC TBL_STUDENTS;
DESC TBL_IDPW;

--�� ������ ���ν���(PRC_STUDENTS_INSERT()) �� ����� �۵��ϴ����� ���� Ȯ��
--   �� ���ν��� ȣ��
EXEC PRC_STUDENTS_INSERT('batman', 'java006$', '���ش�', '010-2222-2222', '��⵵ �����');
--==>> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.


SELECT *
FROM TBL_STUDENTS;
--==>>
/*
superman	�չ���	010-1111-1111	���� ������...
batman	���ش�	010-2222-2222	��⵵ �����
*/

SELECT *
FROM TBL_IDPW;
--==>>
/*
superman	java006$
batman	java006$
*/
-->>> �ٽ� Ȯ��,,,,^^,,,,, -> Ȯ�� �Ϸ�!
--@ ���縵 ����!!!! ���縵 �� Ȯ��,,,,^^!!

--�� �й�, �̸�, ��������, ��������, �������� �����͸�
--   �Է¹��� �� �ִ� �ǽ� ���̺� ����(TBL_SUNGJUK)
CREATE TABLE TBL_SUNGJUK
( HAKBUN    NUMBER
, NAME      VARCHAR2(40)
, KOR       NUMBER(3)
, ENG       NUMBER(3)
, MAT       NUMBER(3)
, CONSTRAINT SUNGJUK_HAKBUN_PK PRIMARY KEY(HAKBUN)
);
--==>> Table TBL_SUNGJUK��(��) �����Ǿ����ϴ�.


--@ ���� �÷��� ���� ���� �ִ� ������� ����� �÷�ȭ��Ű�� �� ��!!
--@ EX> ����, ���....

--�� ������ ���̺��� �÷� ���� �߰�
--   (������TOT, ��ա�AVG, ��ޡ�GRADE)
ALTER TABLE TBL_SUNGJUK
ADD( TOT NUMBER(3), AVG NUMBER(4,1), GRADE CHAR);
--==>> Table TBL_SUNGJUK��(��) ����Ǿ����ϴ�.

-- �� ���⼭ �߰��� �÷��� ���� �׸����
--    ���ν��� �ǽ��� ���� �߰��� ���� ��
--    ���� ���̺� ������ ����������, �ٶ��������� ���� �����̴�.

--�� ����� ���̺��� ���� Ȯ��
DESC TBL_SUNGJUK;
--==>>
/*
�̸�     ��?       ����           
------ -------- ------------ 
HAKBUN NOT NULL NUMBER       
NAME            VARCHAR2(40) 
KOR             NUMBER(3)    
ENG             NUMBER(3)    
MAT             NUMBER(3)    
TOT             NUMBER(3)    
AVG             NUMBER(4,1)  
GRADE           CHAR(1)      
*/

--�� ������ ���ν���(PRC_SUNGJUK_INSERT()) �� ����� �۵��ϴ����� ���� Ȯ��
--   �� ���ν��� ȣ��
EXEC PRC_SUNGJUK_INSERT(1, '������', 90, 80, 70);
--==>> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.
-- STUDENT�� �־���ȴµ�,,,^^�� �̵� ������ ����

SELECT *
FROM TBL_SUNGJUK;
--==>> 1	������	90	80	70	240	80	B

EXEC PRC_SUNGJUK_INSERT(2, '��ҿ�', 98, 88, 77);
--==>> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.

SELECT *
FROM TBL_SUNGJUK;
--==>>
/*
1	������	90	80	70	240	80	    B
2	��ҿ�	98	88	77	263	87.7	B
*/

/*
-- �����غ���...
EXEC PRC_SUNGJUK_UPDATE(2, 100, 100, 100);
--==>>
1	������	90	80	70	240	80	B
2	��ҿ�	100	100	100	300	100	A
*/

--�� ������ ���ν���(PRC_SUNGJUK_INSERT()) �� ����� �۵��ϴ����� ���� Ȯ��
--   �� ���ν��� ȣ��
EXEC PRC_SUNGJUK_UPDATE(2, 100, 100, 100);
--==>> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.

SELECT *
FROM TBL_SUNGJUK;
--==>>
/*
1	������	90	80	70	240	80	B
2	��ҿ�	100	100	100	300	100	A
*/

EXEC PRC_SUNGJUK_UPDATE(1, 55, 66, 77);
--==>> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.

SELECT *
FROM TBL_SUNGJUK;
--==>>
/*
1	������	55	66	77	198	66	D
2	��ҿ�	100	100	100	300	100	A
*/

SELECT *
FROM TBL_STUDENTS;

SELECT *
FROM TBL_IDPW;

--�� �߸� �Է��� �� ����
/*
DELETE
FROM TBL_STUDENTS
WHERE ID='1';

DELETE
FROM TBL_IDPW
WHERE ID='1';
*/

--�� ���� �ۼ��� �ڵ� Ȯ��
/*
DESC TBL_STUDENTS;

EXEC PRC_STUDENTS_UPDATE('superman', 'java006$', '010-9999-9999', '��õ');
--==>> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.

SELECT *
FROM TBL_STUDENTS;
--==>> superman	�չ���	010-9999-9999	��õ
*/

/*
SELECT I.ID, I.PW, S.TEL, S.ADDR
FROM TBL_IDPW I JOIN TBL_STUDETS S
ON I.ID = S.ID;
*/
--> ����ȴ� Ȯ���غ���

SELECT I.ID, I.PW, S.TEL, S.ADDR
FROM TBL_IDPW I JOIN TBL_STUDENTS S
ON I.ID = S.ID;
--> ���డ��!

(SELECT I.ID, I.PW, S.TEL, S.ADDR
FROM TBL_IDPW I JOIN TBL_STUDENTS S
ON I.ID = S.ID) T;


--�� ���ν��� ȣ�� ���� ���� ������ Ȯ��

SELECT *
FROM TBL_STUDENTS;
--==>>
/*
superman	�չ���	010-1111-1111	���� ������...
batman	    ���ش�	010-2222-2222	��⵵ �����
*/

SELECT *
FROM TBL_IDPW;
--==>>
/*
superman	java006$
batman	    java006$
*/

--�� ������ ���ν���(PRC_SUNGJUK_INSERT()) �� ����� �۵��ϴ����� ���� Ȯ��
--   �� ���ν��� ȣ��
EXEC PRC_STUDENTS_UPDATE('superman', 'java001', '010-9999-9999', '��õ')
--> �н����� ���� ����
--==>> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.

SELECT *
FROM TBL_STUDENTS;
--==>>
/*
superman	�չ���	010-1111-1111	���� ������...
batman	    ���ش�	010-2222-2222	��⵵ �����
*/

EXEC PRC_STUDENTS_UPDATE('superman', 'java006$', '010-9999-9999', '��õ')
--> ��ȿ�� �н�����
--==>> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.

SELECT *
FROM TBL_STUDENTS;
--==>>
/*
superman	�չ���	010-9999-9999	��õ
batman	    ���ش�	010-2222-2222	��⵵ �����
*/

SELECT *
FROM TBL_INSA;

DESC TBL_INSA;







