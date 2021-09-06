SELECT USER
FROM DUAL;
--==>> SCOTT

--�� ����
-- TBL_SWAON ���̺��� Ȱ���Ͽ� ������ ���� �׸���� ��ȸ�Ѵ�.
-- �����ȣ, �����, �ֹι�ȣ, ����, ���糪��, �Ի���
-- , ����������, �ٹ��ϼ�, �����ϼ�, �޿�, ���ʽ�

-- ��, ���糪�̴� �ѱ����� ������ ���� ������ �����Ѵ�. (�¾�� �⺻ �� �� ����)
-- ����, ������������ �ش� ������ ���̰� �ѱ����̷� 60���� �Ǵ� ��(����)��
-- �� ������ �Ի� ��, �Ϸ� ������ �����Ѵ�.
-- �׸���, ���ʽ��� 1000�� �̻� 2000�� �̸� �ٹ��� �����
-- �� ����� ���� �޿� ���� 30% ����,
-- 2000�� �̻� �ٹ��� �����
-- �� ����� ���� �޿� ���� 50% ������ �� �� �ֵ��� ó���Ѵ�.

--@ ���������� : �� ����� 60���� �Ǵ� �ذ� 2050��... 2050-01-03�Ϸ� ����� �ϱ�. 
--@ �����ϼ��� ����ϱ��� ��ĥ ���Ҵ���... ���ʽ��� �ٹ��ϼ��� ����.
--@ �� ���̴�..... ���......
--�� ���� ���� �ڵ� 
/*
SELECT *
FROM TBL_SAWON;

SELECT �����ȣ, �����, �ֹι�ȣ, ����, ���糪��, �Ի���, ����������, �ٹ��ϼ�, �����ϼ�, �޿�, ���ʽ�
FROM TBL_SAWON;

SELECT SANO "�����ȣ", SANAME "�����" , JUBUN "�ֹι�ȣ" 
        , ����, ���糪��, HIREDATE "�Ի���", ����������, �ٹ��ϼ�, �����ϼ�, SAL "�޿�", ���ʽ�
FROM TBL_SAWON;

--�� ���� : �ֹι�ȣ 7��° �ڸ��� 2,4 �� ����, 1,3 �̶�� ����
SELECT CASE WHEN SUBSTR(JUBUN, 7, 1) = '2' OR SUBSTR(JUBUN, 7, 1) = '4' THEN '����' 
            WHEN SUBSTR(JUBUN, 7, 1) = '1' OR SUBSTR(JUBUN, 7, 1) = '3' THEN '����'
            ELSE '�����̻�'
            END "����"
--FROM TBL_SAWON;

--�� ���� ���� : ���� �⵵ - �ֹε�Ϲ�ȣ �� ���ڸ� �� ���� �̿��� �¾ �⵵ ����
-- �ֹ� �� ���ڸ� ���� 0�̸� 20XX... ������ ��쿡�� 19XX...

--���� �⵵
--TO_CHAR(SYSDATE, 'YYYY')
SELECT EXTRACT(YEAR FROM SYSDATE)
FROM DUAL;

SELECT CASE WHEN SUBSTR(JUBUN, 1,1) = '0' THEN EXTRACT(YEAR FROM SYSDATE) - (2000+(�ֹι�ȣ ���ڸ� �ΰ�))
            ELSE ���� �⵵ - (1900+(�ֹι�ȣ ���ڸ� �ΰ�))
            END "���糪��";

SELECT CASE WHEN SUBSTR(JUBUN, 1,1) = '0' THEN EXTRACT(YEAR FROM SYSDATE) - (2000 + TO_NUMBER(SUBSTR(JUBUN,1,2))) + 1
            ELSE EXTRACT(YEAR FROM SYSDATE) - (1900 + TO_NUMBER(SUBSTR(JUBUN,1,2))) + 1
            END "���糪��"
FROM TBL_SAWON;

SELECT SANO "�����ȣ", SANAME "�����" , JUBUN "�ֹι�ȣ" 
        , CASE WHEN SUBSTR(JUBUN, 7, 1) = '2' OR SUBSTR(JUBUN, 7, 1) = '4' THEN '����' 
            WHEN SUBSTR(JUBUN, 7, 1) = '1' OR SUBSTR(JUBUN, 7, 1) = '3' THEN '����'
            ELSE '�����̻�'
            END "����"
            
        , CASE WHEN SUBSTR(JUBUN, 1,1) = '0' THEN EXTRACT(YEAR FROM SYSDATE) - (2000 + TO_NUMBER(SUBSTR(JUBUN,1,2))) + 1
            ELSE EXTRACT(YEAR FROM SYSDATE) - (1900 + TO_NUMBER(SUBSTR(JUBUN,1,2))) + 1
            END "���糪��"
            */
        /*CASE WHEN ������ 60���� �Ǹ�... THEN HIREDATE�� �ش� �⵵�� ����
            ELSE 
            END "����������"*/
        /*CASE WHEN 60-���糪�� THEN HIREDATE�� �ش� �⵵�� ����
            ELSE 
            END "����������"*/
            
            -- (60 - "���糪��") -> �� �⵵�� HIREDATE �⵵�� ���ϸ� ��....
            -- TO_DATE(HIREDATE, 'YY-MM-DD') HIREDATE 99..11
            /*
        , CASE WHEN SUBSTR(JUBUN, 1,1) = '0' THEN 2021 + 60 - (EXTRACT(YEAR FROM SYSDATE) - (2000 + TO_NUMBER(SUBSTR(JUBUN,1,2))) + 1)
            ELSE 2021 + 60 - (EXTRACT(YEAR FROM SYSDATE) - (1900 + TO_NUMBER(SUBSTR(JUBUN,1,2))) + 1)
            END "���������ϳ⵵"
            
        , CASE WHEN SUBSTR(JUBUN, 1,1) = '0' THEN 60 - (EXTRACT(YEAR FROM SYSDATE) - (2000 + TO_NUMBER(SUBSTR(JUBUN,1,2))) + 1)
            ELSE 60 - (EXTRACT(YEAR FROM SYSDATE) - (1900 + TO_NUMBER(SUBSTR(JUBUN,1,2))) + 1)
            END "��������������"
            */
            -- SYSDATE + TO_YMINTERVAL('01-02')
           /*
         , CASE WHEN SUBSTR(JUBUN, 1,1) = '0' THEN ADD_MONTHS(HIREDATE, (60 - (EXTRACT(YEAR FROM SYSDATE) - (2000 + TO_NUMBER(SUBSTR(JUBUN,1,2))) + 1)) * 12)
            ELSE 60 - (EXTRACT(YEAR FROM SYSDATE) - (1900 + TO_NUMBER(SUBSTR(JUBUN,1,2))) + 1)
            END "���������ϳ⵵"
            */

            /*
        , CASE WHEN TO_NUMBER(SUBSTR(JUBUN, 7,1)) '0'  THEN '0'
                ELSE '0'
                END "����������"
           */
           /*
         , HIREDATE "�Ի���"
         , CASE TO_NUMBER(SUBSTR(JUBUN, 7,1))  WHEN 1 THEN TO_DATE(TO_CHAR(1959 + TO_NUMBER(SUBSTR(JUBUN, 1,2))) || TO_CHAR(HIREDATE, '-MM-DD'), 'YYYY-MM-DD')
                                         WHEN 2 THEN TO_DATE(TO_CHAR(1959 + TO_NUMBER(SUBSTR(JUBUN, 1,2))) || TO_CHAR(HIREDATE, '-MM-DD'), 'YYYY-MM-DD')
                                         ELSE TO_DATE(TO_CHAR(2059 + TO_NUMBER(SUBSTR(JUBUN, 1,2))) || TO_CHAR(HIREDATE, '-MM-DD'), 'YYYY-MM-DD')
             END "����������"
         
        , TRUNC(SYSDATE - HIREDATE) "�ٹ��ϼ�"
        
        , CASE TO_NUMBER(SUBSTR(JUBUN, 7,1))  WHEN 1 THEN TRUNC(TO_DATE(TO_CHAR(1959 + TO_NUMBER(SUBSTR(JUBUN, 1,2))) || TO_CHAR(HIREDATE, '-MM-DD'), 'YYYY-MM-DD')-SYSDATE)
                                          WHEN 2 THEN TRUNC(TO_DATE(TO_CHAR(1959 + TO_NUMBER(SUBSTR(JUBUN, 1,2))) || TO_CHAR(HIREDATE, '-MM-DD'), 'YYYY-MM-DD')-SYSDATE)
                                          ELSE TRUNC(TO_DATE(TO_CHAR(2059 + TO_NUMBER(SUBSTR(JUBUN, 1,2))) || TO_CHAR(HIREDATE, '-MM-DD'), 'YYYY-MM-DD')-SYSDATE)
       END "�����ϼ�"
       
     , SAL "�޿�"
     
     , CASE WHEN TRUNC(SYSDATE - HIREDATE) >= 1000 AND TRUNC(SYSDATE - HIREDATE) < 2000 THEN SAL * 0.3
            WHEN TRUNC(SYSDATE - HIREDATE) >= 2000 THEN SAL * 0.5
            ELSE 0
       END "���ʽ�"
       
       
FROM TBL_SAWON;

SELECT TO_CHAR( ADD_MONTHS(SYSDATE, (60 - ���糪��) * 12), 'YYYY') "���⿬��"
FROM TBL_SAWON;
SELECT CASE WHEN SUBSTR(JUBUN,7,1) IN ('1', '2')  
            THEN TO_CHAR( ADD_MONTHS(SYSDATE, (60 - ((EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2))+1900)+1))   ) * 12), 'YYYY')
            WHEN SUBSTR(JUBUN,7,1) IN ('3', '4')  
            THEN TO_CHAR( ADD_MONTHS(SYSDATE, (60 - ((EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2))+2000)+1))) * 12), 'YYYY')
            ELSE '�߸��� ����' END "���⿬��"
FROM TBL_SAWON;
SELECT CASE WHEN SUBSTR(JUBUN,7,1) IN ('1', '2')  
            THEN TO_CHAR( ADD_MONTHS(SYSDATE, (60 - ((EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2))+1900)+1))   ) * 12), 'YYYY') || TO_CHAR(HIREDATE, '-MM-DD')
            WHEN SUBSTR(JUBUN,7,1) IN ('3', '4')  
            THEN TO_CHAR( ADD_MONTHS(SYSDATE, (60 - ((EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN,1,2))+2000)+1))) * 12), 'YYYY') || TO_CHAR(HIREDATE, '-MM-DD')
            ELSE '�߸��ȳ�¥' END "����������"
FROM TBL_SAWON;

-- THEN 2��, 


*/
/*            
FROM TBL_SAWON;
--TO_DATE('2021-12-28', 'YYYY-MM-DD')
---TO_DATE('XXXX-TO_CHAR(SYSDATE, 'MM')-TO_CHAR(SYSDATE, 'DD')', 'YYYY-MM-DD')
--TO_CHAR(SYSDATE, 'MM')
--TO_CHAR(SYSDATE, 'DD')
*/
-- SYSDATE + TO_YMINTERVAL('01-02')
/*
SELECT SYSDATE "���� �ð�"
     , SYSDATE + TO_YMINTERVAL('10-0') "���� ���"
               --@ 1�� 2���� ������                   3�� 4�ð� 5�� 6�� ������
FROM DUAL;  
--==>>

SELECT TO_DATE('1999-EXTRACT(MONTH FROM SYSDATE)-EXTRACT(DAY FROM SYSDATE)', 'YYYY-MM-DD')
FROM DUAL;
*/
/*
SELECT ADD_MONTHS(HIREDATE, (60 - (EXTRACT(YEAR FROM SYSDATE) - (2000 + TO_NUMBER(SUBSTR(JUBUN,1,2))) + 1)) * 12) "��� Ȯ��"
FROM TBL_SAWON;
*/

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
--==>> Session��(��) ����Ǿ����ϴ�.


