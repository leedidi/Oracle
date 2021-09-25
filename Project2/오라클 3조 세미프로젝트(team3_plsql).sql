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

/*
���� ���� �Է� ���ν��� (���� �Է½� ���񰳼����� SYSDATE ���� �̷��� ����ó��)
���� ���� ���� ���ν���
���� ���� ���� ���ν���

- �׸��� ���� 20004...���� �߰��ؾ� �Ұ� ����� ī��濡 ������

-- ���� ���̺�
INSERT INTO SCORE(SCORE_NO, REG_NO, LIST_NO, ATTEND_SCORE, PRAC_SCORE, WRITE_SCORE)
VALUES();
*/

-- ����

-- ������ ���� ���� ���ν���
CREATE OR REPLACE PROCEDURE PRC_PRO_INSERT
( V_ID          IN PROFESSOR.PRO_ID%TYPE
, V_NAME        IN PROFESSOR.PRO_NAME%TYPE
, V_FIRSTSSN    IN PROFESSOR.PRO_FIRSTSSN%TYPE
, V_LASTSSN     IN PROFESSOR.PRO_LASTSSN%TYPE
)
IS
    TEMP_NUM NUMBER;
    USER_DEFINE_ERROR EXCEPTION;
    
BEGIN
    SELECT COUNT(*) INTO TEMP_NUM
    FROM PROFESSOR
    WHERE PRO_FIRSTSSN = V_FIRSTSSN
      AND PRO_LASTSSN = V_LASTSSN;

    IF (TEMP_NUM != 0)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;

    INSERT INTO PROFESSOR(PRO_ID, PRO_NAME, PRO_FIRSTSSN, PRO_LASTSSN)
    VALUES(V_ID, V_NAME, V_FIRSTSSN, V_LASTSSN);
    
    COMMIT;
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002, '������ �����ڰ� �����մϴ�.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
            
END;

-- STRAT...��

INSERT INTO SCORE(SCORE_NO, REG_NO, LIST_NO, ATTEND_SCORE, PRAC_SCORE, WRITE_SCORE)
VALUES('A001', 'A001', 'A001', 80, 90, 90);

-- ������û��ȣ�� ���񰳼���ȣ�� �ش� ���̺�鿡 �ԷµǾ� �־�� �Է��Ҽ� �ֵ��� ó���ؾ��ϳ�...?
-- ���� �Է½� ���񰳼����� SYSDATE ���� �̷��� ����ó��
-- ������ ���� �߿��� ���� ������ ���� ���� ������ ���� ó�� ȭ������ ��ȯ���� �ʾƾ� �Ѵ�. 

-- 1. ���� ���� �Է� ���ν��� (���� �Է½� ���񰳼����� SYSDATE ���� �̷��� ����ó��)
CREATE OR REPLACE PROCEDURE PRC_SCORE_INSERT
( V_SCORE_NO      IN SCORE.SCORE_NO%TYPE
, V_REG_NO        IN SCORE.REG_NO%TYPE
, V_LIST_NO       IN SCORE.LIST_NO%TYPE
, V_ATTEND_SCORE  IN SCORE.ATTEND_SCORE%TYPE
, V_PRAC_SCORE    IN SCORE.PRAC_SCORE%TYPE
, V_WRITE_SCORE   IN SCORE.WRITE_SCORE%TYPE
)
IS
    V_SUB_STARTDATE     SUB_LIST.SUB_STARTDATE%TYPE;
    USER_DEFINE_ERROR   EXCEPTION;
BEGIN

    SELECT SUB_STARTDATE INTO V_SUB_STARTDATE
    FROM SUB_LIST
    WHERE LIST_NO = V_LIST_NO;
    
    IF (V_SUB_STARTDATE > SYSDATE)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;

    INSERT INTO SCORE(SCORE_NO, REG_NO, LIST_NO, ATTEND_SCORE, PRAC_SCORE, WRITE_SCORE)
    VALUES(V_SCORE_NO, V_REG_NO, V_LIST_NO, V_ATTEND_SCORE, V_PRAC_SCORE, V_WRITE_SCORE);
    
    COMMIT;
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20009, '���ǰ� ������� ���� �����Դϴ�.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
            
END;
--==>> Procedure PRC_SCORE_INSERT��(��) �����ϵǾ����ϴ�.

