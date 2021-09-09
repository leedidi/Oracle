SELECT USER
FROM DUAL;
--==>> HR

--���� ���� �ǽ� ���� ����--

-- HR ���� ��Ű�� ERD �� �̿��� ���̺� �籸��~!!!

-- ������... HR ��Ű���� �ִ� �⺻ ���̺� (7��)
-- COUNTRIES / DEPARTMENTS / EMPLOYEES / JOBS / JOB_HISTORY / LOCATIONS / REGIONS
-- �� ��~~~���� ���� �����Ѵ�.

-- ��, �����ϴ� ���̺��� �̸��� �����̺��+����ȣ��
-- ex) 1���� ���...
-- COUNTRIES01 / DEPARTMENTS01 / EMPLOYEES01 / JOBS01 / JOB_HISTORY01 / LOCATIONS01 / REGIONS01
-- ....
-- �� ���� �����Ѵ�.

-- 1. ���� ���̺��� ���� ����
-- 2. ���̺� ����(�÷� �̸�, �ڷ���, DEFAULT ǥ����, NOT NULL �� ....)
--    �������� ����(PK, UK, FK, CK, ... NN)
-- 3. �ۼ� �� ������ �Է�
-- 4. ���� �׸�
--    20210909_02_hr_�����ǽ�����_3��.sql
--    �ı�_0��.txt
--@   ������ �ΰ� ����... �ı⿡�� ��� �������� �ıⰡ ��� �־�� ��

SELECT *
FROM JOB_HISTORY;

==



SELECT  *
FROM TAB;


SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME IN ('COUNTRIES', 'DEPARTMENTS', 'EMPLOYEES', 'JOBS', 'JOB_HISTORY', 'LOCATIONS', 'REGIONS');

SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME IN ('JOB_HISTORY');


DESC COUNTRIES;
DESC DEPARTMENTS;
DESC EMPLOYEES;
DESC JOBS;
DESC JOB_HISTORY;
DESC LOCATIONS;
DESC REGIONS;


-- MODIFY ��� ADD�� �ؼ� ����ǥ �߰�!!

-- JOB_HISTORY


�̸�, ��, ����, 



�÷���       ��       ������Ÿ��  �����̸�      ���̺��  KEY  �÷��̸�    �� ����
REGION_ID   NOT NULL NUMBER      REGION_ID_NN   REGIONS	    C	REGION_ID	"REGION_ID" IS NOT NULL	
REGION_NAME          VARCHAR2(25)REG_ID_PK      REGIONS	    P	REGION_ID



--- JOB_HISTORY
�÷���          ��      ������Ÿ��   �����̸�               ���̺��          KEY      �÷��̸�        üũ ����
------------- -------- ------------  ---------             ----------      --------   ----------      -----------
EMPLOYEE_ID   NOT NULL NUMBER(6)    JHIST_EMP_FK            JOB_HISTORY      R          EMPLOYEE_ID      (null)
EMPLOYEE_ID   NOT NULL NUMBER(6)    JHIST_EMPLOYEE_NN       JOB_HISTORY      C          EMPLOYEE_ID      (null)
EMPLOYEE_ID   NOT NULL NUMBER(6)    JHIST_EMP_ID_ST_DATE_PK JOB_HISTORY      P         EMPLOYEE_ID       "EMPLOYEE_ID" IS NOT NULL

START_DATE    NOT NULL DATE         JHIST_EMP_ID_ST_DATE_PK JOB_HISTORY      P         START_DATE        (null)
START_DATE    NOT NULL DATE         JHIST_START_DATE_NN     JOB_HISTORY      C         START_DATE         "START_DATE" IS NOT NULL
START_DATE    NOT NULL DATE         JHIST_DATE_INTERVAL     JOB_HISTORY      C         START_DATE        end_date > start_date

END_DATE      NOT NULL DATE         JHIST_END_DATE_NN       JOB_HISTORY      C          END_DATE         "END_DATE" IS NOT NULL
END_DATE      NOT NULL DATE         JHIST_DATE_INTERVAL     JOB_HISTORY      C          END_DATE          end_date > start_date

JOB_ID        NOT NULL VARCHAR2(10) JHIST_JOB_NN            JOB_HISTORY      C          JOB_ID            "JOB_ID" IS NOT NULL
JOB_ID        NOT NULL VARCHAR2(10) JHIST_JOB_FK            JOB_HISTORY      R          JOB_ID             (null)

DEPARTMENT_ID          NUMBER(4)   JHIST_DEPT_FK            JOB_HISTORY      R       DEPARTMENT_ID       (null)


SELECT *
FROM JOB_HISTORY;


-- JOB_ID
-- ���̺� ����
CREATE TABLE TBL_TEST1
( COL1 NUMBER(5)        PRIMARY KEY
, COL2 VARCHAR2(30)
);

--JOB_HISTORY
CREATE TABLE JOB_HISTORY
( EMPLOYEE_ID   NUMBER(6)    
, START_DATE    DATE
, END_DATE      DATE
, JOB_ID        VARCHAR2(10)
, DEPARTMENT_ID NUMBER(4)
);

ALTER TABLE JOB_HISTORY
ADD CONSTRAINT JHIST_EMP_ID_ST_DATE_PK PRIMARY KEY(EMPLOYEE_ID);

--COUNTR03_REG_FK
-- 1. ���� ���� ���̺� ���� �����ϰ�
-- 2. ���̺� ���� ���� �ۼ�
-- 3. �� ���̺��� INSERT ���� �ۼ�

--�ϴ� ������, ���൵ ������ ����! �ۼ��� �ϱ� ������ INSERT��..!
-- TEST13_COL1_XXXX
-- TEST1303_COL1_XXXX
-- C�� üũ!