-- TBL_SAWON ���̺��� �����ϴ� �������
-- �Ի���(HIREDATE) �÷����� ��, ��,�� ��ȸ�ϱ�
SELECT SANAME, HIREDATE, TO_CHAR(HIREDATE, 'MM-DD') "����"
FROM TBL_SAWON;
--==>>
/*
��ҿ�	    2001-01-03	01-03
�̴ٿ�	    2010-11-05	11-05
������	    2012-08-16	08-16
�մ���	    1999-02-02	02-02
������	    2013-07-15	07-15
���̰�	    2011-08-17	08-17
���̳�	    1999-11-11	11-11
������	    1999-11-11	11-11
������	    1995-11-11	11-11
������	1995-10-10	10-10
���켱	    2001-10-10	10-10
����	    1998-02-13	02-13
������	    2002-02-13	02-13
������	    2002-02-13	02-13
�賲��	    2015-01-10	01-10
*/

SELECT SANAME, HIREDATE, TO_CHAR(HIREDATE, 'MM') "��", TO_CHAR(HIREDATE, 'DD') "��"
FROM TBL_SAWON;
--==>>
/*
��ҿ�	    2001-01-03	01	03
�̴ٿ�	    2010-11-05	11	05
������	    2012-08-16	08	16
�մ���	    1999-02-02	02	02
������	    2013-07-15	07	15
���̰�	    2011-08-17	08	17
���̳�	    1999-11-11	11	11
������	    1999-11-11	11	11
������	    1995-11-11	11	11
������	1995-10-10	10	10
���켱	    2001-10-10	10	10
����	    1998-02-13	02	13
������	    2002-02-13	02	13
������	    2002-02-13	02	13
�賲��	    2015-01-10	01	10
*/

SELECT SANAME, HIREDATE, TO_CHAR(HIREDATE, 'MM') || '-' || TO_CHAR(HIREDATE, 'DD') "����"
FROM TBL_SAWON;
--==>>
/*
��ҿ�	    2001-01-03	01-03
�̴ٿ�	    2010-11-05	11-05
������	    2012-08-16	08-16
�մ���	    1999-02-02	02-02
������	    2013-07-15	07-15
���̰�	    2011-08-17	08-17
���̳�	    1999-11-11	11-11
������	    1999-11-11	11-11
������	    1995-11-11	11-11
������	1995-10-10	10-10
���켱	    2001-10-10	10-10
����	    1998-02-13	02-13
������	    2002-02-13	02-13
������	    2002-02-13	02-13
�賲��	    2015-01-10	01-10
*/

-- �����ȣ, �����, �ֹι�ȣ, ����, ���糪��, �Ի���
-- , ����������, �ٹ��ϼ�, �����ϼ�, �޿�, ���ʽ�

-- �����ȣ, �����, �ֹι�ȣ, ����, ���糪��, �Ի���, �޿�
SELECT SANO "�����ȣ", SANAME "�����", JUBUN "�ֹι�ȣ"
     , CASE WHEN �ֹι�ȣ 7��°�ڸ� 1���� '1' �Ǵ� '3' THEN '����'
            WHEN �ֹι�ȣ 7��°�ڸ� 1���� '2' �Ǵ� '4' THEN '����'
            ELSE '����Ȯ�κҰ�'
            END "����"
            --@ ELSE���� ��Ÿ �������� ���°� ����! �ֳ� WHEN 1,3 ELSE.. �ع����� % �̷��� ���� ���ڰ� �Ǿ�����ϱ�.
FROM TBL_SAWON;

SELECT SANO "�����ȣ", SANAME "�����", JUBUN "�ֹι�ȣ"
     , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '3') THEN '����'
            WHEN SUBSTR(JUBUN, 7, 1) IN ('2', '4') THEN '����'
            ELSE '����Ȯ�κҰ�'
            END "����"
            
--=>>
/*
1001	��ҿ�	    9307302234567	����
1002	�̴ٿ�	    9510272234567	����
1003	������	    0909014234567	����
1004	�մ���	    9406032234567	����
1005	������	    0406034234567	����
1006	���̰�	    0202023234567	����
1007	���̳�	    8012122234567	����
1008	������	    8105042234567	����
1009	������	    7209301234567	����
1010	������	7001022234567	����
1011	���켱	    9001022234567	����
1012	����	    8009011234567	����
1013	������	    8203051234567	����
1014	������	    9208091234567	����
1015	�賲��	    0202023234567	����
*/
            