/*
DROP PROCEDURE SCORE_INSERT;
--==>> Procedure SCORE_INSERT��(��) �����Ǿ����ϴ�.

DROP PROCEDURE SCORE_PRO_INSERT;
--==>> Procedure SCORE_PRO_INSERT��(��) �����Ǿ����ϴ�.

DROP PROCEDURE SCORE_PRO_UPDATE;
--==>> Procedure SCORE_PRO_UPDATE��(��) �����Ǿ����ϴ�.

DROP PROCEDURE SCORE_PRO_DELETE;
--==>> Procedure SCORE_PRO_DELETE��(��) �����Ǿ����ϴ�.
*/

-- ������ȣ�� �޾ƿ���,,,? ������ȣ, ������û��ȣ, ���񰳼���ȣ ��� �ٹ޾ƿ���...?
-- �ϴ� ���� ��ȣ�� �޾ƿ͵� �� �� ����!
-- ���� �Է� ���� ȭ�鿡�� �ڽ��� ���Ǹ� ������ �л����� �̸��� �ڵ����� �ԷµǾ� �ְ�, 
-- �����ڴ� �л� �������� ������ �Է��ϵ��� �Ѵ�. 
-- �ش� ������ȣ�� �������� ������ �������� �ʴ� �����Դϴ�.../ ������ ������ 0~100�� �ȵ˴ϴ�...
-- ���ڰ� ������ ����!
-- �ٵ� �ϳ��� ������ �ϳ�.... ?? ���Ǳ��ʱ� �ϳ���? �ƴ� ���ļ�,,,?


-- 2. ���� ���� ���� ���ν���
CREATE OR REPLACE PROCEDURE PRC_SCORE_UPDATE
( V_SCORE_NO      IN SCORE.SCORE_NO%TYPE
, V_ATTEND_SCORE  IN SCORE.ATTEND_SCORE%TYPE
, V_PRAC_SCORE    IN SCORE.PRAC_SCORE%TYPE
, V_WRITE_SCORE   IN SCORE.WRITE_SCORE%TYPE
)
IS
    USER_DEFINE_ERROR EXCEPTION;
BEGIN

    IF ( (V_ATTEND_SCORE NOT BETWEEN 0 AND 100) OR (V_PRAC_SCORE NOT BETWEEN 0 AND 100)
         OR (V_WRITE_SCORE NOT BETWEEN 0 AND 100) )
        THEN RAISE USER_DEFINE_ERROR;
    END IF;

    UPDATE SCORE
    SET ATTEND_SCORE = V_ATTEND_SCORE, PRAC_SCORE = V_PRAC_SCORE, WRITE_SCORE = V_WRITE_SCORE
    WHERE SCORE_NO = V_SCORE_NO;
    
    COMMIT;
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20010, '������ [0 - 100]�� ���� ������ �Է� �����մϴ�.');
            ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;        

END;
--==>> Procedure PRC_SCORE_UPDATE��(��) �����ϵǾ����ϴ�.


-- 3. ���� ���� ���� ���ν���

CREATE OR REPLACE PROCEDURE PRC_SCORE_DELETE
( V_SCORE_NO      IN SCORE.SCORE_NO%TYPE
)
IS
    TEMP_SCORE_NO       SCORE.SCORE_NO%TYPE;
    USER_DEFINE_ERROR   EXCEPTION;
BEGIN
    
    SELECT SCORE_NO INTO TEMP_SCORE_NO
    FROM SCORE
    WHERE SCORE_NO = V_SCORE_NO;
    
    IF (V_SCORE_NO != TEMP_SCORE_NO)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    DELETE
    FROM SCORE
    WHERE SCORE_NO = V_SCORE_NO;
    
    COMMIT;
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20011, '�Է��� ������ �������� �ʽ��ϴ�.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
    
END;
--==>> Procedure PRC_SCORE_DELETE��(��) �����ϵǾ����ϴ�.

-- ��� ���� ������
RAISE_APPLICATION_ERROR(-20009, '���ǰ� ������� ���� �����Դϴ�.');
RAISE_APPLICATION_ERROR(-20010, '������ [0 - 100]�� ���� ������ �Է� �����մϴ�.');
RAISE_APPLICATION_ERROR(-20011, '�Է��� ������ �������� �ʽ��ϴ�.');