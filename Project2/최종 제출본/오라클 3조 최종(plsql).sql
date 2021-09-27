SELECT USER
FROM DUAL;

--���� PL/SQL�� ����

--------------------------------------------------------------------------------
--�� Ʈ���� ����

--�� ���� ��й�ȣ DEFAULT Ʈ����
CREATE OR REPLACE TRIGGER TRG_PRO_PW
          BEFORE INSERT ON PROFESSOR
          FOR EACH ROW
BEGIN
    :NEW.PRO_PW := :NEW.PRO_LASTSSN;
END;


--�� �л� ��й�ȣ DEFAULT Ʈ����
CREATE OR REPLACE TRIGGER TRG_STU_PW
          BEFORE INSERT ON STUDENT
          FOR EACH ROW
BEGIN
    :NEW.STU_PW := :NEW.STU_LASTSSN;
END;

--------------------------------------------------------------------------------
--�� �ʿ��� �Լ� ����

-- 1. ���� ������ִ� �Լ�
CREATE OR REPLACE FUNCTION FN_SCORESUM
( V_LISTNO  SUB_LIST.LIST_NO%TYPE
, V_ATTEND  SCORE.ATTEND_SCORE%TYPE
, V_PRAC    SCORE.PRAC_SCORE%TYPE
, V_WRITE   SCORE.WRITE_SCORE%TYPE
)
RETURN NUMBER
IS
    VRESULT NUMBER(3);
    V_ADIV  SUB_LIST.ATTEND_DIV%TYPE;
    V_PDIV  SUB_LIST.PRAC_DIV%TYPE;
    V_WDIV  SUB_LIST.WRITE_DIV%TYPE;
    USER_DEFINE_ERROR EXCEPTION;
BEGIN
    SELECT ATTEND_DIV, PRAC_DIV, WRITE_DIV INTO V_ADIV, V_PDIV, V_WDIV
    FROM SUB_LIST
    WHERE LIST_NO = V_LISTNO;
    
    VRESULT := (V_ATTEND*V_ADIV + V_PRAC*V_PDIV + V_WRITE*V_WDIV)/100;
    
    IF (VRESULT > 100)
        THEN RAISE USER_DEFINE_ERROR; 
    END IF;
    
    RETURN VRESULT;
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20029, '������ ������ [100]�� �ʰ��� �� �����ϴ�.');
            
END;
--==> Function FN_SCORESUM��(��) �����ϵǾ����ϴ�.

--------------------------------------------------------------------------------
--�� ���ν��� ����

--1. ������ ���� ���� ���ν��� (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_ADMIN_INSERT
( V_ID   IN ADMIN.AD_ID%TYPE
, V_PW   IN ADMIN.AD_PW%TYPE
)
IS

BEGIN

    INSERT INTO ADMIN(AD_ID, AD_PW)
    VALUES(V_ID, V_PW);
    
END;
--==> Procedure PRC_ADMIN_INSERT��(��) �����ϵǾ����ϴ�.


-----------------------------------------------
--2. ������ ���� ���� ���ν��� (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_ADMIN_UPDATE
( V_ID          IN ADMIN.AD_ID%TYPE
, V_BEFORE_PW   IN ADMIN.AD_PW%TYPE
, V_AFTER_PW    IN ADMIN.AD_PW%TYPE
)
IS

BEGIN

    UPDATE ADMIN
    SET AD_PW = V_AFTER_PW
    WHERE AD_ID = V_ID
      AND AD_PW = V_BEFORE_PW;
    
END;
--==> Procedure PRC_ADMIN_UPDATE��(��) �����ϵǾ����ϴ�.


-----------------------------------------------
--3. ������ ���� ���� ���ν��� (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_ADMIN_DELETE
( V_ID   IN ADMIN.AD_ID%TYPE
, V_PW   IN ADMIN.AD_PW%TYPE
)
IS

BEGIN

    DELETE
    FROM ADMIN
    WHERE AD_ID = V_ID
      AND AD_PW = V_PW;
    
END;
--==> Procedure PRC_ADMIN_DELETE��(��) �����ϵǾ����ϴ�.


-----------------------------------------------
--4. ������ �α��� ���ν��� (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_ADMIN_LOGIN
( V_ID   IN ADMIN.AD_ID%TYPE
, V_PW   IN ADMIN.AD_PW%TYPE
)
IS
    TEMP_PW ADMIN.AD_PW%TYPE;
    TEMP_INUM   NUMBER;
    
    USER_DEFINE_ERROR EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO TEMP_INUM
    FROM ADMIN
    WHERE AD_ID=V_ID;
    
    IF (TEMP_INUM=0)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;

    SELECT AD_PW INTO TEMP_PW
    FROM ADMIN
    WHERE AD_ID = V_ID;
    
    IF (TEMP_PW != V_PW)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001, '���̵� �� ��й�ȣ�� ��ġ���� �ʽ��ϴ�.');

END;
--==>> Procedure PRC_ADMIN_LOGIN��(��) �����ϵǾ����ϴ�.


-----------------------------------------------
--5. ������ ���� ���� ���ν���(Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_PRO_INSERT
( V_ID          IN PROFESSOR.PRO_ID%TYPE
, V_NAME        IN PROFESSOR.PRO_NAME%TYPE
, V_FIRSTSSN    IN PROFESSOR.PRO_FIRSTSSN%TYPE
, V_LASTSSN     IN PROFESSOR.PRO_LASTSSN%TYPE
)
IS
    TEMP_ID  NUMBER;
    TEMP_NUM NUMBER;
    ID_ERROR EXCEPTION;
    SSN_ERROR EXCEPTION;
    SSN_NUM_ERROR EXCEPTION;
    
BEGIN
    --�ߺ� ID   
    SELECT COUNT(*) INTO TEMP_ID
    FROM PROFESSOR
    WHERE PRO_ID = V_ID;

    IF (TEMP_ID != 0)
        THEN RAISE ID_ERROR;
    END IF;
    
    --�ߺ� �ֹι�ȣ
    SELECT COUNT(*) INTO TEMP_NUM
    FROM PROFESSOR
    WHERE PRO_FIRSTSSN = V_FIRSTSSN
      AND PRO_LASTSSN = V_LASTSSN;

    IF (TEMP_NUM != 0)
        THEN RAISE SSN_ERROR;
    END IF;
    
    --�ֹι�ȣ �ڸ��� ���� �� ���ڸ� ù����(1~6)
    --5,6 �ܱ��ι�ȣ
    IF (LENGTH(V_FIRSTSSN) != 6 OR LENGTH(V_LASTSSN) != 7
        OR SUBSTR(V_LASTSSN, 1, 1) NOT IN ('1', '2', '3', '4', '5', '6'))
        THEN RAISE SSN_NUM_ERROR;
    END IF;
    
    
    --INSERT
    INSERT INTO PROFESSOR(PRO_ID, PRO_NAME, PRO_FIRSTSSN, PRO_LASTSSN)
    VALUES(V_ID, V_NAME, V_FIRSTSSN, V_LASTSSN);
    
    COMMIT;
    
    
    --����ó��
    EXCEPTION
        WHEN ID_ERROR
            THEN RAISE_APPLICATION_ERROR(-20018, '�̹� ��ϵ� ID�Դϴ�.');
                ROLLBACK;
        WHEN SSN_ERROR
            THEN RAISE_APPLICATION_ERROR(-20025, '�̹� ��ϵ� �������Դϴ�.');
                ROLLBACK;
        WHEN SSN_NUM_ERROR       
            THEN RAISE_APPLICATION_ERROR(-20002, '�Է��� �ֹι�ȣ�� ��ġ���� �ʽ��ϴ�.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
            
END;
--==>> Procedure PRC_PRO_INSERT��(��) �����ϵǾ����ϴ�.

--------------------------------------------------------------------------------
--6. ������ ���� ���� ���ν��� (��й�ȣ�� ���� ����) (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_PRO_UPDATE
( V_ID          IN PROFESSOR.PRO_ID%TYPE
, V_FIRSTSSN    IN PROFESSOR.PRO_FIRSTSSN%TYPE
, V_LASTSSN     IN PROFESSOR.PRO_LASTSSN%TYPE
, V_PW          IN PROFESSOR.PRO_PW%TYPE
, V_NAME        IN PROFESSOR.PRO_NAME%TYPE
)
IS
    TEMP_ID     NUMBER;
    TEMP_SSN    CHAR(13);
    ID_ERROR  EXCEPTION;
    SSN_ERROR EXCEPTION;
    
BEGIN
    --�߸��� ID
    SELECT COUNT(*) INTO TEMP_ID
    FROM PROFESSOR
    WHERE PRO_ID = V_ID;
        
    IF (TEMP_ID = 0)
        THEN RAISE ID_ERROR;
    END IF;
    
    --�߸��� �ֹι�ȣ
    SELECT CONCAT(PRO_FIRSTSSN, PRO_LASTSSN) INTO TEMP_SSN
    FROM PROFESSOR
    WHERE PRO_ID = V_ID;

    IF (TEMP_SSN != (V_FIRSTSSN || V_LASTSSN))
        THEN RAISE SSN_ERROR;
    END IF;
    
    
    --UPDATE
    UPDATE PROFESSOR
    SET PRO_PW = V_PW
    WHERE PRO_ID = V_ID
      AND PRO_FIRSTSSN = V_FIRSTSSN
      AND PRO_LASTSSN = V_LASTSSN;
      
    COMMIT;
    
    
    --����ó��
    EXCEPTION
        WHEN ID_ERROR
            THEN RAISE_APPLICATION_ERROR(-20015, '�Է��� ID�� �������� �ʽ��ϴ�.');
                ROLLBACK;
        WHEN SSN_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002, '�Է��� �ֹι�ȣ�� ��ġ���� �ʽ��ϴ�.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;

END;
--==>> Procedure PRC_PRO_UPDATE��(��) �����ϵǾ����ϴ�.

--------------------------------------------------------------------------------
--7. ������ ���� ���� ���ν��� (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_PRO_DELETE
( V_ID IN PROFESSOR.PRO_ID%TYPE
, V_PW IN PROFESSOR.PRO_PW%TYPE
)
IS
    TEMP_NUM    NUMBER;
    TEMP_PW PROFESSOR.PRO_PW%TYPE;
    ID_PW_ERROR EXCEPTION;
BEGIN
    --ID ����ġ
    SELECT COUNT(*) INTO TEMP_NUM
    FROM PROFESSOR
    WHERE PRO_ID = V_ID;
    
    IF (TEMP_NUM=0)
        THEN RAISE ID_PW_ERROR;
    END IF;
    
    --PW ����ġ
    SELECT PRO_PW INTO TEMP_PW
    FROM PROFESSOR
    WHERE PRO_ID = V_ID;

    IF (TEMP_PW != V_PW)
        THEN RAISE ID_PW_ERROR;
    END IF;
    
    DELETE
    FROM PROFESSOR
    WHERE PRO_ID = V_ID
      AND PRO_PW = V_PW;
    
   COMMIT;
   
   EXCEPTION
    WHEN ID_PW_ERROR
        THEN RAISE_APPLICATION_ERROR(-20001, '���̵� �� ��й�ȣ�� ��ġ���� �ʽ��ϴ�.');
   
END;
--==>> Procedure PRO_PROFESSOR_DELETE��(��) �����ϵǾ����ϴ�.

--------------------------------------------------------------------------------
--8. ������ �α��� ���ν��� (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_PRO_LOGIN
( V_ID   IN PROFESSOR.PRO_ID%TYPE
, V_PW   IN PROFESSOR.PRO_PW%TYPE
)
IS
    TEMP_PW PROFESSOR.PRO_PW%TYPE;
    TEMP_INUM NUMBER;
    
    USER_DEFINE_ERROR EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO TEMP_INUM
    FROM PROFESSOR
    WHERE PRO_ID=V_ID;
    
    IF (TEMP_INUM=0)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    SELECT PRO_PW INTO TEMP_PW
    FROM PROFESSOR
    WHERE PRO_ID = V_ID;
    
    IF (TEMP_PW != V_PW)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001, '���̵� �� ��й�ȣ�� ��ġ���� �ʽ��ϴ�.');

END;
--==>> Procedure PRC_PRO_LOGIN��(��) �����ϵǾ����ϴ�.


--------------------------------------------------------------------------------
--9. ���ǽ� �Է� ���ν��� (���ǽ� �Է��� ����Ǿ�� �������� �Է½� ���ǽ� ���� ����) (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_ROOM_INSERT
( V_ROOM_NO         IN ROOM.ROOM_NO%TYPE
, V_ROOM_CAPACITY   IN ROOM.ROOM_CAPACITY%TYPE
)
IS
    TEMP_NUM            NUMBER; --���ǽ� ��ȣ�� �ߺ��� ������ Ȯ���ϱ� ���� �ӽ� ����
    USER_DEFINE_ERROR   EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO TEMP_NUM
    FROM ROOM
    WHERE ROOM_NO=V_ROOM_NO;
    
    IF (TEMP_NUM!=0)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    INSERT INTO ROOM(ROOM_NO, ROOM_CAPACITY) VALUES(V_ROOM_NO, V_ROOM_CAPACITY);
    
    COMMIT;
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20020, '�̹� ��ϵ� ���ǽ��Դϴ�.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==> Procedure PRC_ROOM_INSERT��(��) �����ϵǾ����ϴ�.


--------------------------------------------------------------------------------
--10. ���ǽ� ���� ���ν��� (�Է��� ��������� Ȥ�� ����...) (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_ROOM_DELETE
( V_ROOM_NO         IN ROOM.ROOM_NO%TYPE
)
IS
    TEMP_RNUM       NUMBER; --�Է��� ���ǽ��� �����ϴ��� Ȯ���� ���� �ӽú���
    
    ROOM_ERROR      EXCEPTION; --�Է��� ���ǽ��� �������� ���� ���
BEGIN
    --�Է��� ���ǽ��� �������� ���� ��� ���� �߻�
    SELECT COUNT(*) INTO TEMP_RNUM
    FROM ROOM
    WHERE ROOM_NO=V_ROOM_NO;
    
    IF (TEMP_RNUM=0)
        THEN RAISE ROOM_ERROR;
    END IF;
    
    --DELETE ���� �ۼ�
    DELETE
    FROM ROOM
    WHERE ROOM_NO=V_ROOM_NO;
    
    COMMIT;
    
    --���� ó��
    EXCEPTION
        WHEN ROOM_ERROR
            THEN RAISE_APPLICATION_ERROR(-20003, '�Է��� ���ǽ��� �������� �ʽ��ϴ�.');
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==> Procedure PRC_ROOM_DELETE��(��) �����ϵǾ����ϴ�.


--------------------------------------------------------------------------------
--�� ������ȣ�� ���� ������ ����(SQL�������� ����) -> SEQ_CURRICULUM

--11. ���� ���� �Է� ���ν��� (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_CUR_INSERT
( V_CUR_NAME        IN CURRICULUM.CUR_NAME%TYPE
, V_CUR_STARTDATE   IN CURRICULUM.CUR_STARTDATE%TYPE
, V_CUR_ENDDATE      IN CURRICULUM.CUR_ENDDATE%TYPE
, V_ROOM_NO         IN CURRICULUM.ROOM_NO%TYPE
)
IS
    V_CUR_NO    CURRICULUM.CUR_NO%TYPE;
    
    TEMP_RNUM    NUMBER; --�Է��� ���ǽ��� �����ϴ��� Ȯ���� ���� �ӽú���
    TEMP_NNUM    NUMBER; --�Է��� �������� �ߺ����� Ȯ���� ���� �ӽú���
    
    STARTDATE_ERROR   EXCEPTION; --������>�����϶� �߻��ϴ� ����
    ROOM_ERROR   EXCEPTION; --�Է��� ���ǽ��� �������� ���� ��� �߻��ϴ� ����
    NAME_ERROR   EXCEPTION; --�Է��� �������� �ߺ��� ��� �߻��ϴ� ����
BEGIN
    --�������� ���Ϻ��� �̷��� �Է��� ��� ���� �߻�
    IF (V_CUR_STARTDATE>V_CUR_ENDDATE)
        THEN RAISE STARTDATE_ERROR;
    END IF;
    
    --�Է��� ���ǽ��� �������� ���� ��� ���� �߻�
    SELECT COUNT(*) INTO TEMP_RNUM
    FROM ROOM
    WHERE ROOM_NO=V_ROOM_NO;
    
    IF (TEMP_RNUM=0)
        THEN RAISE ROOM_ERROR;
    END IF;
    
    --������(UNIQUE)�� �ߺ��Ǹ� �ȵ�
    SELECT COUNT(*) INTO TEMP_NNUM
    FROM CURRICULUM
    WHERE CUR_NAME=V_CUR_NAME;
    
    IF (TEMP_NNUM!=0)
        THEN RAISE NAME_ERROR;
    END IF;
    
    --������ȣ ����(CUR-1, CUR-2, ..., CUR-999 �� ����)
    V_CUR_NO := ('CUR-' || TO_CHAR(SEQ_CURRICULUM.NEXTVAL));
    
    --INSERT ������ �ۼ�
    INSERT INTO CURRICULUM(CUR_NO, CUR_NAME, CUR_STARTDATE, CUR_ENDDATE, ROOM_NO)
    VALUES(V_CUR_NO, V_CUR_NAME, V_CUR_STARTDATE, V_CUR_ENDDATE, V_ROOM_NO);
    
    COMMIT;
    
    -- ����ó��
    EXCEPTION
        WHEN STARTDATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20030, '�������� ������ ���� ��¥�� �����ؾ� �մϴ�.');
        WHEN ROOM_ERROR
            THEN RAISE_APPLICATION_ERROR(-20003, '�Է��� ���ǽ��� �������� �ʽ��ϴ�.');
        WHEN NAME_ERROR
            THEN RAISE_APPLICATION_ERROR(-20024, '�̹� ��ϵ� �����Դϴ�.');
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==> Procedure PRC_CUR_INSERT��(��) �����ϵǾ����ϴ�.


--------------------------------------------------------------------------------
--12. ���� ���� ���� ���ν��� (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_CUR_UPDATE
( V_CUR_NO          IN CURRICULUM.CUR_NO%TYPE
, V_CUR_NAME        IN CURRICULUM.CUR_NAME%TYPE
, V_CUR_STARTDATE   IN CURRICULUM.CUR_STARTDATE%TYPE
, V_CUR_ENDDATE     IN CURRICULUM.CUR_ENDDATE%TYPE
, V_ROOM_NO         IN CURRICULUM.ROOM_NO%TYPE
)
IS
    TEMP_NONUM   NUMBER; --������ȣ �Է� Ȯ�� �ӽú���
    TEMP_RNUM    NUMBER; --�Է��� ���ǽ��� �����ϴ��� Ȯ���� ���� �ӽú���
    TEMP_NNUM    NUMBER; --�Է��� �������� �ߺ����� Ȯ���� ���� �ӽú���
    TEMP_SDNUM   NUMBER; --���������ϰ� ��������� �� �ӽú���
    TEMP_EDNUM   NUMBER; --���������ϰ� ���������� �� �ӽú���
    
    NUMBER_ERROR    EXCEPTION; --������ȣ �������� ������� 
    STARTDATE_ERROR EXCEPTION; --�������� �����Ϻ��� �̸� ���
    ROOM_ERROR      EXCEPTION; --�Է��� ���ǽ��� �������� ���� ���
    NAME_ERROR      EXCEPTION; --�Է��� �������� �̹� ������ ���
    DATE_ERROR      EXCEPTION; --1. ������ ��ϵ� ����� �������� �����Ϸ��� ���������Ϻ��� �̸� ���
                                --2. ������ ��ϵ� ����� �������� ���� �����Ϻ��� �̸� ��� ���� �߻�
                                --[���� ������ (����1) (����2) (����3) ����������]
BEGIN
    --�Է��� ������ȣ�� �����ϴ��� Ȯ��
    SELECT COUNT(*) INTO TEMP_NONUM
    FROM CURRICULUM
    WHERE CUR_NO=V_CUR_NO;
    
    IF (TEMP_NONUM=0)
        THEN RAISE NUMBER_ERROR;
    END IF;
    
    --�������� ���Ϻ��� �̷��� �Է��� ��� ���� �߻�
    IF (V_CUR_STARTDATE>V_CUR_ENDDATE)
        THEN RAISE STARTDATE_ERROR;
    END IF;
    
    --�Է��� ���ǽ��� �������� ���� ��� ���� �߻�
    SELECT COUNT(*) INTO TEMP_RNUM
    FROM ROOM
    WHERE ROOM_NO=V_ROOM_NO;
    
    IF (TEMP_RNUM=0)
        THEN RAISE ROOM_ERROR;
    END IF;
    
    --������(UNIQUE)�� �ߺ��Ǹ� �ȵ�
    SELECT COUNT(*) INTO TEMP_NNUM
    FROM CURRICULUM
    WHERE CUR_NAME=V_CUR_NAME
      AND CUR_NO!=V_CUR_NO; --UPDATE�ϰ��� �ϴ� ���� ����
    
    IF (TEMP_NNUM!=0)
        THEN RAISE NAME_ERROR;
    END IF;
    
    --����������[ (���� ������ ~ ���� ������) ]���� ������ �� ���¸� ��� ��� ����
    SELECT CASE WHEN MIN(SUB_STARTDATE) < V_CUR_STARTDATE THEN 0 ELSE 1 END
            INTO TEMP_SDNUM
            --����1 : ����������<��������� �� ���� ��߳��� 0, �ش�Ǹ� 1 (����������� NULL�̾ 1)
    FROM SUB_LIST
    WHERE CUR_NO=V_CUR_NO;
    
    SELECT CASE WHEN MAX(SUB_ENDDATE) > V_CUR_ENDDATE THEN 0 ELSE 1 END
            INTO TEMP_EDNUM
            --����2 : ����������>���������� �� ���� ��߳��� 0, �ش�Ǹ� 1 (������������ NULL�̾ 1)
    FROM SUB_LIST
    WHERE CUR_NO=V_CUR_NO;
    
    IF (TEMP_SDNUM=0 OR TEMP_EDNUM=0)
        THEN RAISE DATE_ERROR;
    END IF;

    --UPDATE ���� �ۼ�
    UPDATE CURRICULUM
    SET CUR_NAME=V_CUR_NAME, CUR_STARTDATE=V_CUR_STARTDATE, CUR_ENDDATE=V_CUR_ENDDATE, ROOM_NO=V_ROOM_NO
    WHERE CUR_NO=V_CUR_NO;
    
    COMMIT;
    
    --����ó��
    EXCEPTION
        WHEN NUMBER_ERROR
            THEN RAISE_APPLICATION_ERROR(-20005, '�Է��� ������ȣ�� �������� �ʽ��ϴ�.');
        WHEN STARTDATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20030, '�������� ������ ���� ��¥�� �����ؾ� �մϴ�.');
        WHEN ROOM_ERROR
            THEN RAISE_APPLICATION_ERROR(-20003, '�Է��� ���ǽ��� �������� �ʽ��ϴ�.');
        WHEN NAME_ERROR
            THEN RAISE_APPLICATION_ERROR(-20024, '�̹� ��ϵ� �����Դϴ�.');
        WHEN DATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20031, '���� �Ⱓ�� ���� �Ⱓ�� �ʰ��� �� �����ϴ�.');
            
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==> Procedure PRC_CUR_UPDATE��(��) �����ϵǾ����ϴ�.


--------------------------------------------------------------------------------
--13. ���� ���� ���� ���ν��� (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_CUR_DELETE
( V_CUR_NO          IN CURRICULUM.CUR_NO%TYPE
)
IS
    TEMP_NONUM   NUMBER; --������ȣ �Է� Ȯ�� �ӽú���
    TEMP_DATE    CURRICULUM.CUR_STARTDATE%TYPE;
    
    NUMBER_ERROR    EXCEPTION; --������ȣ �������� �������
    DATE_ERROR      EXCEPTION;
BEGIN
    --�Է��� ������ȣ�� �����ϴ��� Ȯ��
    SELECT COUNT(*) INTO TEMP_NONUM
    FROM CURRICULUM
    WHERE CUR_NO=V_CUR_NO;
    
    IF (TEMP_NONUM=0)
        THEN RAISE NUMBER_ERROR;
    END IF;
    
    --�̹� �������� �����̸� ���� �� ����
    SELECT CUR_STARTDATE INTO TEMP_DATE
    FROM CURRICULUM
    WHERE CUR_NO=V_CUR_NO;
    
    IF (SYSDATE>=TEMP_DATE)
        THEN RAISE DATE_ERROR;
    END IF;
    
    --DELETE ���� �ۼ�
    DELETE
    FROM CURRICULUM
    WHERE CUR_NO=V_CUR_NO;
    
    COMMIT;
    
    --����ó��
    EXCEPTION
        WHEN NUMBER_ERROR
            THEN RAISE_APPLICATION_ERROR(-20005, '�Է��� ������ȣ�� �������� �ʽ��ϴ�.');
        WHEN DATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20036, '�̹� ���۵� �����Դϴ�.');
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>> Procedure PRC_CUR_DELETE��(��) �����ϵǾ����ϴ�.

--------------------------------------------------------------------------------
--(����-����-���񰳼�)

--14. ���� �Է� ���ν��� (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_BOOK_INSERT
( V_BOOK_NAME      IN BOOK.BOOK_NAME%TYPE
, V_AUTHOR_NAME   IN BOOK.AUTHOR_NAME%TYPE   
, V_PUBLISHER      IN BOOK.PUBLISHER%TYPE
)
IS
   V_BOOK_NO     BOOK.BOOK_NO%TYPE;    --������ȣ ���� �ӽú���

   TEMP_NUM      NUMBER;    --�����ȣ�� �ߺ��� ������ Ȯ���ϱ� ���� �ӽú���
   
    USER_DEFINE_ERROR   EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO TEMP_NUM            --�̹� �����ϸ� ����
    FROM BOOK
    WHERE BOOK_NAME=V_BOOK_NAME;

    IF (TEMP_NUM!=0)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;

   --�����ȣ ����
   V_BOOK_NO :=  ('BOOK-' || TO_CHAR(SEQ_BOOK.NEXTVAL));

   --INSERT ������ �ۼ�
   INSERT INTO BOOK(BOOK_NO, BOOK_NAME,AUTHOR_NAME,PUBLISHER) 
   VALUES(V_BOOK_NO, V_BOOK_NAME,V_AUTHOR_NAME,V_PUBLISHER);

   COMMIT;

   --���� ó��
   EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20019, '�̹� ��ϵ� �����Դϴ�.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==> Procedure PRC_BOOK_INSERT��(��) �����ϵǾ����ϴ�.


--------------------------------------------------------------------------------
--15. ���� ���� ���ν��� (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_BOOK_DELETE
( V_BOOK_NO      IN BOOK.BOOK_NO%TYPE
)
IS 
   TEMP_NUM    NUMBER;  --�����ȣ �Է�Ȯ�� �ӽú���
   BOOK_ERROR   EXCEPTION;  --�����ȣ �������� ������   
BEGIN
   --�Է��� ���� ���翩�� Ȯ��
   SELECT COUNT(*) INTO TEMP_NUM
   FROM BOOK
   WHERE BOOK_NO = V_BOOK_NO;

   IF (TEMP_NUM=0)
      THEN RAISE BOOK_ERROR;
   END IF;

   --DELETE ������ �ۼ�
   DELETE
   FROM BOOK
   WHERE BOOK_NO=V_BOOK_NO;

   COMMIT;

   --����ó��
   EXCEPTION
     WHEN BOOK_ERROR
        THEN  RAISE_APPLICATION_ERROR(-20006, '�Է��� �����ȣ�� �������� �ʽ��ϴ�.');
            ROLLBACK;
     WHEN OTHERS
         THEN ROLLBACK;
END;
--==> Procedure PRC_BOOK_DELETE��(��) �����ϵǾ����ϴ�.


--------------------------------------------------------------------------------
--16. ���� �Է� ���ν���(Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_SUB_INSERT
( V_SUB_NAME    IN SUBJECT.SUB_NAME%TYPE
, V_BOOK_NO     IN SUBJECT.SUB_NAME%TYPE   
)
IS
    V_SUB_NO     SUBJECT.SUB_NO%TYPE;
    TEMP_NUM     NUMBER;
    TEMP_NUM2    NUMBER;
    SUB_ERROR   EXCEPTION;
    BOOK_NUM_ERROR  EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO TEMP_NUM
    FROM SUBJECT
    WHERE SUB_NAME = V_SUB_NAME;
    
    SELECT COUNT(*) INTO TEMP_NUM2
    FROM BOOK
    WHERE BOOK_NO = V_BOOK_NO;
    
    --����� ���� ����
    IF (TEMP_NUM!=0)
        THEN RAISE SUB_ERROR;
    END IF;
    
    --�����ȣ�� �������̺� ��ϵ��� �ʾ��� ���
    IF (TEMP_NUM2=0)
        THEN RAISE BOOK_NUM_ERROR;
    END IF;
    

    --�����ȣ
    V_SUB_NO :=  ('SUB-' || TO_CHAR(SEQ_SUBJECT.NEXTVAL));

    --INSERT
    INSERT INTO SUBJECT(SUB_NO, SUB_NAME, BOOK_NO)
    VALUES(V_SUB_NO, V_SUB_NAME, V_BOOK_NO);
    
    COMMIT;
    
    
    --���� ó��
    EXCEPTION
        WHEN SUB_ERROR
            THEN RAISE_APPLICATION_ERROR(-20022, '�̹� ��ϵ� �����Դϴ�.');
                 ROLLBACK;
        WHEN BOOK_NUM_ERROR
            THEN RAISE_APPLICATION_ERROR(-20006, '�Է��� �����ȣ�� �������� �ʽ��ϴ�.');
                 ROLLBACK;
        WHEN OTHERS THEN ROLLBACK;
END;
--==>> Procedure PRC_SUB_INSERT��(��) �����ϵǾ����ϴ�.

--------------------------------------------------------------------------------
--17. ���� ���� ���ν��� (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_SUB_UPDATE
( V_SUB_NO          IN SUBJECT.SUB_NO%TYPE
, V_SUB_NAME      IN SUBJECT.SUB_NAME%TYPE
, V_BOOK_NO       IN BOOK.BOOK_NAME%TYPE
)
IS
   TEMP_SBNUM      NUMBER;  --�����ȣ �Է�Ȯ�� �ӽú���
   TEMP_BOOKNO  BOOK.BOOK_NO%TYPE;  --�����ȣ�� �����ϴ��� Ȯ���ϴ� �ӽú���
 
   SUBNUM_ERROR   EXCEPTION;  --�����ȣ �������� ������
   BOOKNO_ERROR EXCEPTION;  -- �����ȣ�� �������� ���� ��
  
BEGIN
   --�Է��� �����ȣ ���翩�� Ȯ��
   SELECT COUNT(*) INTO TEMP_SBNUM 
   FROM SUBJECT
   WHERE SUB_NO = V_SUB_NO;

   IF (TEMP_SBNUM=0)
      THEN RAISE SUBNUM_ERROR;
   END IF;
   
   SELECT COUNT(*) INTO TEMP_BOOKNO
   FROM BOOK
   WHERE BOOK_NO = V_BOOK_NO;
   
   IF (TEMP_BOOKNO = 0)
    THEN RAISE BOOKNO_ERROR;
   END IF;

   --UPDATE ������ �ۼ�
   UPDATE SUBJECT
   SET SUB_NO=V_SUB_NO, SUB_NAME=V_SUB_NAME, BOOK_NO=V_BOOK_NO
   WHERE SUB_NO = V_SUB_NO;

   COMMIT;

   --����ó��
   EXCEPTION
     WHEN SUBNUM_ERROR
          THEN RAISE_APPLICATION_ERROR(-20012, '�Է��� �����ȣ�� �������� �ʽ��ϴ�.');
                     ROLLBACK;
    WHEN BOOKNO_ERROR
        THEN RAISE_APPLICATION_ERROR(-20014, '�Է��� �����ȣ�� �������� �ʽ��ϴ�.');
    WHEN OTHERS
      THEN ROLLBACK;
END;
--==> Procedure PRC_SUB_UPDATE��(��) �����ϵǾ����ϴ�.

--------------------------------------------------------------------------------
--18. ���� ���� ���ν���(Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_SUB_DELETE
( V_SUB_NO      IN SUBJECT.SUB_NO%TYPE
, V_SUB_NAME    IN SUBJECT.SUB_NAME%TYPE
)
IS
    TEMP_NUM    NUMBER;
    TEMP_NAME   SUBJECT.SUB_NAME%TYPE;
    
    SUB_ERROR  EXCEPTION;
BEGIN
    -- �������� �ʴ� �����ȣ ����
    SELECT COUNT(*) INTO TEMP_NUM
    FROM SUBJECT
    WHERE SUB_NO = V_SUB_NO;
    
    IF (TEMP_NUM = 0)
        THEN RAISE SUB_ERROR;
    END IF;
      
    -- ������ �����ȣ ����ġ
    SELECT SUB_NAME INTO TEMP_NAME
    FROM SUBJECT
    WHERE SUB_NO = V_SUB_NO;
    
    IF (TEMP_NAME != V_SUB_NAME)
        THEN RAISE SUB_ERROR;
    END IF;
    
    
    --DELETE
    DELETE
    FROM SUBJECT
    WHERE SUB_NO = V_SUB_NO
      AND SUB_NAME = V_SUB_NAME;
    
    COMMIT;
    
       
    --���� ó��
    EXCEPTION
        WHEN SUB_ERROR
            THEN RAISE_APPLICATION_ERROR(-20007, '�Է��� ������ �������� �ʽ��ϴ�.');
                 ROLLBACK;
        WHEN OTHERS THEN ROLLBACK;
END;
--==>> Procedure PRC_SUBJECT_DELETE��(��) �����ϵǾ����ϴ�.

--------------------------------------------------------------------------------
--19. ���񰳼� �Է� ���ν��� (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_SLI_INSERT
( V_CUR_NO            IN SUB_LIST.CUR_NO%TYPE
, V_SUB_NO            IN SUB_LIST.SUB_NO%TYPE
, V_SUB_STARTDATE     IN SUB_LIST.SUB_STARTDATE%TYPE
, V_SUB_ENDDATE       IN SUB_LIST.SUB_ENDDATE%TYPE
, V_PRO_ID            IN SUB_LIST.PRO_ID%TYPE
, V_ATTEND_DIV        IN SUB_LIST.ATTEND_DIV%TYPE
, V_PRAC_DIV          IN SUB_LIST.PRAC_DIV%TYPE
, V_WRITE_DIV         IN SUB_LIST.WRITE_DIV%TYPE
)
IS
    V_SLI_NO        SUB_LIST.LIST_NO%TYPE;  -- ������ ������ �ʿ��� ����
    TEMP_NUM        NUMBER;                 -- �����ȣ ���翩�� Ȯ�ο� �ʿ��� ����
    
    DATE_ERROR      EXCEPTION; -- 1. �����ȣ�� �̹� ������ �� �߻��ϴ� ����
    SUB_NO_ERROR    EXCEPTION; -- 2. ���� �������� ���� �����Ϻ��� �̷��� �� �߻��ϴ� ����
    DIV_ERROR       EXCEPTION; -- 3. ���, �Ǳ�, �ʱ� ������ ���� 0���� ���� �� �߻��ϴ� ����
    DIV_SUM_ERROR   EXCEPTION; -- 4. ���, �Ǳ�, �ʱ� ������ ��ġ�� 100�� ���� ���� �� �߻��ϴ� ����
    
BEGIN
    -- 1. �����ȣ�� �̹� ������ �� ���� �߻�
    SELECT COUNT(*) INTO TEMP_NUM
    FROM SUB_LIST
    WHERE SUB_NO = V_SUB_NO;
    
    IF (TEMP_NUM != 0)
        THEN RAISE SUB_NO_ERROR;
    END IF;
    
    -- 2. ���� ������ > ���� �������� �� ���� �߻�
    IF (V_SUB_STARTDATE > V_SUB_ENDDATE)
        THEN RAISE DATE_ERROR;
    END IF;

    -- 3. ���, �Ǳ�, �ʱ� ������ ���� 0���� ���� �� ���� �߻�
    IF ( (V_ATTEND_DIV < 0) OR (V_PRAC_DIV < 0) OR (V_WRITE_DIV < 0) )
        THEN RAISE DIV_ERROR;
    END IF;
    
    -- 4. ���, �Ǳ�, �ʱ� ������ ��ġ�� 100�� ���� ���� �� ���� �߻�
    IF (V_ATTEND_DIV + V_PRAC_DIV + V_WRITE_DIV != 100)
        THEN RAISE DIV_SUM_ERROR;
    END IF;

    -- ������ȣ ����(������ Ȱ���� ���� �ڵ� �����ǰ� ����)
    V_SLI_NO := ('SLI-' || TO_CHAR(SEQ_SUB_LIST.NEXTVAL));
    
    -- INSERT ���� �ۼ�
    INSERT INTO SUB_LIST(LIST_NO, CUR_NO, SUB_NO, SUB_STARTDATE, SUB_ENDDATE, PRO_ID, ATTEND_DIV, PRAC_DIV, WRITE_DIV)
    VALUES(V_SLI_NO, V_CUR_NO, V_SUB_NO, V_SUB_STARTDATE, V_SUB_ENDDATE, V_PRO_ID, V_ATTEND_DIV, V_PRAC_DIV, V_WRITE_DIV);
    
    COMMIT;
    
    -- ���� ó��
    EXCEPTION 
        WHEN SUB_NO_ERROR
            THEN RAISE_APPLICATION_ERROR(-20022, '�̹� ��ϵ� �����Դϴ�.'); 
            ROLLBACK;
        WHEN DATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20030, '�������� ������ ���� ��¥�� �����ؾ� �մϴ�.');
            ROLLBACK;
        WHEN DIV_ERROR
            THEN RAISE_APPLICATION_ERROR(-20028, '[0 - 100]�� ���� ������ �Է� �����մϴ�.');
            ROLLBACK;
        WHEN DIV_SUM_ERROR
            THEN RAISE_APPLICATION_ERROR(-20027, '������ ������ [100] �̾�� �մϴ�.');
            ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>> Procedure PRC_SLI_INSERT��(��) �����ϵǾ����ϴ�.

--------------------------------------------------------------------------------
--20. ���񰳼� ���� ���ν��� (Ȯ��)
--�Է½� �޴� �׸� : (������, �����, ���� �Ⱓ(���� ������, �� ������), ���� ��, ������ ��)
--���� �����̸� ���� ���縦 ����ϹǷ� ���翡 ���� ���������� ����
CREATE OR REPLACE PROCEDURE PRC_SUBLIST_UPDATE
( V_LIST_NO         IN SUB_LIST.LIST_NO%TYPE
, V_SUB_NAME        IN SUBJECT.SUB_NAME%TYPE
, V_SUB_STARTDATE   IN SUB_LIST.SUB_STARTDATE%TYPE
, V_SUB_ENDDATE     IN SUB_LIST.SUB_ENDDATE%TYPE
, V_PRO_ID          IN SUB_LIST.PRO_ID%TYPE
)
IS
    V_SUB_NO        SUB_LIST.SUB_NO%TYPE; --������Ʈ�� �����ȣ�� �����ϴ� ����
    V_CUR_NO        SUB_LIST.CUR_NO%TYPE; --������Ʈ�� ������ ���� ��ȣ�� �����ϴ� ����
    V_CUR_STARTDATE CURRICULUM.CUR_STARTDATE%TYPE;  --���� ������ �����ϴ� ����
    V_CUR_ENDDATE   CURRICULUM.CUR_ENDDATE%TYPE;    --���� ������ �����ϴ� ����
    
    TEMP_LNUM       NUMBER; --���񰳼���ȣ ���翩�� Ȯ�� �ӽú���
    TEMP_NNUM       NUMBER; --����� ���翩�� Ȯ�� �ӽú���
    TEMP_PNUM       NUMBER; --������ �����ϴ��� Ȯ�� �ӽú���
    
    LISTNO_ERROR    EXCEPTION;
    NAME_ERROR      EXCEPTION;
    PROF_ERROR      EXCEPTION;
    DATE_ERROR      EXCEPTION;
BEGIN
    --���񰳼���ȣ�� �������� ���� ���
    SELECT COUNT(*) INTO TEMP_LNUM
    FROM SUB_LIST
    WHERE LIST_NO=V_LIST_NO;
    
    IF (TEMP_LNUM=0)
        THEN RAISE LISTNO_ERROR;
    END IF;
    
    --������ ������� ���� ���̺� ����� �Ǿ� �ִ��� Ȯ��(������ ����)
    SELECT COUNT(*) INTO TEMP_NNUM
    FROM SUBJECT
    WHERE SUB_NAME=V_SUB_NAME;
    
    IF (TEMP_NNUM=0)
        THEN RAISE NAME_ERROR;
    END IF;
    
    --������ ���� ���̵� �����ϴ��� Ȯ��(������ ����)
    SELECT COUNT(*) INTO TEMP_PNUM
    FROM PROFESSOR
    WHERE PRO_ID=V_PRO_ID;
    
    IF (TEMP_PNUM=0)
        THEN RAISE PROF_ERROR;
    END IF;

    --������ ���� �Ⱓ�� ���� �Ⱓ ������ ����� �ȵ�
    --����1 ����������<=���������
    --����2 ����������>=����������
    SELECT CUR_NO INTO V_CUR_NO     --������ȣ ���
    FROM SUB_LIST
    WHERE LIST_NO=V_LIST_NO;
    
    SELECT NVL(CUR_STARTDATE, V_SUB_STARTDATE), NVL(CUR_ENDDATE, V_SUB_ENDDATE)
            INTO V_CUR_STARTDATE, V_CUR_ENDDATE
            --�����Ⱓ ���(�����Ⱓ�� NULL�ϰ�� �񱳸� ���� ������ ����Ⱓ�� ����)
    FROM CURRICULUM
    WHERE CUR_NO=V_CUR_NO;
    
    IF (V_CUR_STARTDATE>V_SUB_STARTDATE OR V_CUR_ENDDATE<V_SUB_ENDDATE)
        --����1�� ������ �� �Ǹ�           --����2�� ������ �� �Ǹ�
        THEN RAISE DATE_ERROR; --���� �߻�
    END IF;
    
    
    --������ ����� �ش��ϴ� �����ȣ ������ ����
    SELECT SUB_NO INTO V_SUB_NO
    FROM SUBJECT
    WHERE SUB_NAME=V_SUB_NAME;
    
    --UPDATE ������ �ۼ�
    UPDATE SUB_LIST
    SET SUB_STARTDATE=V_SUB_STARTDATE, SUB_ENDDATE=V_SUB_ENDDATE, PRO_ID=V_PRO_ID, SUB_NO=V_SUB_NO
    WHERE LIST_NO=V_LIST_NO;
    
    COMMIT;
    
    --����ó��
    EXCEPTION
    WHEN LISTNO_ERROR
        THEN RAISE_APPLICATION_ERROR(-20035, '������ ������ �����ϴ�.');
    WHEN NAME_ERROR
        THEN RAISE_APPLICATION_ERROR(-20007, '�Է��� ������ �������� �ʽ��ϴ�.');
    WHEN PROF_ERROR
        THEN RAISE_APPLICATION_ERROR(-20011, '�Է��� �����ڰ� �������� �ʽ��ϴ�.');
    WHEN DATE_ERROR
        THEN RAISE_APPLICATION_ERROR(-20031, '���� �Ⱓ�� ���� �Ⱓ�� �ʰ��� �� �����ϴ�.');
    WHEN OTHERS
        THEN ROLLBACK;
END;
--==> Procedure PRC_SUBLIST_UPDATE��(��) �����ϵǾ����ϴ�.


--------------------------------------------------------------------------------
--21. ���񰳼� ���� ���ν��� (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_SLI_DELETE
( V_LIST_NO     SUB_LIST.LIST_NO%TYPE
)
IS
    V_SUB_STARTDATE SUB_LIST.SUB_STARTDATE%TYPE;
    TEMP_NUM        NUMBER;
    
    SUB_NO_ERROR    EXCEPTION; -- �����ȣ�� �������� ���� �� �߻��ϴ� ����
    STARTDATE_ERROR EXCEPTION;
BEGIN
    -- �����ȣ�� �������� ���� �� ���� �߻�
    SELECT COUNT(*) INTO TEMP_NUM
    FROM SUB_LIST
    WHERE LIST_NO = V_LIST_NO;
    
    IF (TEMP_NUM = 0)
        THEN RAISE SUB_NO_ERROR;
    END IF;
    
    -- ������ ������ �̹� �������� ��� ���� �Ұ���(���� �� ���� ���� ����)
    SELECT SUB_STARTDATE INTO V_SUB_STARTDATE
    FROM SUB_LIST
    WHERE LIST_NO=V_LIST_NO;
    
    IF (SYSDATE>V_SUB_STARTDATE)
        THEN RAISE STARTDATE_ERROR;
    END IF;
    
    -- DELETE ���� �ۼ�
    DELETE
    FROM SUB_LIST
    WHERE LIST_NO = V_LIST_NO;
    
    COMMIT;
    
    -- ���� ó��
    EXCEPTION
        WHEN SUB_NO_ERROR
            THEN RAISE_APPLICATION_ERROR(-20007, '�Է��� ������ �������� �ʽ��ϴ�.');
            ROLLBACK;
        WHEN STARTDATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20038, '�̹� ���۵� �����Դϴ�.');
            ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>> Procedure PRC_SLI_DELETE��(��) �����ϵǾ����ϴ�.


--------------------------------------------------------------------------------
--22. ���� ���� ���ν��� (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_DIV_UPDATE
( V_PRO_ID            IN   SUB_LIST.PRO_ID%TYPE
, V_LIST_NO           IN   SUB_LIST.LIST_NO%TYPE
, V_ATTEND_DIV    IN   SUB_LIST.ATTEND_DIV%TYPE
, V_PRAC_DIV        IN   SUB_LIST.PRAC_DIV%TYPE
, V_WRITE_DIV       IN   SUB_LIST.WRITE_DIV%TYPE
)
IS   
        TEMP_NUM         NUMBER;
        TEMP_STARTDATE   SUB_LIST.SUB_STARTDATE%TYPE;
        USER_DEFINE_ERROR   EXCEPTION;
        USER_DEFINE_ERROR2  EXCEPTION;
        USER_DEFINE_ERROR3  EXCEPTION;
BEGIN
        
        SELECT COUNT(*) INTO TEMP_NUM
        FROM SUB_LIST
        WHERE PRO_ID = V_PRO_ID AND LIST_NO = V_LIST_NO;
        
        SELECT SUB_STARTDATE INTO TEMP_STARTDATE
        FROM SUB_LIST
        WHERE PRO_ID = V_PRO_ID AND LIST_NO = V_LIST_NO;

        IF (V_ATTEND_DIV +V_PRAC_DIV +  V_WRITE_DIV != 100)
            THEN RAISE USER_DEFINE_ERROR;
        END IF;
        
        IF (TEMP_NUM = 0)
            THEN RAISE USER_DEFINE_ERROR2;
        END IF;
        
        IF (TEMP_STARTDATE < SYSDATE)
            THEN RAISE USER_DEFINE_ERROR3;
        END IF;
       
        UPDATE SUB_LIST
        SET     ATTEND_DIV =  V_ATTEND_DIV, PRAC_DIV = V_PRAC_DIV, WRITE_DIV = V_WRITE_DIV
        WHERE PRO_ID = V_PRO_ID
             AND LIST_NO =V_LIST_NO;
        
        COMMIT;
        
        EXCEPTION
            WHEN USER_DEFINE_ERROR
                THEN RAISE_APPLICATION_ERROR(-20027, '������ ������ [100] �̾�� �մϴ�.');
            WHEN USER_DEFINE_ERROR2
                THEN RAISE_APPLICATION_ERROR(-20034, '�ش� �������� ��� ������ �ƴմϴ�.');
            WHEN USER_DEFINE_ERROR3
                THEN RAISE_APPLICATION_ERROR(-20032, '�̹� ���۵� ������ ������ ������ �� �����ϴ�.');
                        
END;
--==> Procedure PRC_DIV_UPDATE��(��) �����ϵǾ����ϴ�.

--------------------------------------------------------------------------------
--23. �л� ���� ���� ���ν��� (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_STU_INSERT
( V_ID          IN STUDENT.STU_ID%TYPE 
, V_NAME        IN STUDENT.STU_NAME%TYPE
, V_FIRSTSSN    IN STUDENT.STU_FIRSTSSN%TYPE
, V_LASTSSN     IN STUDENT.STU_LASTSSN%TYPE
)
IS  
    TEMP_ID  NUMBER;
    TEMP_NUM NUMBER;
    
    ID_ERROR EXCEPTION;
    SSN_ERROR EXCEPTION;
    SSN_NUM_ERROR EXCEPTION;
    
BEGIN
    --�ߺ�ID   
    SELECT COUNT(*) INTO TEMP_ID
    FROM STUDENT
    WHERE STU_ID = V_ID;

    IF (TEMP_ID != 0)
        THEN RAISE ID_ERROR;
    END IF;
    
    --�ߺ� �ֹι�ȣ
    SELECT COUNT(*) INTO TEMP_NUM
    FROM STUDENT
    WHERE STU_FIRSTSSN = V_FIRSTSSN
      AND STU_LASTSSN = V_LASTSSN;
    
    IF (TEMP_NUM != 0)
        THEN RAISE SSN_ERROR;
    END IF;
    
    --�ֹι�ȣ �ڸ��� ���� �� ���ڸ� ù����(1~6)
    --5,6 �ܱ��ι�ȣ
    IF (LENGTH(V_FIRSTSSN) != 6 OR LENGTH(V_LASTSSN) != 7
        OR SUBSTR(V_LASTSSN, 1, 1) NOT IN ('1', '2', '3', '4', '5', '6'))
        THEN RAISE SSN_NUM_ERROR;
    END IF;
    
    
    --INSERT
    INSERT INTO STUDENT(STU_ID, STU_NAME, STU_FIRSTSSN, STU_LASTSSN)
    VALUES(V_ID, V_NAME, V_FIRSTSSN, V_LASTSSN);
    
    COMMIT;
    
    
    --����ó��
    EXCEPTION
        WHEN ID_ERROR
            THEN RAISE_APPLICATION_ERROR(-20018, '�̹� ��ϵ� ID�Դϴ�.');
                ROLLBACK;
        WHEN SSN_ERROR
            THEN RAISE_APPLICATION_ERROR(-20017, '�̹� ��ϵ� �л��Դϴ�.');
                ROLLBACK;  
        WHEN SSN_NUM_ERROR       
            THEN RAISE_APPLICATION_ERROR(-20002, '�Է��� �ֹι�ȣ�� ��ġ���� �ʽ��ϴ�.');
                ROLLBACK;
        WHEN OTHERS THEN ROLLBACK;
            
END;
--==>> Procedure PRC_STU_INSERT��(��) �����ϵǾ����ϴ�.

--------------------------------------------------------------------------------
--24. �л� ���� ���� ���ν���(Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_STU_UPDATE
( V_ID          IN STUDENT.STU_ID%TYPE
, V_FIRSTSSN    IN STUDENT.STU_FIRSTSSN%TYPE
, V_LASTSSN     IN STUDENT.STU_LASTSSN%TYPE
, V_PW          IN STUDENT.STU_PW%TYPE
, V_NAME        IN STUDENT.STU_NAME%TYPE
)
IS
    TEMP_ID     NUMBER;
    TEMP_SSN    CHAR(13);
    ID_ERROR  EXCEPTION;
    SSN_ERROR EXCEPTION;
BEGIN
    --�߸��� ID
    SELECT COUNT(*) INTO TEMP_ID
    FROM STUDENT
    WHERE STU_ID = V_ID;
        
    IF (TEMP_ID = 0)
        THEN RAISE ID_ERROR;
    END IF;
    
    --�߸��� �ֹι�ȣ
    SELECT CONCAT(STU_FIRSTSSN, STU_LASTSSN) INTO TEMP_SSN
    FROM STUDENT
    WHERE STU_ID = V_ID;
    
    IF (TEMP_SSN != (V_FIRSTSSN || V_LASTSSN))
        THEN RAISE SSN_ERROR;
    END IF;


    --UPDATE
    UPDATE STUDENT
    SET STU_PW = V_PW , STU_NAME = V_NAME
    WHERE STU_ID = V_ID
      AND STU_FIRSTSSN = STU_FIRSTSSN
      AND STU_LASTSSN = STU_LASTSSN;
      
    COMMIT;
    
    
    --����ó��
    EXCEPTION
        WHEN ID_ERROR
            THEN RAISE_APPLICATION_ERROR(-20015, '�Է��� ID�� �������� �ʽ��ϴ�.');
                ROLLBACK;
        WHEN SSN_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002, '�Է��� �ֹι�ȣ�� ��ġ���� �ʽ��ϴ�.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;

END;
--==> Procedure PRC_STU_UPDATE��(��) �����ϵǾ����ϴ�.

--------------------------------------------------------------------------------
--25. �л� ���� ���� ���ν���(Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_STU_DELETE
( V_ID IN STUDENT.STU_ID%TYPE
, V_PW IN STUDENT.STU_PW%TYPE
)
IS
    TEMP_NUM    NUMBER;
    TEMP_PW     STUDENT.STU_PW%TYPE;
    ID_PW_ERROR EXCEPTION;
BEGIN
    --ID ����ġ
    SELECT COUNT(*) INTO TEMP_NUM
    FROM STUDENT
    WHERE STU_ID = V_ID;
    
    IF (TEMP_NUM=0)
        THEN RAISE ID_PW_ERROR;
    END IF;
    
    --PW ����ġ
    SELECT STU_PW INTO TEMP_PW
    FROM STUDENT
    WHERE STU_ID = V_ID;
    
    IF (TEMP_PW != V_PW)
        THEN RAISE ID_PW_ERROR;
    END IF;
    
    
    --DELETE
    DELETE
    FROM STUDENT
    WHERE STU_ID = V_ID
      AND STU_PW = V_PW;
    
    COMMIT;
   
   
   --����ó��
   EXCEPTION
        WHEN ID_PW_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001, '���̵� �� ��й�ȣ�� ��ġ���� �ʽ��ϴ�.');
        WHEN OTHERS THEN ROLLBACK;
END;
--==>> Procedure PRC_STU_DELETE��(��) �����ϵǾ����ϴ�.

--------------------------------------------------------------------------------
--26. �л� �α��� ���ν��� (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_STU_LOGIN
( V_ID   IN STUDENT.STU_ID%TYPE
, V_PW   IN STUDENT.STU_PW%TYPE
)
IS
    TEMP_NUM        NUMBER;
    TEMP_PW         STUDENT.STU_PW%TYPE;
    
    USER_DEFINE_ERROR EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO TEMP_NUM
    FROM STUDENT
    WHERE STU_ID=V_ID;
    
    IF (TEMP_NUM=0)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    SELECT STU_PW INTO TEMP_PW
    FROM STUDENT
    WHERE STU_ID = V_ID;
    
    IF (TEMP_PW != V_PW)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001, '���̵� �� ��й�ȣ�� ��ġ���� �ʽ��ϴ�.');

END;
--==> Procedure PRC_STU_LOGIN��(��) �����ϵǾ����ϴ�.

--------------------------------------------------------------------------------
--27. �ߵ�Ż�� ���� ���ν��� (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_DROP_INSERT
( V_REG_NO           IN STU_DROP.REG_NO%TYPE
, V_REASON_NO        IN STU_DROP.REASON_NO%TYPE
)
IS
    V_DROP_NO           STU_DROP.DROP_NO%TYPE;
    
    TEMP_NUM            NUMBER;
    REG_NO_ERROR        EXCEPTION;
BEGIN
    
    -- ������û��ȣ�� �̹� ��ϵǾ� ������ ���� �߻�
    SELECT COUNT(*) INTO TEMP_NUM   
    FROM STU_DROP
    WHERE REG_NO = V_REG_NO;
    
    IF (TEMP_NUM != 0)
        THEN RAISE REG_NO_ERROR;
    END IF;
    
    V_DROP_NO := ('DR-' || TO_CHAR(SEQ_STUDROP.NEXTVAL));

    INSERT INTO STU_DROP(DROP_NO, REG_NO, REASON_NO)
    VALUES(V_DROP_NO, V_REG_NO, V_REASON_NO);
    
    EXCEPTION
        WHEN REG_NO_ERROR
            THEN RAISE_APPLICATION_ERROR(-20023, '�̹� ��ϵ� �ߵ�Ż�� �л��Դϴ�.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;

--------------------------------------------------------------------------------
--28. �ߵ�Ż���л� ���� ���ν���(Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_DROP_UPDATE
( V_DROP_NO         STU_DROP.DROP_NO%TYPE
, V_STU_DROPDATE    STU_DROP.STU_DROPDATE%TYPE
, V_REASON_NO       STU_DROP.REASON_NO%TYPE
)   
IS
    TEMP_NUM         NUMBER;
    TEMP_RNUM        NUMBER;
    DROP_ERROR    EXCEPTION;
BEGIN
    -- �ߵ�Ż����ȣ�� �������� ���� �� ����ó��
    SELECT COUNT(*) INTO TEMP_NUM
    FROM STU_DROP
    WHERE DROP_NO = V_DROP_NO;
    
    IF (TEMP_NUM = 0)
        THEN RAISE DROP_ERROR;
    END IF;
    
    -- �ߵ�Ż�������� �������� ���� ��
    SELECT COUNT(*) INTO TEMP_RNUM
    FROM DROP_RES
    WHERE REASON_NO = V_REASON_NO;
    
    IF (TEMP_RNUM = 0)
        THEN RAISE DROP_ERROR;
    END IF;
    
    
    -- UPDATE
    UPDATE STU_DROP
    SET STU_DROPDATE = V_STU_DROPDATE, REASON_NO = V_REASON_NO
    WHERE DROP_NO = V_DROP_NO;
    
    COMMIT;
    
    
    -- ����ó��
    EXCEPTION
        WHEN DROP_ERROR
            THEN RAISE_APPLICATION_ERROR(-20008, '�Է��� �ߵ�Ż�� ������ �������� �ʽ��ϴ�.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>> Procedure PRC_DROP_UPDATE��(��) �����ϵǾ����ϴ�.

--------------------------------------------------------------------------------
--29. �ߵ�Ż�� ���� ���ν��� (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_DROP_DELETE
(V_DROP_NO   IN STU_DROP.DROP_NO%TYPE
)
IS
   TEMP_DNUM   NUMBER;
   
   DROP_ERROR   EXCEPTION;
BEGIN
   --�ߵ�Ż�� ��ȣ�� �������� ���� ��� ����
   SELECT COUNT(*) INTO TEMP_DNUM
   FROM STU_DROP
   WHERE DROP_NO=V_DROP_NO;

   IF (TEMP_DNUM=0)
      THEN RAISE DROP_ERROR;
   END IF;

   --DELETE ������ 
   DELETE
   FROM STU_DROP
   WHERE DROP_NO=V_DROP_NO;

   COMMIT;

   --����ó��
   EXCEPTION
      WHEN DROP_ERROR
         THEN RAISE_APPLICATION_ERROR(-20008, '�Է��� �ߵ�Ż�� ������ �������� �ʽ��ϴ�.');
      ROLLBACK;
     WHEN OTHERS
         THEN ROLLBACK;
END;
--==>> Procedure PRC_DROP_DELETE��(��) �����ϵǾ����ϴ�.

--------------------------------------------------------------------------------
--30. ���� ���� �Է� ���ν��� (���� �Է½� ���񰳼����� SYSDATE ���� �̷��� ����ó��) (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_SCORE_INSERT
( V_REG_NO        IN SCORE.REG_NO%TYPE
, V_LIST_NO       IN SCORE.LIST_NO%TYPE
, V_ATTEND_SCORE  IN SCORE.ATTEND_SCORE%TYPE
, V_PRAC_SCORE    IN SCORE.PRAC_SCORE%TYPE
, V_WRITE_SCORE   IN SCORE.WRITE_SCORE%TYPE
)
IS
    V_SCORE_NO           SCORE.SCORE_NO%TYPE;
    TEMP_NUM             NUMBER;
    V_SUB_STARTDATE      SUB_LIST.SUB_STARTDATE%TYPE;
    SCORE_NO_ERROR       EXCEPTION;
    DATE_ERROR           EXCEPTION;
BEGIN
    
    -- ���� �Է½� ������û��ȣ�� ���񰳼���ȣ�� ���� ���̺� �̹� �����ϸ� ����ó��
    SELECT COUNT(*) INTO TEMP_NUM
    FROM SCORE
    WHERE REG_NO = V_REG_NO AND LIST_NO = V_LIST_NO;

    IF (TEMP_NUM != 0)
        THEN RAISE SCORE_NO_ERROR;
    END IF;
    
    -- ���� �Է½� ���񰳼����� SYSDATE ���� �̷��� ����ó��
    SELECT SUB_STARTDATE INTO V_SUB_STARTDATE
    FROM SUB_LIST
    WHERE LIST_NO = V_LIST_NO;
    
    IF (V_SUB_STARTDATE > SYSDATE)
        THEN RAISE DATE_ERROR;
    END IF;
    
    -- ������û��ȣ ����(������ Ȱ���� ���� �ڵ� �����ǰ� ����)
    V_SCORE_NO := ('SCO-' || TO_CHAR(SEQ_SCORE.NEXTVAL));
    
    INSERT INTO SCORE(SCORE_NO, REG_NO, LIST_NO, ATTEND_SCORE, PRAC_SCORE, WRITE_SCORE)
    VALUES(V_SCORE_NO, V_REG_NO, V_LIST_NO, V_ATTEND_SCORE, V_PRAC_SCORE, V_WRITE_SCORE);
    
    COMMIT;
    
    EXCEPTION
        WHEN SCORE_NO_ERROR
            THEN RAISE_APPLICATION_ERROR(-20026, '�̹� ��ϵ� �����Դϴ�.');
                ROLLBACK;
        WHEN DATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20033, '���� ������ �����Դϴ�.');
                ROLLBACK;        
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==> Procedure PRC_SCORE_INSERT��(��) �����ϵǾ����ϴ�.

--------------------------------------------------------------------------------
--31. ���� ���� ���� ���ν��� (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_SCORE_UPDATE
( V_SCORE_NO      IN SCORE.SCORE_NO%TYPE
, V_ATTEND_SCORE  IN SCORE.ATTEND_SCORE%TYPE
, V_PRAC_SCORE    IN SCORE.PRAC_SCORE%TYPE
, V_WRITE_SCORE   IN SCORE.WRITE_SCORE%TYPE
)
IS
    TEMP_NUM             NUMBER;
    SCORE_NO_ERROR       EXCEPTION;
    SCORE_VALUE_ERROR    EXCEPTION;
BEGIN

    -- ���� �Է½� �ش� ����(������ȣ)�� ���� ���̺� �������� ������ ����ó��
    SELECT COUNT(*) INTO TEMP_NUM
    FROM SCORE
    WHERE SCORE_NO = V_SCORE_NO;

    IF (TEMP_NUM = 0)
        THEN RAISE SCORE_NO_ERROR;
    END IF;
    
    -- ���� �Է½� �� ���� ������ [0-100]���� ����� ����ó��
    IF ( (V_ATTEND_SCORE NOT BETWEEN 0 AND 100) OR (V_PRAC_SCORE NOT BETWEEN 0 AND 100)
         OR (V_WRITE_SCORE NOT BETWEEN 0 AND 100) )
        THEN RAISE SCORE_VALUE_ERROR;
    END IF;
    
    UPDATE SCORE
    SET ATTEND_SCORE = V_ATTEND_SCORE, PRAC_SCORE = V_PRAC_SCORE, WRITE_SCORE = V_WRITE_SCORE
    WHERE SCORE_NO = V_SCORE_NO;
    
    COMMIT;
    
    EXCEPTION
        WHEN SCORE_NO_ERROR
            THEN RAISE_APPLICATION_ERROR(-20004, '�Է��� ������ �������� �ʽ��ϴ�.');
                 ROLLBACK;
        WHEN SCORE_VALUE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20028, '[0 - 100]�� ���� ������ �Է� �����մϴ�.');
                ROLLBACK;        
        WHEN OTHERS
            THEN ROLLBACK;        

END;
--==>> Procedure PRC_SCORE_UPDATE��(��) �����ϵǾ����ϴ�.


--------------------------------------------------------------------------------
--32. ���� ���� ���� ���ν��� (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_SCORE_DELETE
( V_SCORE_NO      IN SCORE.SCORE_NO%TYPE
)
IS
    TEMP_NUM            NUMBER;
    SCORE_NO_ERROR      EXCEPTION;
BEGIN
    
    -- ���� ������ �ش� ����(������ȣ)�� ���� ���̺� �������� ������ ����ó��
    SELECT COUNT(*) INTO TEMP_NUM
    FROM SCORE
    WHERE SCORE_NO = V_SCORE_NO;

    IF (TEMP_NUM = 0)
        THEN RAISE SCORE_NO_ERROR;
    END IF;
    
    DELETE
    FROM SCORE
    WHERE SCORE_NO = V_SCORE_NO;
    
    COMMIT;
    
    EXCEPTION
        WHEN SCORE_NO_ERROR
            THEN RAISE_APPLICATION_ERROR(-20004, '�Է��� ������ �������� �ʽ��ϴ�.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
    
END;
--==>> Procedure PRC_SCORE_DELETE��(��) �����ϵǾ����ϴ�.

--------------------------------------------------------------------------------
--33. �л� ���� Ȯ�� ��¹�(Ȯ��)
SET SERVEROUTPUT ON;

DECLARE
    V_PRO_ID                      PROFESSOR.PRO_ID%TYPE;
    V_STU_ID                        STUDENT.STU_ID%TYPE;
    V_STU_NAME                 STUDENT.STU_NAME%TYPE;
    V_CUR_NAME                CURRICULUM.CUR_NAME%TYPE;
    V_SUB_NAME                 SUBJECT.SUB_NAME%TYPE;
    V_SUB_STARTDATE         SUB_LIST.SUB_STARTDATE%TYPE;
    V_SUB_ENDDATE           SUB_LIST.SUB_ENDDATE%TYPE;
    V_BOOK_NAME             BOOK.BOOK_NAME%TYPE;
    V_ATTEND_SCORE         SCORE.ATTEND_SCORE%TYPE;
    V_PRAC_SCORE             SCORE.PRAC_SCORE%TYPE;
    V_WRITE_SCORE            SCORE.WRITE_SCORE%TYPE;
    V_TOTAL_SCORE           NUMBER;
    V_RANK                         NUMBER;
    
    --Ŀ�� ����
    CURSOR CUR_PRO_SUNGJUK      -- CURSOR Ŀ����
    IS                          
    SELECT *
    FROM VIEW_SUNGJUK
    WHERE �л����̵� = 'JJH234'; -- ���⿡ �л����� �ֱ�
    

BEGIN
    --Ŀ�� ����
    OPEN CUR_PRO_SUNGJUK;
    
    --�ݺ������� ���
    LOOP
        -- �� �྿ ������� �������� ���� �� FETCH
        FETCH CUR_PRO_SUNGJUK INTO  V_PRO_ID, V_STU_ID,  V_STU_NAME, V_CUR_NAME, V_SUB_NAME
                        , V_SUB_STARTDATE, V_SUB_ENDDATE, V_BOOK_NAME
                        , V_ATTEND_SCORE, V_PRAC_SCORE, V_WRITE_SCORE
                        , V_TOTAL_SCORE , V_RANK;
        
        -- Ŀ������ �ƹ��͵� ã�� ������ �� �ݺ��� ����
        EXIT WHEN CUR_PRO_SUNGJUK%NOTFOUND; 
        
        -- ���
        DBMS_OUTPUT.PUT_LINE(  V_STU_NAME|| '   ' || V_CUR_NAME || '   ' || V_SUB_NAME
                         || '   ' || V_SUB_STARTDATE || '   ' || V_SUB_ENDDATE|| '   ' ||
                         V_BOOK_NAME || '   ' || V_ATTEND_SCORE || '   ' || V_PRAC_SCORE || '   ' || V_WRITE_SCORE 
                         || '   ' || V_TOTAL_SCORE || '   ' || V_RANK);
    END LOOP;
    
    -- Ŀ�� Ŭ����
    CLOSE CUR_PRO_SUNGJUK;
END;
--==>> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.

--------------------------------------------------------------------------------
--34. �л��� �ߵ�Ż������ ��� (Ȯ��)
DECLARE
    V_PRO_ID                       SUB_LIST.PRO_ID%TYPE;
    V_STU_ID                        STUDENT.STU_ID%TYPE;
    V_REG_NO                     REGISTRATION.REG_NO%TYPE;
    V_STU_NAME                 STUDENT.STU_NAME%TYPE;
    V_CUR_NAME                CURRICULUM.CUR_NAME%TYPE;
    V_SUB_NAME                 SUBJECT.SUB_NAME%TYPE;
    V_STU_DROPDATE         STU_DROP.STU_DROPDATE%TYPE;
    
    --Ŀ�� ����
    CURSOR CUR_STU_DROP   -- CURSOR Ŀ����
    IS                          
    SELECT *
    FROM  VIEW_DROP
    WHERE �л����̵� = 'JJH234';
    

BEGIN
    --Ŀ�� ����
    OPEN CUR_STU_DROP;
    
    --�ݺ������� ���
    LOOP
        -- �� �྿ ������� �������� ���� �� FETCH
        FETCH CUR_STU_DROP INTO  V_PRO_ID, V_STU_ID, V_REG_NO,  V_STU_NAME, V_CUR_NAME, V_SUB_NAME, V_STU_DROPDATE;
        
        -- Ŀ������ �ƹ��͵� ã�� ������ �� �ݺ��� ����
        EXIT WHEN CUR_STU_DROP%NOTFOUND; 
        
        -- ���
        DBMS_OUTPUT.PUT_LINE(  V_REG_NO || '   ' || V_STU_NAME|| '   ' || V_CUR_NAME 
                    || '   ' || V_SUB_NAME || '   ' ||  V_STU_DROPDATE);
    END LOOP;
    
    -- Ŀ�� Ŭ����
    CLOSE CUR_STU_DROP;
END;


--------------------------------------------------------------------------------
--35. ���� ���� Ȯ�� ��¹�(Ȯ��)
SET SERVEROUTPUT ON;

DECLARE
    V_PRO_ID                      PROFESSOR.PRO_ID%TYPE;
    V_STU_ID                        STUDENT.STU_ID%TYPE;
    V_STU_NAME                 STUDENT.STU_NAME%TYPE;
    V_CUR_NAME                CURRICULUM.CUR_NAME%TYPE;
    V_SUB_NAME                 SUBJECT.SUB_NAME%TYPE;
    V_SUB_STARTDATE         SUB_LIST.SUB_STARTDATE%TYPE;
    V_SUB_ENDDATE           SUB_LIST.SUB_ENDDATE%TYPE;
    V_BOOK_NAME             BOOK.BOOK_NAME%TYPE;
    V_ATTEND_SCORE         SCORE.ATTEND_SCORE%TYPE;
    V_PRAC_SCORE             SCORE.PRAC_SCORE%TYPE;
    V_WRITE_SCORE            SCORE.WRITE_SCORE%TYPE;
    V_TOTAL_SCORE           NUMBER;
    V_RANK                         NUMBER;
    
    --Ŀ�� ����
    CURSOR CUR_PRO_SUNGJUK      -- CURSOR Ŀ����
    IS                          
    SELECT *
    FROM VIEW_SUNGJUK
    WHERE �������̵� = 'KHJ123';
    

BEGIN
    --Ŀ�� ����
    OPEN CUR_PRO_SUNGJUK;
    
    --�ݺ������� ���
    LOOP
        -- �� �྿ ������� �������� ���� �� FETCH
        FETCH CUR_PRO_SUNGJUK INTO  V_PRO_ID, V_STU_ID,  V_STU_NAME, V_CUR_NAME, V_SUB_NAME
                        , V_SUB_STARTDATE, V_SUB_ENDDATE, V_BOOK_NAME
                        , V_ATTEND_SCORE, V_PRAC_SCORE, V_WRITE_SCORE
                        , V_TOTAL_SCORE , V_RANK;
        
        -- Ŀ������ �ƹ��͵� ã�� ������ �� �ݺ��� ����
        EXIT WHEN CUR_PRO_SUNGJUK%NOTFOUND; 
        
        -- ���
        DBMS_OUTPUT.PUT_LINE( V_PRO_ID || '   ' ||  V_STU_NAME || '   ' || V_SUB_NAME
                         || '   ' || V_SUB_STARTDATE || '   ' || V_SUB_ENDDATE|| '   ' || V_BOOK_NAME 
                         || '   ' || V_ATTEND_SCORE || '   ' || V_PRAC_SCORE || '   ' || V_WRITE_SCORE 
                         || '   ' || V_TOTAL_SCORE || '   ' || V_RANK);
    END LOOP;
    
    -- Ŀ�� Ŭ����
    CLOSE CUR_PRO_SUNGJUK;
END;
--==>> PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�.

--------------------------------------------------------------------------------
--36. ������ �л� �ߵ�Ż������ ��� Ȯ�� (Ȯ��)
DECLARE
    V_PRO_ID                       SUB_LIST.PRO_ID%TYPE;
    V_STU_ID                        STUDENT.STU_ID%TYPE;
    V_REG_NO                     REGISTRATION.REG_NO%TYPE;
    V_STU_NAME                 STUDENT.STU_NAME%TYPE;
    V_CUR_NAME                CURRICULUM.CUR_NAME%TYPE;
    V_SUB_NAME                 SUBJECT.SUB_NAME%TYPE;
    V_STU_DROPDATE         STU_DROP.STU_DROPDATE%TYPE;
    
    --Ŀ�� ����
    CURSOR CUR_STU_DROP   -- CURSOR Ŀ����
    IS                          
    SELECT *
    FROM  VIEW_DROP
    WHERE �������̵� = 'KHJ123';
    

BEGIN
    --Ŀ�� ����
    OPEN CUR_STU_DROP;
    
    --�ݺ������� ���
    LOOP
        -- �� �྿ ������� �������� ���� �� FETCH
        FETCH CUR_STU_DROP INTO  V_PRO_ID, V_STU_ID, V_REG_NO,  V_STU_NAME, V_CUR_NAME, V_SUB_NAME, V_STU_DROPDATE;
        
        -- Ŀ������ �ƹ��͵� ã�� ������ �� �ݺ��� ����
        EXIT WHEN CUR_STU_DROP%NOTFOUND; 
        
        -- ���
        DBMS_OUTPUT.PUT_LINE(  V_REG_NO || '   ' || V_STU_NAME|| '   ' || V_CUR_NAME 
                    || '   ' || V_SUB_NAME || '   ' ||  V_STU_DROPDATE);
    END LOOP;
    
    -- Ŀ�� Ŭ����
    CLOSE CUR_STU_DROP;
END;

--------------------------------------------------------------------------------
--37. �ߵ�Ż������ ���� ���ν��� (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_DRP_INSERT
( V_REASON        DROP_RES.REASON%TYPE
)
IS
    V_DRP_NO        DROP_RES.REASON_NO%TYPE;  -- ������ ������ �ʿ��� ����
    TEMP_NUM        NUMBER;                   -- Ż��������ȣ ���翩�� Ȯ�ο� �ʿ��� ����
    
    REASON_ERROR    EXCEPTION; -- ���� Ż�������� �̹� ������ �� �߻��ϴ� ����
BEGIN
    -- ���� Ż�������� �̹� ������ �� ���� �߻�(UNIQUE)
    SELECT COUNT(*) INTO TEMP_NUM
    FROM DROP_RES
    WHERE REASON = V_REASON;
    
    IF (TEMP_NUM != 0)
        THEN RAISE REASON_ERROR;
    END IF;
    
    -- Ż��������ȣ ����(������ Ȱ���� ���� �ڵ� �����ǰ� ����)
    V_DRP_NO := ('DRP-' || TO_CHAR(SEQ_DROP_RES.NEXTVAL));
    
    -- INSERT ���� �ۼ�
    INSERT INTO DROP_RES(REASON_NO, REASON)
    VALUES(V_DRP_NO, V_REASON);
    
    COMMIT;
    
    -- ���� ó��
    EXCEPTION 
        WHEN REASON_ERROR
            THEN RAISE_APPLICATION_ERROR(-20021, '�̹� ��ϵ� Ż�������Դϴ�.'); 
            ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==> Procedure PRC_DRP_INSERT��(��) �����ϵǾ����ϴ�.


--------------------------------------------------------------------------------
--38. �ߵ�Ż������ ���� ���ν��� (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_DROPRES_DELETE
( V_REASON_NO       IN DROP_RES.REASON_NO%TYPE
)
IS
    TEMP_RNUM       NUMBER;     --Ż��������ȣ�� �����ϴ��� Ȯ�ο� �ӽú���
    
    REASON_ERROR    EXCEPTION;
BEGIN

    SELECT COUNT(*) INTO TEMP_RNUM
    FROM DROP_RES
    WHERE REASON_NO=V_REASON_NO;
    
    IF (TEMP_RNUM=0)
        THEN RAISE REASON_ERROR;
    END IF;
    
    DELETE
    FROM DROP_RES
    WHERE REASON_NO=V_REASON_NO;
    
    COMMIT;
    
    EXCEPTION
        WHEN REASON_ERROR
            THEN RAISE_APPLICATION_ERROR(-20016, '�Է��� Ż�������� �������� �ʽ��ϴ�.');
END;
--==> Procedure PRC_DROPRES_DELETE��(��) �����ϵǾ����ϴ�.


--------------------------------------------------------------------------------
--39. ������û �Է� ���ν���(�л��� ������û�ϴ� ���ν���) (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_REG_INSERT
( V_STU_ID      REGISTRATION.STU_ID%TYPE
, V_CUR_NO      REGISTRATION.CUR_NO%TYPE
)
IS
    V_REG_NO        DROP_RES.REASON_NO%TYPE;        -- ������ ������ ���� ����
    TEMP_NUM        NUMBER;
    V_CUR_STARTDATE   CURRICULUM.CUR_STARTDATE%TYPE;    -- ������û���ڸ� �޾ƿ��� ���� ����
    
    REG_NO_ERROR    EXCEPTION;               -- 1. ���� �л� ���̵�+������ȣ�� �̹� ������ �� �߻��ϴ� ����
    DATE_ERROR      EXCEPTION;               -- 2. ������û���ڰ�(SYSDATE) ���������Ϻ��� �̷��� �� �߻��ϴ� ����
BEGIN
    -- 1. ���� �л� ���̵�+������ȣ�� �̹� ������ �� ���� �߻�
    SELECT COUNT(*) INTO TEMP_NUM
    FROM REGISTRATION
    WHERE STU_ID = V_STU_ID AND CUR_NO = V_CUR_NO;
    
    IF (TEMP_NUM != 0)
        THEN RAISE REG_NO_ERROR;
    END IF;
    
    -- 2. ������û����(SYSDATE) > ���������� �� �� ���� �߻�
    SELECT CUR_STARTDATE INTO V_CUR_STARTDATE
    FROM CURRICULUM
    WHERE CUR_NO = V_CUR_NO;
    
    IF (SYSDATE > V_CUR_STARTDATE)
        THEN RAISE DATE_ERROR;
    END IF;
    
    -- ������û��ȣ ����(������ Ȱ���� ���� �ڵ� �����ǰ� ����)
    V_REG_NO := ('REG-' || TO_CHAR(SEQ_REGISTRATION.NEXTVAL));

    --INSERT ���� �ۼ�
    INSERT INTO REGISTRATION(REG_NO, STU_ID, CUR_NO, REG_DATE)
    VALUES(V_REG_NO, V_STU_ID, V_CUR_NO, SYSDATE);
   
    COMMIT;
    
    -- ���� ó��
    EXCEPTION
        WHEN REG_NO_ERROR
            THEN RAISE_APPLICATION_ERROR(-20024, '�̹� ��ϵ� �����Դϴ�.');
            ROLLBACK;
        WHEN DATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20036, '�̹� ���۵� �����Դϴ�.');
            ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==> Procedure PRC_REG_INSERT��(��) �����ϵǾ����ϴ�.

--------------------------------------------------------------------------------
--40. ������û ���� ���ν���(�л��� ������û �����ϴ� ���ν���) (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_REG_UPDATE
( V_REG_NO      IN REGISTRATION.REG_NO%TYPE
, V_STU_ID      IN STUDENT.STU_ID%TYPE
, V_CUR_NO      IN CURRICULUM.CUR_NO%TYPE
)
IS
    TEMP_RENUM      NUMBER; 
    TEMP_ID         STUDENT.STU_ID%TYPE;
    TEMP_CNUM       NUMBER;
    TEMP_STARTDATE  CURRICULUM.CUR_STARTDATE%TYPE;
    
    REG_STU_ERROR   EXCEPTION;
    CUR_ERROR       EXCEPTION;
    CUR_DATE_ERROR  EXCEPTION;
BEGIN
    --�Է��� ������ȣ ���翩�� Ȯ��
    SELECT COUNT(*) INTO TEMP_RENUM
    FROM REGISTRATION
    WHERE REG_NO=V_REG_NO;
    
    IF (TEMP_RENUM=0)
        THEN RAISE REG_STU_ERROR;
    END IF;
    
    --�ش� ������ȣ�� �л����̵� ��ġ���� Ȯ��
    SELECT STU_ID INTO TEMP_ID
    FROM REGISTRATION
    WHERE REG_NO=V_REG_NO;
    
    IF (TEMP_ID != V_STU_ID)
        THEN RAISE REG_STU_ERROR; 
    END IF;
    
    --�Է��� ������ȣ ���翩�� Ȯ��
    SELECT COUNT(*) INTO TEMP_CNUM
    FROM CURRICULUM
    WHERE CUR_NO= V_CUR_NO;
    
    IF (TEMP_CNUM=0)
        THEN RAISE CUR_ERROR; 
    END IF;
    
    --�̹� ������ ���� ����
    SELECT CUR_STARTDATE INTO TEMP_STARTDATE
    FROM CURRICULUM
    WHERE CUR_NO= V_CUR_NO;
    
    IF (TEMP_STARTDATE < SYSDATE)
        THEN RAISE CUR_DATE_ERROR;
    END IF;
    
    
    --UPDATE
    UPDATE REGISTRATION
    SET CUR_NO = V_CUR_NO, REG_DATE = SYSDATE
    WHERE REG_NO = V_REG_NO;
    
    COMMIT;
    
    
    --����ó��
    EXCEPTION
        WHEN REG_STU_ERROR
            THEN RAISE_APPLICATION_ERROR(-20010, '�Է��� ���������� �������� �ʽ��ϴ�.');
                 ROLLBACK;
        WHEN CUR_ERROR
            THEN RAISE_APPLICATION_ERROR(-20005, '�Է��� ������ȣ�� �������� �ʽ��ϴ�.');
                 ROLLBACK;
        WHEN CUR_DATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20035, '�̹� ���۵� �����Դϴ�');
                 ROLLBACK;
        WHEN OTHERS THEN ROLLBACK;

END;
--==> Procedure PRC_REG_UPDATE��(��) �����ϵǾ����ϴ�.

--------------------------------------------------------------------------------
--41. ������û ���� ���ν���(�л��� ���� �� ������û öȸ�ϴ� ���ν���) (Ȯ��)
CREATE OR REPLACE PROCEDURE PRC_REG_DELETE
( V_REG_NO   IN REGISTRATION.REG_NO%TYPE
, V_STU_ID   IN STUDENT.STU_ID%TYPE
)
IS
   TEMP_RENUM   NUMBER;
   TEMP_ID      STUDENT.STU_ID%TYPE;
   
   REG_ERROR    EXCEPTION;
BEGIN
   --�Է� ������ȣ�� �������� �ʴ� ���
   SELECT COUNT(*) INTO TEMP_RENUM
   FROM REGISTRATION
   WHERE REG_NO=V_REG_NO;
   
   IF (TEMP_RENUM=0)
     THEN RAISE REG_ERROR;
   END IF;
   
   --������ȣ�� �л�ID�� ��ġ���� �ʴ� ���
   SELECT STU_ID INTO TEMP_ID
   FROM REGISTRATION
   WHERE REG_NO=V_REG_NO;

   IF (TEMP_ID != V_STU_ID)
     THEN RAISE REG_ERROR;
   END IF;


   --DELETE
   DELETE
   FROM REGISTRATION
   WHERE REG_NO=V_REG_NO;
   
   COMMIT;


   --����ó��
   EXCEPTION
     WHEN REG_ERROR
        THEN RAISE_APPLICATION_ERROR(-20009, '�Է��� ������û ������ �������� �ʽ��ϴ�.');
             ROLLBACK;
     WHEN OTHERS
        THEN ROLLBACK;
END;
--==>> Procedure PRC_REG_DELETE��(��) �����ϵǾ����ϴ�.