/* --@ �̷� �������� ���� �Ẹ�� �׵� �ڵ� �ۼ��ϱ�...        
    -- ���糪�� = ����⵵ - �¾�⵵ + 1 (1990��� �� / 2000��� ��)
    , CASE WHEN 1900��� ���̶��...
           THEN ����⵵ - (�ֹι�ȣ �� ���ڸ� + 1899) 
           WHEN 2000��� ���̶��...
           THEN ����⵵ - (�ֹι�ȣ �� ���ڸ� + 1999)
           ELSE -1
    END "���糪��" 
*/

, CASE WHEN �ֹι�ȣ 1��°�ڸ� 1���� '1' �Ǵ� '2'
           THEN ����⵵ - (�ֹι�ȣ �� ���ڸ� + 1899) 
           WHEN �ֹι�ȣ 1��°�ڸ� 1���� '3' �Ǵ� '4'
           THEN ����⵵ - (�ֹι�ȣ �� ���ڸ� + 1999)
           ELSE -1
    END "���糪��" 

FROM TBL_SAWON;

SELECT SANO "�����ȣ", SANAME "�����", JUBUN "�ֹι�ȣ"
     , CASE WHEN �ֹι�ȣ 7��°�ڸ� 1���� '1' �Ǵ� '3' THEN '����'
            WHEN �ֹι�ȣ 7��°�ڸ� 1���� '2' �Ǵ� '4' THEN '����'
            ELSE '����Ȯ�κҰ�'
            END "����"
            --@ ELSE���� ��Ÿ �������� ���°� ����! �ֳ� WHEN 1,3 ELSE.. �ع����� % �̷��� ���� ���ڰ� �Ǿ�����ϱ�.
FROM TBL_SAWON;


SELECT SANO "�����ȣ", SANAME "�����", JUBUN "�ֹι�ȣ"
     , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '3') THEN '����'
            WHEN SUBSTR(JUBUN, 7, 1) IN ('2', '4') THEN '����'
            ELSE '����Ȯ�κҰ�'
            END "����"
            
    -- ���糪�� = ����⵵ - �¾�⵵ + 1 (1990��� �� / 2000��� ��)
    , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '2')
           THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1899) 
           WHEN SUBSTR(JUBUN, 7, 1) IN ('3', '4')
           THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1999) 
           ELSE -1
    END "���糪��" 
FROM TBL_SAWON;
--==>>
/*
1001	��ҿ�	    9307302234567	����	29
1002	�̴ٿ�	    9510272234567	����	27
1003	������	    0909014234567	����	13
1004	�մ���	    9406032234567	����	28
1005	������	    0406034234567	����	18
1006	���̰�	    0202023234567	����	20
1007	���̳�	    8012122234567	����	42
1008	������	    8105042234567	����	41
1009	������	    7209301234567	����	50
1010	������	7001022234567	����	52
1011	���켱	    9001022234567	����	32
1012	����	    8009011234567	����	42
1013	������	    8203051234567	����	40
1014	������	    9208091234567	����	30
1015	�賲��	    0202023234567	����	20
*/


SELECT SANO "�����ȣ", SANAME "�����", JUBUN "�ֹι�ȣ"
     , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '3') THEN '����'
            WHEN SUBSTR(JUBUN, 7, 1) IN ('2', '4') THEN '����'
            ELSE '����Ȯ�κҰ�'
            END "����"
            
    -- ���糪�� = ����⵵ - �¾�⵵ + 1 (1990��� �� / 2000��� ��)
    , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '2')
           THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1899) 
           WHEN SUBSTR(JUBUN, 7, 1) IN ('3', '4')
           THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1999) 
           ELSE -1
    END "���糪��" 
    , HIREDATE " �Ի���"
    , SAL "�޿�"
FROM TBL_SAWON;
--==>>
/*
1001	��ҿ�	    9307302234567	����	29	2001-01-03	3000
1002	�̴ٿ�	    9510272234567	����	27	2010-11-05	2000
1003	������	    0909014234567	����	13	2012-08-16	1000
1004	�մ���	    9406032234567	����	28	1999-02-02	4000
1005	������	    0406034234567	����	18	2013-07-15	1000
1006	���̰�	    0202023234567	����	20	2011-08-17	2000
1007	���̳�	    8012122234567	����	42	1999-11-11	3000
1008	������	    8105042234567	����	41	1999-11-11	3000
1009	������	    7209301234567	����	50	1995-11-11	3000
1010	������	7001022234567	����	52	1995-10-10	3000
1011	���켱	    9001022234567	����	32	2001-10-10	2000
1012	����	    8009011234567	����	42	1998-02-13	4000
1013	������	    8203051234567	����	40	2002-02-13	3000
1014	������	    9208091234567	����	30	2002-02-13	3000
1015	�賲��	    0202023234567	����	20	2015-01-10	2000
*/

--@ ��ġ ���̺� ��� ������ ��ó�� ��� ����!
SELECT T.�����ȣ, ����
FROM 
(
    SELECT SANO "�����ȣ", SANAME "�����", SAL "�޿�", SAL*12 "����"
    FROM TBL_SAWON
)T;


SELECT TBL_SAWON.SANO
FROM TBL_SAWON;
/*
SELECT T.SANO
FROM TBL_SAWON T;

SELECT TBL_SAWON.SANO
FROM SCOTT.TBL_SAWON;

SELECT SCOTT.TBL_SAWON.SANO
FROM SCOTT.TBL_SAWON;
*/

SELECT TBL_SAWON.SANO, TBL_SAWON.SANAME, TBL_SAWON.SAL
FROM TBL_SAWON;

SELECT S.SANO, S.SANAME, S.SAL
FROM TBL_SAWON S;

--
SELECT A.�����ȣ, A.�����, A.����, A.����*2 "�ι迬��"
FROM
(
    SELECT SANO "�����ȣ", SANAME "�����", SAL "�޿�", SAL*12 "����" -- ����*2 "�ι迬��" 
                                                                        --> �̰� �ȵ�! SELECT�� �ѹ��� ��! ������ ������..
    FROM TBL_SAWON
) A;
--@ '�ζ��� ��'��� �θ�... ���δ����ȿ��� ���������� ���� ��ó�� Ȱ��



--�� ����
-- TBL_SWAON ���̺��� Ȱ���Ͽ� ������ ���� �׸���� ��ȸ�Ѵ�.
-- �����ȣ, �����, �ֹι�ȣ, ����, ���糪��, �Ի���
-- , ����������, �ٹ��ϼ�, �����ϼ�, �޿�, ���ʽ�

-- ��, ���糪�̴� �ѱ����� ������ ���� ������ �����Ѵ�. (�¾�� �⺻ �� �� ����)
-- ����, ������������ �ش� ������ ���̰� �ѱ����̷� 60���� �Ǵ� ��(����)��
-- �� ������ �Ի� ��, �Ϸ� ������ �����Ѵ�.

-- �׸���, ���ʽ��� 4000�� �̻� 8000�� �̸� �ٹ��� ����� --> �� ���ʽ� ���� ����!
-- �� ����� ���� �޿� ���� 30% ����,
-- 8000�� �̻� �ٹ��� �����
-- �� ����� ���� �޿� ���� 50% ������ �� �� �ֵ��� ó���Ѵ�. 

SELECT T.�����ȣ, T.�����, T.�ֹι�ȣ, T.����, T.���糪��, T.�Ի���
     -- ����������
     -- ���������⵵ �� �ش� ������ ���̰� �ѱ����̷� 60���� �Ǵ� ��
     -- ���� ���̰�... 58��...  2�� ��       2021 �� 2023
     -- ���� ���̰�... 35��... 25�� ��       2021 �� 2046
     -- ADD_MONTHS(SYSDATE, �������*12)
     --                     -------
     --                     (60 - ���糪��)
     -- ADD_MONTHS(SYSDATE, (60 - ���糪��)*12) �� �� ������� �������� �⵵�� �ʿ�
     -- TO_CHAR(ADD_MONTHS(SYSDATE, (60 - ���糪��)*12), 'YYYY') �� �������� �⵵�� ���� 
     -- TO_CHAR(ADD_MONTHS(SYSDATE, (60 - ���糪��)*12), 'YYYY') || '-' ||  TO_CHAR(HIREDATE, 'MM-DD')
      , TO_CHAR(ADD_MONTHS(SYSDATE, (60 - T.���糪��)*12), 'YYYY') || '-' ||  TO_CHAR(T.�Ի���, 'MM-DD') "����������"
     
     -- �ٹ��ϼ� = ������ - �Ի���
      , TRUNC(SYSDATE - T.�Ի���) "�ٹ��ϼ�"
      
     -- �����ϼ� = ���������� - ������
     , TRUNC(TO_DATE(TO_CHAR(ADD_MONTHS(SYSDATE, (60 - T.���糪��)*12), 'YYYY') 
       || '-' ||  TO_CHAR(T.�Ի���, 'MM-DD'), 'YYYY-MM-DD') - SYSDATE) "�����ϼ�"
     
     , T.�޿�
     
     -- ���ʽ�
     -- �ٹ��ϼ��� 4000�� �̻� 8000�� �̸� �� ���� �޿��� 30%
     -- �ٹ��ϼ��� 8000�� �̻�             �� ���� �޿��� 50%
     -- ������ 0
     , CASE WHEN TRUNC(SYSDATE - T.�Ի���) >= 8000 THEN T.�޿� * 0.5
            WHEN TRUNC(SYSDATE - T.�Ի���) >= 4000 THEN T.�޿� * 0.3
            ELSE 0
        END "���ʽ�"
     
FROM
(
    SELECT SANO "�����ȣ", SANAME "�����", JUBUN "�ֹι�ȣ"
     , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '3') THEN '����'
            WHEN SUBSTR(JUBUN, 7, 1) IN ('2', '4') THEN '����'
            ELSE '����Ȯ�κҰ�'
            END "����"
    , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '2')
           THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1899) 
           WHEN SUBSTR(JUBUN, 7, 1) IN ('3', '4')
           THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1999) 
           ELSE -1
    END "���糪��" 
    , HIREDATE "�Ի���"
    , SAL "�޿�"
FROM TBL_SAWON
) T;



--@�� �� ���� �ּ� ������

-- �����ȣ, �����, �ֹι�ȣ, ����, ���糪��, �Ի���
-- , ����������, �ٹ��ϼ�, �����ϼ�, �޿�, ���ʽ�
SELECT T.�����ȣ, T.�����, T.�ֹι�ȣ, T.����, T.���糪��, T.�Ի���

      , TO_CHAR(ADD_MONTHS(SYSDATE, (60 - T.���糪��)*12), 'YYYY') || '-' ||  TO_CHAR(T.�Ի���, 'MM-DD') "����������"
      , TRUNC(SYSDATE - T.�Ի���) "�ٹ��ϼ�"
     , TRUNC(TO_DATE(TO_CHAR(ADD_MONTHS(SYSDATE, (60 - T.���糪��)*12), 'YYYY') 
       || '-' ||  TO_CHAR(T.�Ի���, 'MM-DD'), 'YYYY-MM-DD') - SYSDATE) "�����ϼ�"
     , T.�޿�
     , CASE WHEN TRUNC(SYSDATE - T.�Ի���) >= 8000 THEN T.�޿� * 0.5
            WHEN TRUNC(SYSDATE - T.�Ի���) >= 4000 THEN T.�޿� * 0.3
            ELSE 0
        END "���ʽ�"
     
FROM
(
    SELECT SANO "�����ȣ", SANAME "�����", JUBUN "�ֹι�ȣ"
     , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '3') THEN '����'
            WHEN SUBSTR(JUBUN, 7, 1) IN ('2', '4') THEN '����'
            ELSE '����Ȯ�κҰ�'
            END "����"
    , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '2')
           THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1899) 
           WHEN SUBSTR(JUBUN, 7, 1) IN ('3', '4')
           THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1999) 
           ELSE -1
    END "���糪��" 
    , HIREDATE "�Ի���"
    , SAL "�޿�"
FROM TBL_SAWON
) T;


--�� ��� ���뿡��... Ư�� �ٹ��ϼ��� ����� Ȯ���ؾ� �Ѵٰų�...
--   Ư�� ���ʽ� �ݾ��� �޴� ����� Ȯ���ؾ� �� ��찡 ���� �� �ִ�.
--   �̿� ���� ���... �ش� �������� �ٽ� �����ϴ� ���ŷο��� ���� �� �ֵ���
--   ��(VIEW)�� ����� ������ �� �� �ִ�.

CREATE OR REPLACE VIEW VIEW_SAWON
AS
SELECT T.�����ȣ, T.�����, T.�ֹι�ȣ, T.����, T.���糪��, T.�Ի���

      , TO_CHAR(ADD_MONTHS(SYSDATE, (60 - T.���糪��)*12), 'YYYY') || '-' ||  TO_CHAR(T.�Ի���, 'MM-DD') "����������"
      , TRUNC(SYSDATE - T.�Ի���) "�ٹ��ϼ�"
     , TRUNC(TO_DATE(TO_CHAR(ADD_MONTHS(SYSDATE, (60 - T.���糪��)*12), 'YYYY') 
       || '-' ||  TO_CHAR(T.�Ի���, 'MM-DD'), 'YYYY-MM-DD') - SYSDATE) "�����ϼ�"
     , T.�޿�
     , CASE WHEN TRUNC(SYSDATE - T.�Ի���) >= 8000 THEN T.�޿� * 0.5
            WHEN TRUNC(SYSDATE - T.�Ի���) >= 4000 THEN T.�޿� * 0.3
            ELSE 0
        END "���ʽ�"
     
FROM
(
    SELECT SANO "�����ȣ", SANAME "�����", JUBUN "�ֹι�ȣ"
     , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '3') THEN '����'
            WHEN SUBSTR(JUBUN, 7, 1) IN ('2', '4') THEN '����'
            ELSE '����Ȯ�κҰ�'
            END "����"
    , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '2')
           THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1899) 
           WHEN SUBSTR(JUBUN, 7, 1) IN ('3', '4')
           THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1999) 
           ELSE -1
    END "���糪��" 
    , HIREDATE "�Ի���"
    , SAL "�޿�"
FROM TBL_SAWON
) T;
--==>> ���� �߻�
/*
ORA-01031: insufficient privileges
01031. 00000 -  "insufficient privileges"
*Cause:    An attempt was made to perform a database operation without
           the necessary privileges.
*Action:   Ask your database administrator or designated security
           administrator to grant you the necessary privileges
*/
--> ������ ������Ͽ� �߻��ϴ� ����

-- �� SYS �κ��� VIEW �� ������ �� �ִ� ������ �ο����� ��
--    �ٽ� ��(VIEW) ����
CREATE OR REPLACE VIEW VIEW_SAWON
AS
SELECT T.�����ȣ, T.�����, T.�ֹι�ȣ, T.����, T.���糪��, T.�Ի���

      , TO_CHAR(ADD_MONTHS(SYSDATE, (60 - T.���糪��)*12), 'YYYY') || '-' ||  TO_CHAR(T.�Ի���, 'MM-DD') "����������"
      , TRUNC(SYSDATE - T.�Ի���) "�ٹ��ϼ�"
     , TRUNC(TO_DATE(TO_CHAR(ADD_MONTHS(SYSDATE, (60 - T.���糪��)*12), 'YYYY') 
       || '-' ||  TO_CHAR(T.�Ի���, 'MM-DD'), 'YYYY-MM-DD') - SYSDATE) "�����ϼ�"
     , T.�޿�
     , CASE WHEN TRUNC(SYSDATE - T.�Ի���) >= 8000 THEN T.�޿� * 0.5
            WHEN TRUNC(SYSDATE - T.�Ի���) >= 4000 THEN T.�޿� * 0.3
            ELSE 0
        END "���ʽ�"
     
FROM
(
    SELECT SANO "�����ȣ", SANAME "�����", JUBUN "�ֹι�ȣ"
     , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '3') THEN '����'
            WHEN SUBSTR(JUBUN, 7, 1) IN ('2', '4') THEN '����'
            ELSE '����Ȯ�κҰ�'
            END "����"
    , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '2')
           THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1899) 
           WHEN SUBSTR(JUBUN, 7, 1) IN ('3', '4')
           THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1999) 
           ELSE -1
    END "���糪��" 
    , HIREDATE "�Ի���"
    , SAL "�޿�"
FROM TBL_SAWON
) T;
--==>> View VIEW_SAWON��(��) �����Ǿ����ϴ�.
--@ �������� ���� �ϳ��� �ϳ��� �׸� ���ε��� �ۼ��ϱ�!!
--@ ����Ŭ�� ������, ���ɽð��� ���� �� �ϰ� PC ������ϱ�!
--@ Ŀ�� �Ͻðڽ��ϱ�? ������ Ŀ���ϱ�! (�ѹ�X)

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
--==>> Session��(��) ����Ǿ����ϴ�.

SELECT *
FROM VIEW_SAWON;
--==>>
/*
1001	��ҿ�	    9307302234567	����	29	2001-01-03	2052-01-03	7548	11078	3000	900
1002	�̴ٿ�     	9510272234567	����	27	2010-11-05	2054-11-05	3955	12115	2000	0
1003	������     	0909014234567	����	13	2012-08-16	2068-08-16	3305	17148	1000	0
1004	�մ���	    9406032234567	����	28	1999-02-02	2053-02-02	8249	11474	4000	2000
1005	������	    0406034234567	����	18	2013-07-15	2063-07-15	2972	15289	1000	0
1006	���̰�	    0202023234567	����	20	2011-08-17	2061-08-17	3670	14592	2000	0
1007	���̳�	    8012122234567	����	42	1999-11-11	2039-11-11	7967	6642	3000	900
1008	������	    8105042234567	����	41	1999-11-11	2040-11-11	7967	7008	3000	900
1009	������	    7209301234567	����	50	1995-11-11	2031-11-11	9428	3720	3000	1500
1010	������	7001022234567	����	52	1995-10-10	2029-10-10	9460	2958	3000	1500
1011	���켱	    9001022234567	����	32	2001-10-10	2049-10-10	7268	10263	2000	600
1012	����	    8009011234567	����	42	1998-02-13	2039-02-13	8603	6371	4000	2000
1013	������	    8203051234567	����	40	2002-02-13	2041-02-13	7142	7102	3000	900
1014	������	    9208091234567	����	30	2002-02-13	2051-02-13	7142	10754	3000	900
1015	�賲��	    0202023234567	����	20	2015-01-10	2061-01-10	2428	14373	2000	0
*/  
--@ �並 ���� �� ���� ū ����(���߿� ����Ʈ���� �Ұ�����..�̸� �����ϰ�)
--1. ���� ���� ���
--2. ���Ǽ� (@ ��ġ ���� ��Ĭ! ��°�ó�� ����������.. ���� �� ���� ���̵� �ʿ� ������ ��� ����)

--�� TBL_SAWON ���̺��� ��ҿ� ����� �Ի��� �� �޿� ������ ����
-- ���� TABLE ���� : 1001	��ҿ�	9307302234567	2001-01-03	3000
-- ���� VIEW ����  : 1001	��ҿ�	9307302234567	����	29	2001-01-03	2052-01-03	7548	11078	3000	900

SELECT *
FROM VIEW_SAWON;

UPDATE TBL_SAWON
SET HIREDATE=SYSDATE, SAL=5000
WHERE SANO=1001;
--@ ������Ʈ ���� ���� ������ �ݵ�� WHERE ���� �ۼ�
--==>> 1 �� ��(��) ������Ʈ�Ǿ����ϴ�.

SELECT *
FROM TBL_SAWON
WHERE SANO=1001;
--==>> 1001	��ҿ�	9307302234567	2021-09-03	5000

COMMIT;
--==>> Ŀ�� �Ϸ�.

SELECT *
FROM TBL_SAWON;
--@ �� ������ ���̺� �ٲ㵵... �䵵 �˾Ƽ� �ٲ�! (�̰ŵ� ���� �ſ� �߿��� Ư¡) (�� ����صα�!)
--@ ����Ŭ ���������δ� �� ��ȸ���� �� ������ ���ư�... ������ ����Ǿ��ִ� ���̺��� �ٲ�� �䵵 ���� �ٲ�



--�� TBL_SAWON ���̺��� ��ҿ� ����� �Ի��� �� �޿� ������ ���� ���� �ٽ� Ȯ��
-- ���� TABLE ���� : 1001	��ҿ�	9307302234567	2001-01-03	3000
-- ���� �� ����    : 1001	��ҿ�	9307302234567	2021-09-03	5000
-- ���� VIEW ����  : 1001	��ҿ�	9307302234567	����	29	2001-01-03	2052-01-03	7548	11078	3000	900
-- ���� �� ����    : 1001	��ҿ�	9307302234567	����	29	2021-09-03	2052-09-03	   0	11322	5000	  0


--�� ����
-- ���������� Ȱ���Ͽ� TBL_SAWON ���̺��� ������ ���� ��ȸ�� �� �ֵ��� �Ѵ�.
/*
----------------------------------------------------
   �����   ����   ���糪��    �޿�   ���̺��ʽ�
-----------------------------------------------------

��, ���̺��ʽ��� ���� ���̰� 40�� �̻��̸� �޿��� 70%
    30�� �̻� 40�� �̸��̸� �޿��� 50%
    20�� �̻� 30�� �̸��̸� �޿��� 30%�� �Ѵ�.
    
����, �ϼ��� ��ȸ ������ �������
VIEW_SAWON2 ��� �̸��� ��(VIEW)�� �����Ѵ�.
*/

--�� ���� �ۼ��� �ڵ�
/*
SELECT SANO "�����ȣ", SANAME "�����", JUBUN "�ֹι�ȣ"
     , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '3') THEN '����'
            WHEN SUBSTR(JUBUN, 7, 1) IN ('2', '4') THEN '����'
            ELSE '����Ȯ�κҰ�'
            END "����"
            
    -- ���糪�� = ����⵵ - �¾�⵵ + 1 (1990��� �� / 2000��� ��)
    , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '2')
           THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1899) 
           WHEN SUBSTR(JUBUN, 7, 1) IN ('3', '4')
           THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1999) 
           ELSE -1
    END "���糪��" 

SELECT �����, ����, ���糪��, �޿�, ���̺��ʽ�
FROM TBL_SAWON;

SELECT SANAME "�����"
    , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '3') THEN '����'
           WHEN SUBSTR(JUBUN, 7, 1) IN ('2', '4') THEN '����'
           ELSE '�����Ҹ�'
    END ����
    -- ���糪�� : ����⵵ - �¾ �⵵ + 1 
    , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '2')
           THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1899) 
           WHEN SUBSTR(JUBUN, 7, 1) IN ('3', '4') 
           THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1999)
           ELSE -1 --'���̺Ҹ�' --@ ��� THEN, ELSE ���� ���� ���°� ���;� ���� �� ������..!
    END ���糪��
    , SAL "�޿�"
    */
    /*
    , CASE WHEN 40�� �̻��̸� THEN �޿��� 70% 
           WHEN 30�� �̻� 40�� �̸��̸� THEN �޿��� 50%
           WHEN  20�� �̻� 30�� �̸��̸� THEN �޿��� 30%
           ELSE -1
    END ���̺��ʽ�
    */
    -- ���� �����ü��� �����ϱ� ���ε��� �����;� �� �� ������
    -- 90��� 00���� ������ ���,,,,�����Ű��,,,,,?
    -- 00������ 22��....
    /*
    , CASE WHEN 40�� �̻��̸� THEN SAL * 0.7
           WHEN 30�� �̻� 40�� �̸��̸� THEN SAL * 0.5
           WHEN 20�� �̻� 30�� �̸��̸� THEN SAL * 0.3
           ELSE -1
    END ���̺��ʽ�1
    , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '2')
           THEN 
           WHEN SUBSTR(JUBUN, 7, 1) IN ('3', '4')
           THEN 
           ELSE -1
    END ���̺��ʽ�2
FROM TBL_SAWON;
*/

--@ �̰� ��������?
SELECT SANAME "�����"
     , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '3') THEN '����'
            WHEN SUBSTR(JUBUN, 7, 1) IN ('2', '4') THEN '����'
            ELSE 'Ȯ�κҰ�'
       END ����
      , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '2') 
             THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1899)
             WHEN SUBSTR(JUBUN, 7, 1) IN ('3', '4') 
             THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1999)
             ELSE -1   --'Ȯ�κҰ�'�� ��� X
             --@ THEN, ELSE ���Ͽ� ������ Ÿ�� ���� �� ���� ��! (����, ����..)
             --@ CNTL + F : ã��
         END "���糪��"
      , SAL "�޿�"
FROM TBL_SAWON;

--@ FROM �� ���� �ۼ��ϴ°� ����ϸ� �� �ſ�~!!
SELECT T.*
     , CASE WHEN T.���糪�� >= 40 THEN T.�޿� * 0.7
            WHEN T.���糪�� >= 30 THEN T.�޿� * 0.5
            WHEN T.���糪�� >= 20 THEN T.�޿� * 0.3
            ELSE 0
            END "���̺��ʽ�"

--@ ��������?            
FROM
(
    SELECT SANAME "�����"
         , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '3') THEN '����'
                WHEN SUBSTR(JUBUN, 7, 1) IN ('2', '4') THEN '����'
                ELSE 'Ȯ�κҰ�'
           END ����
          , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '2') 
                 THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1899)
                 WHEN SUBSTR(JUBUN, 7, 1) IN ('3', '4') 
                 THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1999)
                 ELSE -1   --'Ȯ�κҰ�'�� ��� X
                 --@ THEN, ELSE ���Ͽ� ������ Ÿ�� ���� �� ���� ��! (����, ����..)
                 --@ CNTL + F : ã��
             END "���糪��"
          , SAL "�޿�"
    FROM TBL_SAWON --@ �����ݷ� ����� �� ����!
) T;
--@ ������ ������ ��������.... �ζ��� ��! () �ȿ��Ÿ� ��Ƽ� ������ѵ� ���� �Ǿ����


CREATE USER ������;
CREATE TABLE ���̺���;
CREATE INDEX �ε�����;
CREATE VIEW ���;
--@ ��״� �Ȱ��� �̸� �̹� �����ϸ� ���� ��
--@ USER, TABLE, INDX�� �������� ����Ǿ� �ִ� ��찡 �ټ�... ������ �̰͸� �ٲٱ� ���� ����

--CREATE OR REPLACE VIEW ���
--@ ��� �Ȱ��� �̸� �����ص� �������� ����
--@ ���� ����ų�, ���� �̸��� �ִٸ� ����� ����
--@ VIEW�� �������� ����Ǿ� ���� ���� ������! ������ �̷��� ���� ���

--CREATE ��� ����̸�;
--CREATE OR REPLACE ������ �������̸�; --@ ������ ��쿡�� �ٸ� ���������� ���!

CREATE OR REPLACE VIEW VIEW_SAWON2
AS
SELECT T.*
     , CASE WHEN T.���糪�� >= 40 THEN T.�޿� * 0.7
            WHEN T.���糪�� >= 30 THEN T.�޿� * 0.5
            WHEN T.���糪�� >= 20 THEN T.�޿� * 0.3
            ELSE 0
            END "���̺��ʽ�"

--@ ��������?            
FROM
(
    SELECT SANAME "�����"
         , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '3') THEN '����'
                WHEN SUBSTR(JUBUN, 7, 1) IN ('2', '4') THEN '����'
                ELSE 'Ȯ�κҰ�'
           END ����
          , CASE WHEN SUBSTR(JUBUN, 7, 1) IN ('1', '2') 
                 THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1899)
                 WHEN SUBSTR(JUBUN, 7, 1) IN ('3', '4') 
                 THEN EXTRACT(YEAR FROM SYSDATE) - (TO_NUMBER(SUBSTR(JUBUN, 1, 2)) + 1999)
                 ELSE -1   --'Ȯ�κҰ�'�� ��� X
                 --@ THEN, ELSE ���Ͽ� ������ Ÿ�� ���� �� ���� ��! (����, ����..)
                 --@ CNTL + F : ã��
             END "���糪��"
          , SAL "�޿�"
    FROM TBL_SAWON --@ �����ݷ� ����� �� ����!
) T;
--==>> View VIEW_SAWON2��(��) �����Ǿ����ϴ�.


--�� ������ �� ��ȸ(Ȯ��)
SELECT *
FROM VIEW_SAWON2;
--==>>
/*
��ҿ�	    ����	29	5000	1500
�̴ٿ�	    ����	27	2000	600
������	    ����	13	1000	0
�մ���	    ����	28	4000	1200
������	    ����	18	1000	0
���̰�	    ����	20	2000	600
���̳�	    ����	42	3000	2100
������	    ����	41	3000	2100
������	    ����	50	3000	2100
������	����	52	3000	2100
���켱 	    ����	32	2000	1000
����	    ����	42	4000	2800
������	    ����	40	3000	2100
������	    ����	30	3000	1500
�賲��	    ����	20	2000	600
*/


--------------------------------------------------------------------------------

--�� RANK()  ���(����)�� ��ȯ�ϴ� �Լ�
SELECT EMPNO "�����ȣ", ENAME "�����", DEPTNO "�μ���ȣ", SAL "�޿�"
     , RANK() OVER(ORDER BY SAL DESC) "��ü �޿�����"
FROM EMP;
--==>>
/*
7839	KING	10	5000	 1
7902	FORD	20	3000	 2
7788	SCOTT	20	3000	 2
7566	JONES	20	2975	 4
7698	BLAKE	30	2850	 5
7782	CLARK	10	2450	 6
7499	ALLEN	30	1600	 7
7844	TURNER	30	1500	 8
7934	MILLER	10	1300	 9
7521	WARD	30	1250	10
7654	MARTIN	30	1250	10
7876	ADAMS	20	1100	12
7900	JAMES	30	 950	13
7369	SMITH	20	 800	14
*/

SELECT EMPNO "�����ȣ", ENAME "�����", DEPTNO "�μ���ȣ", SAL "�޿�"
     , RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL DESC) "�μ��� �޿�����"
     , RANK() OVER(ORDER BY SAL DESC) "��ü �޿�����"
FROM EMP;
--==>>
/*
7839	KING	10	5000	1	 1
7902	FORD	20	3000	1	 2
7788	SCOTT	20	3000	1	 2
7566	JONES	20	2975	3	 4
7698	BLAKE	30	2850	1	 5
7782	CLARK	10	2450	2	 6
7499	ALLEN	30	1600	2	 7
7844	TURNER	30	1500	3	 8
7934	MILLER	10	1300	3	 9
7521	WARD	30	1250	4	10
7654	MARTIN	30	1250	4	10
7876	ADAMS	20	1100	4	12
7900	JAMES	30	950	    6	13
7369	SMITH	20	800	    5	14
*/

SELECT EMPNO "�����ȣ", ENAME "�����", DEPTNO "�μ���ȣ", SAL "�޿�"
     , RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL DESC) "�μ��� �޿�����"
     , RANK() OVER(ORDER BY SAL DESC) "��ü �޿�����"
FROM EMP
ORDER BY 3, 4 DESC;
--==>>
/*
7839	KING	10	5000	1	 1
7782	CLARK	10	2450	2	 6
7934	MILLER	10	1300	3	 9
7902	FORD	20	3000	1	 2
7788	SCOTT	20	3000	1	 2
7566	JONES	20	2975	3	 4
7876	ADAMS	20	1100	4   12
7369	SMITH	20	 800	5   14
7698	BLAKE	30	2850	1	 5
7499	ALLEN	30	1600	2	 7
7844	TURNER	30	1500	3	 8
7654	MARTIN	30	1250	4	10
7521	WARD	30	1250	4	10
7900	JAMES	30	 950	6	13
*/
--@ 9���� �θ��̸� ������ 11��!

--�� DENSE_RANK()    �� ������ ��ȯ�ϴ� �Լ�
SELECT EMPNO "�����ȣ", ENAME "�����", DEPTNO "�μ���ȣ", SAL "�޿�"
     , DENSE_RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL DESC) "�μ��� �޿�����"
     , DENSE_RANK() OVER(ORDER BY SAL DESC) "��ü �޿�����"
FROM EMP
ORDER BY 3, 4 DESC;
--==>>
/*
7839	KING	10	5000	1	 1
7782	CLARK	10	2450	2	 5
7934	MILLER	10	1300	3	 8
7902	FORD	20	3000	1	 2
7788	SCOTT	20	3000	1	 2
7566	JONES	20	2975	2	 3
7876	ADAMS	20	1100	3	10
7369	SMITH	20	 800	4	12
7698	BLAKE	30	2850	1	 4
7499	ALLEN	30	1600	2	 6
7844	TURNER	30	1500	3	 7
7654	MARTIN	30	1250	4	 9
7521	WARD	30	1250	4	 9
7900	JAMES	30	 950    5	11
*/
--@ 9���� �θ��̴��� ������ 10��!


--�� EMP ���̺��� ��� ������
--   �����, �μ���ȣ, ����, �μ��� ��������, ��ü �������� �׸����� ��ȸ�Ѵ�.
/*
SELECT EMPNO "�����ȣ", ENAME "�����", DEPTNO "�μ���ȣ", SAL "�޿�"
     , DENSE_RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL DESC) "�μ��� �޿�����"
     , DENSE_RANK() OVER(ORDER BY SAL DESC) "��ü �޿�����"
FROM EMP
ORDER BY 3, 4 DESC;
*/
/*
--�� ���� �ۼ��� �ڵ�
SELECT �����, �μ���ȣ, ����, �μ��� ��������, ��ü ��������
FROM EMP;

SELECT ENAME "�����", EMPNO "�μ���ȣ", SAL*12 "����"
     , RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL*12 DESC) "�μ��� ��������"
     , RANK() OVER(ORDER BY SAL*12 DESC) "��ü ��������"
FROM EMP;
*/


--�� EMP ���̺��� ��� ������
--   �����, �μ���ȣ, ����, �μ��� ��������, ��ü �������� �׸����� ��ȸ�Ѵ�.
SELECT ENAME "�����", DEPTNO "�μ���ȣ", SAL*12 + NVL(COMM, 0) "����"
     , RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL*12+NVL(COMM,0) DESC) "�μ��� ��������"
     , RANK() OVER(ORDER BY SAL*12+NVL(COMM,0) DESC) "��ü ��������"
FROM EMP
ORDER BY 2, 3 DESC;
--==>>
/*
KING	10	60000	1	1
CLARK	10	29400	2	6
MILLER	10	15600	3	10
FORD	20	36000	1	2
SCOTT	20	36000	1	2
JONES	20	35700	3	4
ADAMS	20	13200	4	12
SMITH	20	9600	5	14
BLAKE	30	34200	1	5
ALLEN	30	19500	2	7
TURNER	30	18000	3	8
MARTIN	30	16400	4	9
WARD	30	15500	5	11
JAMES	30	11400	6	13
*/

SELECT T.*
     , RANK() OVER(PARTITION BY T.�μ���ȣ ORDER BY T.���� DESC) "�μ��� ��������"
     , RANK() OVER(ORDER BY T.���� DESC) "��ü ��������"
FROM
(
    SELECT ENAME "�����", DEPTNO "�μ���ȣ"
               , SAL*12+NVL(COMM, 0) "����"
    FROM EMP
) T
ORDER BY 2, 3 DESC;

--�� EMP ���̺����� ��ü ���� ������ 1����� 5�� ������...
--   �����, �μ���ȣ, ����, ��ü�������� �׸����� ��ȸ�Ѵ�.
/*
--�� ���� �ۼ��� �ڵ�
SELECT �����, �μ���ȣ, ����, ��ü��������
FROM EMP
WHERE ��ü ���� ������ 1����� 5��;

SELECT T.*
     , RANK() OVER(ORDER BY T.���� DESC) "��ü ��������"
FROM
(
    SELECT ENAME "�����", DEPTNO "�μ���ȣ"
               , SAL*12+NVL(COMM, 0) "����"
    FROM EMP
) T
WHERE 'T.��ü ��������'>0 AND 'T.��ü ��������'<6;
--@ FROM WHERE GROUP BY.... HAVING SELECT ORDER BY
*/

--�� �Բ� �ۼ��� �ڵ�
SELECT �����, �μ���ȣ, ����, ��ü��������
FROM EMP
WHERE ��ü ���� ������ 1����� 5��;

SELECT ENAME "�����", DEPTNO "�μ���ȣ", SAL*12 + NVL(COMM, 0) "����"
     , RANK() OVER(ORDER BY SAL*12+NVL(COMM,0) DESC) "��ü��������"
FROM EMP
WHERE RANK() OVER(ORDER BY SAL*12+NVL(COMM,0) DESC) <=5;
--==>> ���� �߻�
/*
ORA-30483: window  functions are not allowed here
30483. 00000 -  "window  functions are not allowed here"
*Cause:    Window functions are allowed only in the SELECT list of a query.
           And, window function cannot be an argument to another window or group
           function.
*Action:
1,023��, 37������ ���� �߻�
*/

--�� ���� ������ RANK() OVER() �� WHERE ���������� ����� ����̸�...
--   �� �Լ��� WHERE ���������� ����� �� ���� �Լ��̸�
--   �� ��Ģ�� ���� ������ �߻��ϴ� �����̴�.
--   �� ���... �츮�� INLINE VIEW �� Ȱ���Ͽ� Ǯ���ؾ� �Ѵ�.

SELECT T.*
FROM 
(
    SELECT ENAME "�����", DEPTNO "�μ���ȣ", SAL*12 + NVL(COMM, 0) "����"
         , RANK() OVER(ORDER BY SAL*12+NVL(COMM,0) DESC) "��ü��������"
    FROM EMP
) T
WHERE T.��ü�������� <= 5;
--==>>
/*
KING	10	60000	1
SCOTT	20	36000	2
FORD	20	36000	2
JONES	20	35700	4
BLAKE	30	34200	5
*/

SELECT T2.*
FROM
(
    SELECT T1.*
          , RANK() OVER(ORDER BY T1.���� DESC) "��ü��������"
    FROM 
    (
        SELECT ENAME "�����", DEPTNO "�μ���ȣ", SAL*12 + NVL(COMM, 0) "����"
        FROM EMP
    ) T1
) T2
WHERE T2.��ü�������� <=5;
--==>>
/*
KING	10	60000	1
SCOTT	20	36000	2
FORD	20	36000	2
JONES	20	35700	4
BLAKE	30	34200	5
*/


--�� EMP ���̺����� �� �μ����� ���� ����� 1�� ���� 2�� ������...
--   �����, �μ���ȣ, ����, �μ����������, ��ü������� �׸��� ��ȸ�� �� �ֵ��� �Ѵ�.

--1.
SELECT T.*
FROM 
(
    SELECT ENAME "�����", DEPTNO "�μ���ȣ", SAL*12 + NVL(COMM, 0) "����"
         , RANK() OVER(PARTITION BY DEPTNO ORDER BY SAL*12+NVL(COMM,0) DESC) "�μ����������"
         , RANK() OVER(ORDER BY SAL*12+NVL(COMM,0) DESC) "��ü�������"
    FROM EMP
) T
WHERE T.�μ���������� <= 2;

--2.
SELECT T2.*
FROM
(
    SELECT T1.*
          , RANK() OVER(PARTITION BY T1.�μ���ȣ ORDER BY T1.���� DESC) "�μ����������"
          , RANK() OVER(ORDER BY T1.���� DESC) "��ü�������"
    FROM 
    (
        SELECT ENAME "�����", DEPTNO "�μ���ȣ", SAL*12 + NVL(COMM, 0) "����"
        FROM EMP
    ) T1
) T2
WHERE T2.�μ���������� <=2;


--------------------------------------------------------------------------------

--���� �׷� �Լ� ����---

-- SUM() ��, AVG() ���, COUNT() ī��Ʈ, MAX() �ִ밪, MIN() �ּҰ�,
-- VARIANCE() �л�, STDDEV() ǥ������

--�� �׷� �Լ��� ���� ū Ư¡��
--   ó���ؾ� �� �����͵� �� NULL �� �����ϸ�
--   �� NULL �� �����ϰ� ������ �����Ѵٴ� ���̴�.

-- SUM()
-- EMP ���̺��� ������� ��ü ������� �޿� ������ ��ȸ�Ѵ�.
SELECT SUM(SAL)      -- 800 + 1600 + 1250 + 2975 + 1250 + 2850... 1300
FROM EMP;
--==>> 29025

SELECT SUM(COMM)     -- NULL+ + 300 + 500 + NULL + .... + NULL (��)
FROM EMP;            -- 300 + 500 + 1400 + 0                   (��)
--==>> 2200

-- COUNT()
-- ���� ���� ��ȸ�Ͽ� ����� ��ȯ
SELECT COUNT(ENAME)
FROM EMP;
--==>> 14

SELECT COUNT(SAL)
FROM EMP;
--==>> 14

SELECT COUNT(COMM)  -- COMM �÷��� ���� ���� ��ȸ �� NULL �� ����~!!!
FROM EMP;
--==>>  4

SELECT COUNT(*)
FROM EMP;
--==>>  4



--�� AVG()
-- ��� ��ȯ
SELECT SUM(SAL) / COUNT(SAL) "1", AVG(SAL) "2"
FROM EMP;
--==>>
/*
2073.214285714285714285714285714285714286	
2073.214285714285714285714285714285714286
*/

SELECT AVG(COMM)
FROM EMP;
--==>> 550

SELECT SUM(COMM) / COUNT(COMM)
FROM EMP;
--==>> 550

SELECT SUM(COMM) / 14
FROM EMP;
--==>> 157.142857142857142857142857142857142857

SELECT SUM(COMM) / COUNT(*)
FROM EMP;
--==>> 157.142857142857142857142857142857142857


--�� ǥ�������� ������ �л�
--   �л��� �������� ǥ������
SELECT AVG(SAL), VARIANCE(SAL), STDDEV(SAL)
FROM EMP;
--==>>
/*
2073.214285714285714285714285714285714286	
1398313.87362637362637362637362637362637	
1182.503223516271699458653359613061928508
*/

SELECT POWER(STDDEV(SAL), 2) "�޿�ǥ����������"
     , VARIANCE(SAL) "�޿��л�"
FROM EMP;
--==>>
/*
1398313.87362637362637362637362637362637	
1398313.87362637362637362637362637362637
*/

SELECT SQRT(VARIANCE(SAL)) "�޿��л�������"
     , STDDEV(SAL) "�޿�ǥ������"
FROM EMP;
--==>>
/*
1182.503223516271699458653359613061928508	
1182.503223516271699458653359613061928508
*/
--@ �������� ��� �صα�! �л�, ǥ������....


--�� MAX() / MIN()
--  �ִ밪   �ּҰ� ��ȯ
SELECT MAX(SAL), MIN(SAL)
FROM EMP;
--==>> 5000 800

--�� ����
SELECT ENAME, SUM(SAL)
FROM EMP;
--==>> ���� �߻�
/*
ORA-00937: not a single-group group function
00937. 00000 -  "not a single-group group function"
*Cause:    
*Action:
1,215��, 8������ ���� �߻�
*/

SELECT ENAME, SAL
FROM EMP;

SELECT ENAME, SUM(SAL)
FROM EMP;


SELECT DEPTNO, SUM(SAL) --@ �ΰ� ���, �����࿡ ������ �� �ִ� ����� ����!
FROM EMP;
--==>> ���� �߻�
/*
ORA-00937: not a single-group group function
00937. 00000 -  "not a single-group group function"
*Cause:    
*Action:
1,233��, 8������ ���� �߻�
*/


--�� �μ��� �޿��� ��ȸ
SELECT DEPTNO "�μ���ȣ", SUM(SAL) "�޿���"
FROM EMP
GROUP BY DEPTNO
--@ �μ����� ��ȣ���� ������...
ORDER BY DEPTNO;
--==>>
/*
10	 8750
20	10875
30	 9400
*/

--�� ������ �޿��� ��ȸ
SELECT JOB "������", SUM(SAL) "�޿���"
FROM EMP
GROUP BY JOB;
--==>>
/*
CLERK	    4150
SALESMAN	5600
PRESIDENT	5000
MANAGER	    8275
ANALYST	    6000
*/

SELECT DEPTNO "�μ���ȣ", SUM(SAL) "�޿���"
FROM EMP
GROUP BY ROLLUP(DEPTNO);


--------------------------------------------------------------------------------

-- ����...���μ�...���
--�� ������ �Է�
INSERT INTO TBL_EMP VALUES 
(8001, '������', 'CLERK', 7566, SYSDATE, 1500, 10, NULL);
--==>> 1 �� ��(��) ���ԵǾ����ϴ�.

INSERT INTO TBL_EMP VALUES 
(8002, '������', 'CLERK', 7566, SYSDATE, 1000, 0, NULL);
 --==>> 1 �� ��(��) ���ԵǾ����ϴ�.

--�� Ŀ��
COMMIT;
--==>> Ŀ�� �Ϸ�.

INSERT INTO TBL_EMP VALUES
(8003, '����', 'SALESMAN', 7698, SYSDATE, 2000, NULL, NULL);
--==>> 1 �� ��(��) ���ԵǾ����ϴ�.

INSERT INTO TBL_EMP VALUES
(8004, '�̵���', 'SALESMAN', 7698, SYSDATE, 2500, NULL, NULL);

INSERT INTO TBL_EMP VALUES
(8005, '���μ�', 'SALESMAN', 7698, SYSDATE, 1000, NULL, NULL);
--==>> 1 �� ��(��) ���ԵǾ����ϴ�.

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
--==>> Session��(��) ����Ǿ����ϴ�.

--�� Ȯ��
SELECT *
FROM TBL_EMP;
--==>>
/*
7369	SMITH	CLERK	    7902	1980-12-17	800		        20
7499	ALLEN	SALESMAN	7698	1981-02-20	1600	300	    30
7521	WARD	SALESMAN	7698	1981-02-22	1250	500	    30
7566	JONES	MANAGER	    7839	1981-04-02	2975		    20
7654	MARTIN	SALESMAN	7698	1981-09-28	1250   1400	    30
7698	BLAKE	MANAGER	    7839	1981-05-01	2850		    30
7782	CLARK	MANAGER	    7839	1981-06-09	2450		    10
7788	SCOTT	ANALYST	    7566	1987-07-13	3000		    20
7839	KING	PRESIDENT		    1981-11-17	5000		    10
7844	TURNER	SALESMAN	7698	1981-09-08	1500	   0	30
7876	ADAMS	CLERK	    7788	1987-07-13	1100		    20
7900	JAMES	CLERK	    7698	1981-12-03	950		        30
7902	FORD	ANALYST	    7566	1981-12-03	3000		    20
7934	MILLER	CLERK	    7782	1982-01-23	1300		    10
8003	����	SALESMAN	7698	2021-09-06	2000		
8004	�̵���	SALESMAN	7698	2021-09-06	2500		
8005	���μ�	SALESMAN	7698	2021-09-06	1000		
8001	������	CLERK	    7566	2021-09-03	1500	   10	
8002	������	CLERK	    7566	2021-09-03	1000	    0	
*/


--�� Ŀ��
COMMIT;
--==>> Ŀ�� �Ϸ�.







