SELECT USER
FROM DUAL;

--■■■ PL/SQL문 ■■■

--------------------------------------------------------------------------------
--○ 트리거 실행

--※ 교수 비밀번호 DEFAULT 트리거
CREATE OR REPLACE TRIGGER TRG_PRO_PW
          BEFORE INSERT ON PROFESSOR
          FOR EACH ROW
BEGIN
    :NEW.PRO_PW := :NEW.PRO_LASTSSN;
END;


--※ 학생 비밀번호 DEFAULT 트리거
CREATE OR REPLACE TRIGGER TRG_STU_PW
          BEFORE INSERT ON STUDENT
          FOR EACH ROW
BEGIN
    :NEW.STU_PW := :NEW.STU_LASTSSN;
END;

--------------------------------------------------------------------------------
--○ 필요한 함수 생성

-- 1. 성적 계산해주는 함수
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
            THEN RAISE_APPLICATION_ERROR(-20029, '성적의 총합은 [100]을 초과할 수 없습니다.');
            
END;
--==> Function FN_SCORESUM이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------
--○ 프로시저 생성

--1. 관리자 계정 생성 프로시저 (확인)
CREATE OR REPLACE PROCEDURE PRC_ADMIN_INSERT
( V_ID   IN ADMIN.AD_ID%TYPE
, V_PW   IN ADMIN.AD_PW%TYPE
)
IS

BEGIN

    INSERT INTO ADMIN(AD_ID, AD_PW)
    VALUES(V_ID, V_PW);
    
END;
--==> Procedure PRC_ADMIN_INSERT이(가) 컴파일되었습니다.


-----------------------------------------------
--2. 관리자 계정 수정 프로시저 (확인)
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
--==> Procedure PRC_ADMIN_UPDATE이(가) 컴파일되었습니다.


-----------------------------------------------
--3. 관리자 계정 삭제 프로시저 (확인)
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
--==> Procedure PRC_ADMIN_DELETE이(가) 컴파일되었습니다.


-----------------------------------------------
--4. 관리자 로그인 프로시저 (확인)
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
            THEN RAISE_APPLICATION_ERROR(-20001, '아이디 및 비밀번호가 일치하지 않습니다.');

END;
--==>> Procedure PRC_ADMIN_LOGIN이(가) 컴파일되었습니다.


-----------------------------------------------
--5. 교수자 계정 생성 프로시저(확인)
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
    --중복 ID   
    SELECT COUNT(*) INTO TEMP_ID
    FROM PROFESSOR
    WHERE PRO_ID = V_ID;

    IF (TEMP_ID != 0)
        THEN RAISE ID_ERROR;
    END IF;
    
    --중복 주민번호
    SELECT COUNT(*) INTO TEMP_NUM
    FROM PROFESSOR
    WHERE PRO_FIRSTSSN = V_FIRSTSSN
      AND PRO_LASTSSN = V_LASTSSN;

    IF (TEMP_NUM != 0)
        THEN RAISE SSN_ERROR;
    END IF;
    
    --주민번호 자릿수 오류 및 뒷자리 첫숫자(1~6)
    --5,6 외국인번호
    IF (LENGTH(V_FIRSTSSN) != 6 OR LENGTH(V_LASTSSN) != 7
        OR SUBSTR(V_LASTSSN, 1, 1) NOT IN ('1', '2', '3', '4', '5', '6'))
        THEN RAISE SSN_NUM_ERROR;
    END IF;
    
    
    --INSERT
    INSERT INTO PROFESSOR(PRO_ID, PRO_NAME, PRO_FIRSTSSN, PRO_LASTSSN)
    VALUES(V_ID, V_NAME, V_FIRSTSSN, V_LASTSSN);
    
    COMMIT;
    
    
    --예외처리
    EXCEPTION
        WHEN ID_ERROR
            THEN RAISE_APPLICATION_ERROR(-20018, '이미 등록된 ID입니다.');
                ROLLBACK;
        WHEN SSN_ERROR
            THEN RAISE_APPLICATION_ERROR(-20025, '이미 등록된 교수자입니다.');
                ROLLBACK;
        WHEN SSN_NUM_ERROR       
            THEN RAISE_APPLICATION_ERROR(-20002, '입력한 주민번호가 일치하지 않습니다.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
            
END;
--==>> Procedure PRC_PRO_INSERT이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------
--6. 교수자 계정 수정 프로시저 (비밀번호만 수정 가능) (확인)
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
    --잘못된 ID
    SELECT COUNT(*) INTO TEMP_ID
    FROM PROFESSOR
    WHERE PRO_ID = V_ID;
        
    IF (TEMP_ID = 0)
        THEN RAISE ID_ERROR;
    END IF;
    
    --잘못된 주민번호
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
    
    
    --예외처리
    EXCEPTION
        WHEN ID_ERROR
            THEN RAISE_APPLICATION_ERROR(-20015, '입력한 ID가 존재하지 않습니다.');
                ROLLBACK;
        WHEN SSN_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002, '입력한 주민번호가 일치하지 않습니다.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;

END;
--==>> Procedure PRC_PRO_UPDATE이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------
--7. 교수자 계정 삭제 프로시저 (확인)
CREATE OR REPLACE PROCEDURE PRC_PRO_DELETE
( V_ID IN PROFESSOR.PRO_ID%TYPE
, V_PW IN PROFESSOR.PRO_PW%TYPE
)
IS
    TEMP_NUM    NUMBER;
    TEMP_PW PROFESSOR.PRO_PW%TYPE;
    ID_PW_ERROR EXCEPTION;
BEGIN
    --ID 불일치
    SELECT COUNT(*) INTO TEMP_NUM
    FROM PROFESSOR
    WHERE PRO_ID = V_ID;
    
    IF (TEMP_NUM=0)
        THEN RAISE ID_PW_ERROR;
    END IF;
    
    --PW 불일치
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
        THEN RAISE_APPLICATION_ERROR(-20001, '아이디 및 비밀번호가 일치하지 않습니다.');
   
END;
--==>> Procedure PRO_PROFESSOR_DELETE이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------
--8. 교수자 로그인 프로시저 (확인)
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
            THEN RAISE_APPLICATION_ERROR(-20001, '아이디 및 비밀번호가 일치하지 않습니다.');

END;
--==>> Procedure PRC_PRO_LOGIN이(가) 컴파일되었습니다.


--------------------------------------------------------------------------------
--9. 강의실 입력 프로시저 (강의실 입력이 선행되어야 과정정보 입력시 강의실 참조 가능) (확인)
CREATE OR REPLACE PROCEDURE PRC_ROOM_INSERT
( V_ROOM_NO         IN ROOM.ROOM_NO%TYPE
, V_ROOM_CAPACITY   IN ROOM.ROOM_CAPACITY%TYPE
)
IS
    TEMP_NUM            NUMBER; --강의실 번호가 중복된 값인지 확인하기 위한 임시 변수
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
            THEN RAISE_APPLICATION_ERROR(-20020, '이미 등록된 강의실입니다.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==> Procedure PRC_ROOM_INSERT이(가) 컴파일되었습니다.


--------------------------------------------------------------------------------
--10. 강의실 삭제 프로시저 (입력을 만들었으니 혹시 몰라서...) (확인)
CREATE OR REPLACE PROCEDURE PRC_ROOM_DELETE
( V_ROOM_NO         IN ROOM.ROOM_NO%TYPE
)
IS
    TEMP_RNUM       NUMBER; --입력한 강의실이 존재하는지 확인을 위한 임시변수
    
    ROOM_ERROR      EXCEPTION; --입력한 강의실이 존재하지 않을 경우
BEGIN
    --입력한 강의실이 존재하지 않을 경우 에러 발생
    SELECT COUNT(*) INTO TEMP_RNUM
    FROM ROOM
    WHERE ROOM_NO=V_ROOM_NO;
    
    IF (TEMP_RNUM=0)
        THEN RAISE ROOM_ERROR;
    END IF;
    
    --DELETE 쿼리 작성
    DELETE
    FROM ROOM
    WHERE ROOM_NO=V_ROOM_NO;
    
    COMMIT;
    
    --예외 처리
    EXCEPTION
        WHEN ROOM_ERROR
            THEN RAISE_APPLICATION_ERROR(-20003, '입력한 강의실이 존재하지 않습니다.');
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==> Procedure PRC_ROOM_DELETE이(가) 컴파일되었습니다.


--------------------------------------------------------------------------------
--○ 과정번호를 위한 시퀀스 생성(SQL문서에서 선행) -> SEQ_CURRICULUM

--11. 과정 정보 입력 프로시저 (확인)
CREATE OR REPLACE PROCEDURE PRC_CUR_INSERT
( V_CUR_NAME        IN CURRICULUM.CUR_NAME%TYPE
, V_CUR_STARTDATE   IN CURRICULUM.CUR_STARTDATE%TYPE
, V_CUR_ENDDATE      IN CURRICULUM.CUR_ENDDATE%TYPE
, V_ROOM_NO         IN CURRICULUM.ROOM_NO%TYPE
)
IS
    V_CUR_NO    CURRICULUM.CUR_NO%TYPE;
    
    TEMP_RNUM    NUMBER; --입력한 강의실이 존재하는지 확인을 위한 임시변수
    TEMP_NNUM    NUMBER; --입력한 과정명이 중복인지 확인을 위한 임시변수
    
    STARTDATE_ERROR   EXCEPTION; --시작일>끝일일때 발생하는 에러
    ROOM_ERROR   EXCEPTION; --입력한 강의실이 존재하지 않을 경우 발생하는 에러
    NAME_ERROR   EXCEPTION; --입력한 과정명이 중복일 경우 발생하는 에러
BEGIN
    --시작일을 끝일보다 미래로 입력할 경우 에러 발생
    IF (V_CUR_STARTDATE>V_CUR_ENDDATE)
        THEN RAISE STARTDATE_ERROR;
    END IF;
    
    --입력한 강의실이 존재하지 않을 경우 에러 발생
    SELECT COUNT(*) INTO TEMP_RNUM
    FROM ROOM
    WHERE ROOM_NO=V_ROOM_NO;
    
    IF (TEMP_RNUM=0)
        THEN RAISE ROOM_ERROR;
    END IF;
    
    --과정명(UNIQUE)은 중복되면 안됨
    SELECT COUNT(*) INTO TEMP_NNUM
    FROM CURRICULUM
    WHERE CUR_NAME=V_CUR_NAME;
    
    IF (TEMP_NNUM!=0)
        THEN RAISE NAME_ERROR;
    END IF;
    
    --과정번호 생성(CUR-1, CUR-2, ..., CUR-999 의 형태)
    V_CUR_NO := ('CUR-' || TO_CHAR(SEQ_CURRICULUM.NEXTVAL));
    
    --INSERT 쿼리문 작성
    INSERT INTO CURRICULUM(CUR_NO, CUR_NAME, CUR_STARTDATE, CUR_ENDDATE, ROOM_NO)
    VALUES(V_CUR_NO, V_CUR_NAME, V_CUR_STARTDATE, V_CUR_ENDDATE, V_ROOM_NO);
    
    COMMIT;
    
    -- 예외처리
    EXCEPTION
        WHEN STARTDATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20030, '시작일은 종료일 이전 날짜로 설정해야 합니다.');
        WHEN ROOM_ERROR
            THEN RAISE_APPLICATION_ERROR(-20003, '입력한 강의실이 존재하지 않습니다.');
        WHEN NAME_ERROR
            THEN RAISE_APPLICATION_ERROR(-20024, '이미 등록된 과정입니다.');
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==> Procedure PRC_CUR_INSERT이(가) 컴파일되었습니다.


--------------------------------------------------------------------------------
--12. 과정 정보 수정 프로시저 (확인)
CREATE OR REPLACE PROCEDURE PRC_CUR_UPDATE
( V_CUR_NO          IN CURRICULUM.CUR_NO%TYPE
, V_CUR_NAME        IN CURRICULUM.CUR_NAME%TYPE
, V_CUR_STARTDATE   IN CURRICULUM.CUR_STARTDATE%TYPE
, V_CUR_ENDDATE     IN CURRICULUM.CUR_ENDDATE%TYPE
, V_ROOM_NO         IN CURRICULUM.ROOM_NO%TYPE
)
IS
    TEMP_NONUM   NUMBER; --과정번호 입력 확인 임시변수
    TEMP_RNUM    NUMBER; --입력한 강의실이 존재하는지 확인을 위한 임시변수
    TEMP_NNUM    NUMBER; --입력한 과정명이 중복인지 확인을 위한 임시변수
    TEMP_SDNUM   NUMBER; --과정시작일과 과목시작일 비교 임시변수
    TEMP_EDNUM   NUMBER; --과정종료일과 과목종료일 비교 임시변수
    
    NUMBER_ERROR    EXCEPTION; --과정번호 존재하지 않을경우 
    STARTDATE_ERROR EXCEPTION; --시작일이 종료일보다 이를 경우
    ROOM_ERROR      EXCEPTION; --입력한 강의실이 존재하지 않을 경우
    NAME_ERROR      EXCEPTION; --입력한 과정명이 이미 존재할 경우
    DATE_ERROR      EXCEPTION; --1. 과정에 등록된 과목들 종료일이 수정하려는 과정종료일보다 이를 경우
                                --2. 과정에 등록된 과목들 시작일이 과정 시작일보다 이를 경우 에러 발생
                                --[과정 시작일 (과목1) (과목2) (과목3) 과정종료일]
BEGIN
    --입력한 과정번호가 존재하는지 확인
    SELECT COUNT(*) INTO TEMP_NONUM
    FROM CURRICULUM
    WHERE CUR_NO=V_CUR_NO;
    
    IF (TEMP_NONUM=0)
        THEN RAISE NUMBER_ERROR;
    END IF;
    
    --시작일을 끝일보다 미래로 입력할 경우 에러 발생
    IF (V_CUR_STARTDATE>V_CUR_ENDDATE)
        THEN RAISE STARTDATE_ERROR;
    END IF;
    
    --입력한 강의실이 존재하지 않을 경우 에러 발생
    SELECT COUNT(*) INTO TEMP_RNUM
    FROM ROOM
    WHERE ROOM_NO=V_ROOM_NO;
    
    IF (TEMP_RNUM=0)
        THEN RAISE ROOM_ERROR;
    END IF;
    
    --과정명(UNIQUE)은 중복되면 안됨
    SELECT COUNT(*) INTO TEMP_NNUM
    FROM CURRICULUM
    WHERE CUR_NAME=V_CUR_NAME
      AND CUR_NO!=V_CUR_NO; --UPDATE하고자 하는 과정 제외
    
    IF (TEMP_NNUM!=0)
        THEN RAISE NAME_ERROR;
    END IF;
    
    --과정시작일[ (과목 시작일 ~ 과목 종료일) ]과정 종료일 의 형태를 벗어난 경우 에러
    SELECT CASE WHEN MIN(SUB_STARTDATE) < V_CUR_STARTDATE THEN 0 ELSE 1 END
            INTO TEMP_SDNUM
            --조건1 : 과정시작일<과목시작일 → 조건 어긋나면 0, 해당되면 1 (과목시작일이 NULL이어도 1)
    FROM SUB_LIST
    WHERE CUR_NO=V_CUR_NO;
    
    SELECT CASE WHEN MAX(SUB_ENDDATE) > V_CUR_ENDDATE THEN 0 ELSE 1 END
            INTO TEMP_EDNUM
            --조건2 : 과정종료일>과목종료일 → 조건 어긋나면 0, 해당되면 1 (과목종료일이 NULL이어도 1)
    FROM SUB_LIST
    WHERE CUR_NO=V_CUR_NO;
    
    IF (TEMP_SDNUM=0 OR TEMP_EDNUM=0)
        THEN RAISE DATE_ERROR;
    END IF;

    --UPDATE 쿼리 작성
    UPDATE CURRICULUM
    SET CUR_NAME=V_CUR_NAME, CUR_STARTDATE=V_CUR_STARTDATE, CUR_ENDDATE=V_CUR_ENDDATE, ROOM_NO=V_ROOM_NO
    WHERE CUR_NO=V_CUR_NO;
    
    COMMIT;
    
    --예외처리
    EXCEPTION
        WHEN NUMBER_ERROR
            THEN RAISE_APPLICATION_ERROR(-20005, '입력한 과정번호가 존재하지 않습니다.');
        WHEN STARTDATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20030, '시작일은 종료일 이전 날짜로 설정해야 합니다.');
        WHEN ROOM_ERROR
            THEN RAISE_APPLICATION_ERROR(-20003, '입력한 강의실이 존재하지 않습니다.');
        WHEN NAME_ERROR
            THEN RAISE_APPLICATION_ERROR(-20024, '이미 등록된 과정입니다.');
        WHEN DATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20031, '과목 기간이 과정 기간을 초과할 수 없습니다.');
            
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==> Procedure PRC_CUR_UPDATE이(가) 컴파일되었습니다.


--------------------------------------------------------------------------------
--13. 과정 정보 삭제 프로시저 (확인)
CREATE OR REPLACE PROCEDURE PRC_CUR_DELETE
( V_CUR_NO          IN CURRICULUM.CUR_NO%TYPE
)
IS
    TEMP_NONUM   NUMBER; --과정번호 입력 확인 임시변수
    TEMP_DATE    CURRICULUM.CUR_STARTDATE%TYPE;
    
    NUMBER_ERROR    EXCEPTION; --과정번호 존재하지 않을경우
    DATE_ERROR      EXCEPTION;
BEGIN
    --입력한 과정번호가 존재하는지 확인
    SELECT COUNT(*) INTO TEMP_NONUM
    FROM CURRICULUM
    WHERE CUR_NO=V_CUR_NO;
    
    IF (TEMP_NONUM=0)
        THEN RAISE NUMBER_ERROR;
    END IF;
    
    --이미 진행중인 과정이면 지울 수 없음
    SELECT CUR_STARTDATE INTO TEMP_DATE
    FROM CURRICULUM
    WHERE CUR_NO=V_CUR_NO;
    
    IF (SYSDATE>=TEMP_DATE)
        THEN RAISE DATE_ERROR;
    END IF;
    
    --DELETE 쿼리 작성
    DELETE
    FROM CURRICULUM
    WHERE CUR_NO=V_CUR_NO;
    
    COMMIT;
    
    --예외처리
    EXCEPTION
        WHEN NUMBER_ERROR
            THEN RAISE_APPLICATION_ERROR(-20005, '입력한 과정번호가 존재하지 않습니다.');
        WHEN DATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20036, '이미 시작된 과정입니다.');
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>> Procedure PRC_CUR_DELETE이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------
--(교재-과목-과목개설)

--14. 교재 입력 프로시저 (확인)
CREATE OR REPLACE PROCEDURE PRC_BOOK_INSERT
( V_BOOK_NAME      IN BOOK.BOOK_NAME%TYPE
, V_AUTHOR_NAME   IN BOOK.AUTHOR_NAME%TYPE   
, V_PUBLISHER      IN BOOK.PUBLISHER%TYPE
)
IS
   V_BOOK_NO     BOOK.BOOK_NO%TYPE;    --과정번호 생성 임시변수

   TEMP_NUM      NUMBER;    --교재번호가 중복된 값인지 확인하기 위한 임시변수
   
    USER_DEFINE_ERROR   EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO TEMP_NUM            --이미 존재하면 예외
    FROM BOOK
    WHERE BOOK_NAME=V_BOOK_NAME;

    IF (TEMP_NUM!=0)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;

   --교재번호 생성
   V_BOOK_NO :=  ('BOOK-' || TO_CHAR(SEQ_BOOK.NEXTVAL));

   --INSERT 쿼리문 작성
   INSERT INTO BOOK(BOOK_NO, BOOK_NAME,AUTHOR_NAME,PUBLISHER) 
   VALUES(V_BOOK_NO, V_BOOK_NAME,V_AUTHOR_NAME,V_PUBLISHER);

   COMMIT;

   --예외 처리
   EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20019, '이미 등록된 교재입니다.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==> Procedure PRC_BOOK_INSERT이(가) 컴파일되었습니다.


--------------------------------------------------------------------------------
--15. 교재 삭제 프로시저 (확인)
CREATE OR REPLACE PROCEDURE PRC_BOOK_DELETE
( V_BOOK_NO      IN BOOK.BOOK_NO%TYPE
)
IS 
   TEMP_NUM    NUMBER;  --교재번호 입력확인 임시변수
   BOOK_ERROR   EXCEPTION;  --교재번호 존재하지 않을때   
BEGIN
   --입력한 교재 존재여부 확인
   SELECT COUNT(*) INTO TEMP_NUM
   FROM BOOK
   WHERE BOOK_NO = V_BOOK_NO;

   IF (TEMP_NUM=0)
      THEN RAISE BOOK_ERROR;
   END IF;

   --DELETE 쿼리문 작성
   DELETE
   FROM BOOK
   WHERE BOOK_NO=V_BOOK_NO;

   COMMIT;

   --예외처리
   EXCEPTION
     WHEN BOOK_ERROR
        THEN  RAISE_APPLICATION_ERROR(-20006, '입력한 교재번호가 존재하지 않습니다.');
            ROLLBACK;
     WHEN OTHERS
         THEN ROLLBACK;
END;
--==> Procedure PRC_BOOK_DELETE이(가) 컴파일되었습니다.


--------------------------------------------------------------------------------
--16. 과목 입력 프로시저(확인)
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
    
    --과목명 동일 에러
    IF (TEMP_NUM!=0)
        THEN RAISE SUB_ERROR;
    END IF;
    
    --교재번호가 교재테이블에 등록되지 않았을 경우
    IF (TEMP_NUM2=0)
        THEN RAISE BOOK_NUM_ERROR;
    END IF;
    

    --과목번호
    V_SUB_NO :=  ('SUB-' || TO_CHAR(SEQ_SUBJECT.NEXTVAL));

    --INSERT
    INSERT INTO SUBJECT(SUB_NO, SUB_NAME, BOOK_NO)
    VALUES(V_SUB_NO, V_SUB_NAME, V_BOOK_NO);
    
    COMMIT;
    
    
    --예외 처리
    EXCEPTION
        WHEN SUB_ERROR
            THEN RAISE_APPLICATION_ERROR(-20022, '이미 등록된 과목입니다.');
                 ROLLBACK;
        WHEN BOOK_NUM_ERROR
            THEN RAISE_APPLICATION_ERROR(-20006, '입력한 교재번호가 존재하지 않습니다.');
                 ROLLBACK;
        WHEN OTHERS THEN ROLLBACK;
END;
--==>> Procedure PRC_SUB_INSERT이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------
--17. 과목 수정 프로시저 (확인)
CREATE OR REPLACE PROCEDURE PRC_SUB_UPDATE
( V_SUB_NO          IN SUBJECT.SUB_NO%TYPE
, V_SUB_NAME      IN SUBJECT.SUB_NAME%TYPE
, V_BOOK_NO       IN BOOK.BOOK_NAME%TYPE
)
IS
   TEMP_SBNUM      NUMBER;  --과목번호 입력확인 임시변수
   TEMP_BOOKNO  BOOK.BOOK_NO%TYPE;  --교재번호가 존재하는지 확인하는 임시변수
 
   SUBNUM_ERROR   EXCEPTION;  --과목번호 존재하지 않을때
   BOOKNO_ERROR EXCEPTION;  -- 교재번호가 존재하지 않을 때
  
BEGIN
   --입력한 과목번호 존재여부 확인
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

   --UPDATE 쿼리문 작성
   UPDATE SUBJECT
   SET SUB_NO=V_SUB_NO, SUB_NAME=V_SUB_NAME, BOOK_NO=V_BOOK_NO
   WHERE SUB_NO = V_SUB_NO;

   COMMIT;

   --예외처리
   EXCEPTION
     WHEN SUBNUM_ERROR
          THEN RAISE_APPLICATION_ERROR(-20012, '입력한 과목번호가 존재하지 않습니다.');
                     ROLLBACK;
    WHEN BOOKNO_ERROR
        THEN RAISE_APPLICATION_ERROR(-20014, '입력한 교재번호가 존재하지 않습니다.');
    WHEN OTHERS
      THEN ROLLBACK;
END;
--==> Procedure PRC_SUB_UPDATE이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------
--18. 과목 삭제 프로시저(확인)
CREATE OR REPLACE PROCEDURE PRC_SUB_DELETE
( V_SUB_NO      IN SUBJECT.SUB_NO%TYPE
, V_SUB_NAME    IN SUBJECT.SUB_NAME%TYPE
)
IS
    TEMP_NUM    NUMBER;
    TEMP_NAME   SUBJECT.SUB_NAME%TYPE;
    
    SUB_ERROR  EXCEPTION;
BEGIN
    -- 존재하지 않는 과목번호 에러
    SELECT COUNT(*) INTO TEMP_NUM
    FROM SUBJECT
    WHERE SUB_NO = V_SUB_NO;
    
    IF (TEMP_NUM = 0)
        THEN RAISE SUB_ERROR;
    END IF;
      
    -- 과목명과 과목번호 불일치
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
    
       
    --예외 처리
    EXCEPTION
        WHEN SUB_ERROR
            THEN RAISE_APPLICATION_ERROR(-20007, '입력한 과목이 존재하지 않습니다.');
                 ROLLBACK;
        WHEN OTHERS THEN ROLLBACK;
END;
--==>> Procedure PRC_SUBJECT_DELETE이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------
--19. 과목개설 입력 프로시저 (확인)
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
    V_SLI_NO        SUB_LIST.LIST_NO%TYPE;  -- 시퀀스 설정에 필요한 변수
    TEMP_NUM        NUMBER;                 -- 과목번호 존재여부 확인에 필요한 변수
    
    DATE_ERROR      EXCEPTION; -- 1. 과목번호가 이미 존재할 때 발생하는 에러
    SUB_NO_ERROR    EXCEPTION; -- 2. 과목 시작일이 과목 종료일보다 미래일 때 발생하는 에러
    DIV_ERROR       EXCEPTION; -- 3. 출결, 실기, 필기 배점이 각각 0보다 작을 때 발생하는 에러
    DIV_SUM_ERROR   EXCEPTION; -- 4. 출결, 실기, 필기 배점을 합치면 100이 되지 않을 때 발생하는 에러
    
BEGIN
    -- 1. 과목번호가 이미 존재할 때 에러 발생
    SELECT COUNT(*) INTO TEMP_NUM
    FROM SUB_LIST
    WHERE SUB_NO = V_SUB_NO;
    
    IF (TEMP_NUM != 0)
        THEN RAISE SUB_NO_ERROR;
    END IF;
    
    -- 2. 과목 시작일 > 과목 종료일일 때 에러 발생
    IF (V_SUB_STARTDATE > V_SUB_ENDDATE)
        THEN RAISE DATE_ERROR;
    END IF;

    -- 3. 출결, 실기, 필기 배점이 각각 0보다 작을 때 에러 발생
    IF ( (V_ATTEND_DIV < 0) OR (V_PRAC_DIV < 0) OR (V_WRITE_DIV < 0) )
        THEN RAISE DIV_ERROR;
    END IF;
    
    -- 4. 출결, 실기, 필기 배점을 합치면 100이 되지 않을 때 에러 발생
    IF (V_ATTEND_DIV + V_PRAC_DIV + V_WRITE_DIV != 100)
        THEN RAISE DIV_SUM_ERROR;
    END IF;

    -- 과정번호 생성(시퀀스 활용을 통해 자동 증가되게 설정)
    V_SLI_NO := ('SLI-' || TO_CHAR(SEQ_SUB_LIST.NEXTVAL));
    
    -- INSERT 구문 작성
    INSERT INTO SUB_LIST(LIST_NO, CUR_NO, SUB_NO, SUB_STARTDATE, SUB_ENDDATE, PRO_ID, ATTEND_DIV, PRAC_DIV, WRITE_DIV)
    VALUES(V_SLI_NO, V_CUR_NO, V_SUB_NO, V_SUB_STARTDATE, V_SUB_ENDDATE, V_PRO_ID, V_ATTEND_DIV, V_PRAC_DIV, V_WRITE_DIV);
    
    COMMIT;
    
    -- 예외 처리
    EXCEPTION 
        WHEN SUB_NO_ERROR
            THEN RAISE_APPLICATION_ERROR(-20022, '이미 등록된 과목입니다.'); 
            ROLLBACK;
        WHEN DATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20030, '시작일은 종료일 이전 날짜로 설정해야 합니다.');
            ROLLBACK;
        WHEN DIV_ERROR
            THEN RAISE_APPLICATION_ERROR(-20028, '[0 - 100]점 범위 내에서 입력 가능합니다.');
            ROLLBACK;
        WHEN DIV_SUM_ERROR
            THEN RAISE_APPLICATION_ERROR(-20027, '배점의 총합은 [100] 이어야 합니다.');
            ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>> Procedure PRC_SLI_INSERT이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------
--20. 과목개설 수정 프로시저 (확인)
--입력시 받는 항목 : (과정명, 과목명, 과목 기간(시작 연월일, 끝 연월일), 교재 명, 교수자 명)
--같은 과목이면 같은 교재를 사용하므로 교재에 대한 수정권한은 없음
CREATE OR REPLACE PROCEDURE PRC_SUBLIST_UPDATE
( V_LIST_NO         IN SUB_LIST.LIST_NO%TYPE
, V_SUB_NAME        IN SUBJECT.SUB_NAME%TYPE
, V_SUB_STARTDATE   IN SUB_LIST.SUB_STARTDATE%TYPE
, V_SUB_ENDDATE     IN SUB_LIST.SUB_ENDDATE%TYPE
, V_PRO_ID          IN SUB_LIST.PRO_ID%TYPE
)
IS
    V_SUB_NO        SUB_LIST.SUB_NO%TYPE; --업데이트할 과목번호를 저장하는 변수
    V_CUR_NO        SUB_LIST.CUR_NO%TYPE; --업데이트할 과목의 과정 번호를 저장하는 변수
    V_CUR_STARTDATE CURRICULUM.CUR_STARTDATE%TYPE;  --과정 시작일 저장하는 변수
    V_CUR_ENDDATE   CURRICULUM.CUR_ENDDATE%TYPE;    --과정 종료일 저장하는 변수
    
    TEMP_LNUM       NUMBER; --과목개설번호 존재여부 확인 임시변수
    TEMP_NNUM       NUMBER; --과목명 존재여부 확인 임시변수
    TEMP_PNUM       NUMBER; --교수가 존재하는지 확인 임시변수
    
    LISTNO_ERROR    EXCEPTION;
    NAME_ERROR      EXCEPTION;
    PROF_ERROR      EXCEPTION;
    DATE_ERROR      EXCEPTION;
BEGIN
    --과목개설번호가 존재하지 않을 경우
    SELECT COUNT(*) INTO TEMP_LNUM
    FROM SUB_LIST
    WHERE LIST_NO=V_LIST_NO;
    
    IF (TEMP_LNUM=0)
        THEN RAISE LISTNO_ERROR;
    END IF;
    
    --변경할 과목명이 과목 테이블에 등록이 되어 있는지 확인(없으면 에러)
    SELECT COUNT(*) INTO TEMP_NNUM
    FROM SUBJECT
    WHERE SUB_NAME=V_SUB_NAME;
    
    IF (TEMP_NNUM=0)
        THEN RAISE NAME_ERROR;
    END IF;
    
    --변경할 교수 아이디가 존재하는지 확인(없으면 에러)
    SELECT COUNT(*) INTO TEMP_PNUM
    FROM PROFESSOR
    WHERE PRO_ID=V_PRO_ID;
    
    IF (TEMP_PNUM=0)
        THEN RAISE PROF_ERROR;
    END IF;

    --수정할 과목 기간이 과정 기간 범위를 벗어나면 안됨
    --조건1 과정시작일<=과목시작일
    --조건2 과정종료일>=과목종료일
    SELECT CUR_NO INTO V_CUR_NO     --과정번호 담기
    FROM SUB_LIST
    WHERE LIST_NO=V_LIST_NO;
    
    SELECT NVL(CUR_STARTDATE, V_SUB_STARTDATE), NVL(CUR_ENDDATE, V_SUB_ENDDATE)
            INTO V_CUR_STARTDATE, V_CUR_ENDDATE
            --과정기간 담기(과정기간이 NULL일경우 비교를 위해 변경할 과목기간을 담음)
    FROM CURRICULUM
    WHERE CUR_NO=V_CUR_NO;
    
    IF (V_CUR_STARTDATE>V_SUB_STARTDATE OR V_CUR_ENDDATE<V_SUB_ENDDATE)
        --조건1이 충족이 안 되면           --조건2가 충족이 안 되면
        THEN RAISE DATE_ERROR; --에러 발생
    END IF;
    
    
    --변경할 과목명에 해당하는 과목번호 변수에 저장
    SELECT SUB_NO INTO V_SUB_NO
    FROM SUBJECT
    WHERE SUB_NAME=V_SUB_NAME;
    
    --UPDATE 쿼리문 작성
    UPDATE SUB_LIST
    SET SUB_STARTDATE=V_SUB_STARTDATE, SUB_ENDDATE=V_SUB_ENDDATE, PRO_ID=V_PRO_ID, SUB_NO=V_SUB_NO
    WHERE LIST_NO=V_LIST_NO;
    
    COMMIT;
    
    --예외처리
    EXCEPTION
    WHEN LISTNO_ERROR
        THEN RAISE_APPLICATION_ERROR(-20035, '개설된 과목이 없습니다.');
    WHEN NAME_ERROR
        THEN RAISE_APPLICATION_ERROR(-20007, '입력한 과목이 존재하지 않습니다.');
    WHEN PROF_ERROR
        THEN RAISE_APPLICATION_ERROR(-20011, '입력한 교수자가 존재하지 않습니다.');
    WHEN DATE_ERROR
        THEN RAISE_APPLICATION_ERROR(-20031, '과목 기간이 과정 기간을 초과할 수 없습니다.');
    WHEN OTHERS
        THEN ROLLBACK;
END;
--==> Procedure PRC_SUBLIST_UPDATE이(가) 컴파일되었습니다.


--------------------------------------------------------------------------------
--21. 과목개설 삭제 프로시저 (확인)
CREATE OR REPLACE PROCEDURE PRC_SLI_DELETE
( V_LIST_NO     SUB_LIST.LIST_NO%TYPE
)
IS
    V_SUB_STARTDATE SUB_LIST.SUB_STARTDATE%TYPE;
    TEMP_NUM        NUMBER;
    
    SUB_NO_ERROR    EXCEPTION; -- 과목번호가 존재하지 않을 때 발생하는 에러
    STARTDATE_ERROR EXCEPTION;
BEGIN
    -- 과목번호가 존재하지 않을 때 에러 발생
    SELECT COUNT(*) INTO TEMP_NUM
    FROM SUB_LIST
    WHERE LIST_NO = V_LIST_NO;
    
    IF (TEMP_NUM = 0)
        THEN RAISE SUB_NO_ERROR;
    END IF;
    
    -- 개설된 과목이 이미 시작했을 경우 삭제 불가능(시작 전 과목만 삭제 가능)
    SELECT SUB_STARTDATE INTO V_SUB_STARTDATE
    FROM SUB_LIST
    WHERE LIST_NO=V_LIST_NO;
    
    IF (SYSDATE>V_SUB_STARTDATE)
        THEN RAISE STARTDATE_ERROR;
    END IF;
    
    -- DELETE 구문 작성
    DELETE
    FROM SUB_LIST
    WHERE LIST_NO = V_LIST_NO;
    
    COMMIT;
    
    -- 예외 처리
    EXCEPTION
        WHEN SUB_NO_ERROR
            THEN RAISE_APPLICATION_ERROR(-20007, '입력한 과목이 존재하지 않습니다.');
            ROLLBACK;
        WHEN STARTDATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20038, '이미 시작된 과목입니다.');
            ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>> Procedure PRC_SLI_DELETE이(가) 컴파일되었습니다.


--------------------------------------------------------------------------------
--22. 배점 수정 프로시저 (확인)
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
                THEN RAISE_APPLICATION_ERROR(-20027, '배점의 총합은 [100] 이어야 합니다.');
            WHEN USER_DEFINE_ERROR2
                THEN RAISE_APPLICATION_ERROR(-20034, '해당 교수자의 담당 과목이 아닙니다.');
            WHEN USER_DEFINE_ERROR3
                THEN RAISE_APPLICATION_ERROR(-20032, '이미 시작된 과목의 배점을 변경할 수 없습니다.');
                        
END;
--==> Procedure PRC_DIV_UPDATE이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------
--23. 학생 계정 생성 프로시저 (확인)
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
    --중복ID   
    SELECT COUNT(*) INTO TEMP_ID
    FROM STUDENT
    WHERE STU_ID = V_ID;

    IF (TEMP_ID != 0)
        THEN RAISE ID_ERROR;
    END IF;
    
    --중복 주민번호
    SELECT COUNT(*) INTO TEMP_NUM
    FROM STUDENT
    WHERE STU_FIRSTSSN = V_FIRSTSSN
      AND STU_LASTSSN = V_LASTSSN;
    
    IF (TEMP_NUM != 0)
        THEN RAISE SSN_ERROR;
    END IF;
    
    --주민번호 자릿수 오류 및 뒷자리 첫숫자(1~6)
    --5,6 외국인번호
    IF (LENGTH(V_FIRSTSSN) != 6 OR LENGTH(V_LASTSSN) != 7
        OR SUBSTR(V_LASTSSN, 1, 1) NOT IN ('1', '2', '3', '4', '5', '6'))
        THEN RAISE SSN_NUM_ERROR;
    END IF;
    
    
    --INSERT
    INSERT INTO STUDENT(STU_ID, STU_NAME, STU_FIRSTSSN, STU_LASTSSN)
    VALUES(V_ID, V_NAME, V_FIRSTSSN, V_LASTSSN);
    
    COMMIT;
    
    
    --예외처리
    EXCEPTION
        WHEN ID_ERROR
            THEN RAISE_APPLICATION_ERROR(-20018, '이미 등록된 ID입니다.');
                ROLLBACK;
        WHEN SSN_ERROR
            THEN RAISE_APPLICATION_ERROR(-20017, '이미 등록된 학생입니다.');
                ROLLBACK;  
        WHEN SSN_NUM_ERROR       
            THEN RAISE_APPLICATION_ERROR(-20002, '입력한 주민번호가 일치하지 않습니다.');
                ROLLBACK;
        WHEN OTHERS THEN ROLLBACK;
            
END;
--==>> Procedure PRC_STU_INSERT이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------
--24. 학생 계정 수정 프로시저(확인)
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
    --잘못된 ID
    SELECT COUNT(*) INTO TEMP_ID
    FROM STUDENT
    WHERE STU_ID = V_ID;
        
    IF (TEMP_ID = 0)
        THEN RAISE ID_ERROR;
    END IF;
    
    --잘못된 주민번호
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
    
    
    --예외처리
    EXCEPTION
        WHEN ID_ERROR
            THEN RAISE_APPLICATION_ERROR(-20015, '입력한 ID가 존재하지 않습니다.');
                ROLLBACK;
        WHEN SSN_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002, '입력한 주민번호가 일치하지 않습니다.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;

END;
--==> Procedure PRC_STU_UPDATE이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------
--25. 학생 계정 삭제 프로시저(확인)
CREATE OR REPLACE PROCEDURE PRC_STU_DELETE
( V_ID IN STUDENT.STU_ID%TYPE
, V_PW IN STUDENT.STU_PW%TYPE
)
IS
    TEMP_NUM    NUMBER;
    TEMP_PW     STUDENT.STU_PW%TYPE;
    ID_PW_ERROR EXCEPTION;
BEGIN
    --ID 불일치
    SELECT COUNT(*) INTO TEMP_NUM
    FROM STUDENT
    WHERE STU_ID = V_ID;
    
    IF (TEMP_NUM=0)
        THEN RAISE ID_PW_ERROR;
    END IF;
    
    --PW 불일치
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
   
   
   --예외처리
   EXCEPTION
        WHEN ID_PW_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001, '아이디 및 비밀번호가 일치하지 않습니다.');
        WHEN OTHERS THEN ROLLBACK;
END;
--==>> Procedure PRC_STU_DELETE이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------
--26. 학생 로그인 프로시저 (확인)
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
            THEN RAISE_APPLICATION_ERROR(-20001, '아이디 및 비밀번호가 일치하지 않습니다.');

END;
--==> Procedure PRC_STU_LOGIN이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------
--27. 중도탈락 생성 프로시저 (확인)
CREATE OR REPLACE PROCEDURE PRC_DROP_INSERT
( V_REG_NO           IN STU_DROP.REG_NO%TYPE
, V_REASON_NO        IN STU_DROP.REASON_NO%TYPE
)
IS
    V_DROP_NO           STU_DROP.DROP_NO%TYPE;
    
    TEMP_NUM            NUMBER;
    REG_NO_ERROR        EXCEPTION;
BEGIN
    
    -- 수강신청번호가 이미 등록되어 있으면 에러 발생
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
            THEN RAISE_APPLICATION_ERROR(-20023, '이미 등록된 중도탈락 학생입니다.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;

--------------------------------------------------------------------------------
--28. 중도탈락학생 수정 프로시저(확인)
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
    -- 중도탈락번호가 존재하지 않을 시 예외처리
    SELECT COUNT(*) INTO TEMP_NUM
    FROM STU_DROP
    WHERE DROP_NO = V_DROP_NO;
    
    IF (TEMP_NUM = 0)
        THEN RAISE DROP_ERROR;
    END IF;
    
    -- 중도탈락이유가 존재하지 않을 시
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
    
    
    -- 예외처리
    EXCEPTION
        WHEN DROP_ERROR
            THEN RAISE_APPLICATION_ERROR(-20008, '입력한 중도탈락 정보가 존재하지 않습니다.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>> Procedure PRC_DROP_UPDATE이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------
--29. 중도탈락 삭제 프로시저 (확인)
CREATE OR REPLACE PROCEDURE PRC_DROP_DELETE
(V_DROP_NO   IN STU_DROP.DROP_NO%TYPE
)
IS
   TEMP_DNUM   NUMBER;
   
   DROP_ERROR   EXCEPTION;
BEGIN
   --중도탈락 번호가 존재하지 않을 경우 에러
   SELECT COUNT(*) INTO TEMP_DNUM
   FROM STU_DROP
   WHERE DROP_NO=V_DROP_NO;

   IF (TEMP_DNUM=0)
      THEN RAISE DROP_ERROR;
   END IF;

   --DELETE 쿼리문 
   DELETE
   FROM STU_DROP
   WHERE DROP_NO=V_DROP_NO;

   COMMIT;

   --예외처리
   EXCEPTION
      WHEN DROP_ERROR
         THEN RAISE_APPLICATION_ERROR(-20008, '입력한 중도탈락 정보가 존재하지 않습니다.');
      ROLLBACK;
     WHEN OTHERS
         THEN ROLLBACK;
END;
--==>> Procedure PRC_DROP_DELETE이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------
--30. 성적 정보 입력 프로시저 (성적 입력시 과목개설일이 SYSDATE 보다 미래면 예외처리) (확인)
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
    
    -- 성적 입력시 수강신청번호와 과목개설번호가 성적 테이블에 이미 존재하면 예외처리
    SELECT COUNT(*) INTO TEMP_NUM
    FROM SCORE
    WHERE REG_NO = V_REG_NO AND LIST_NO = V_LIST_NO;

    IF (TEMP_NUM != 0)
        THEN RAISE SCORE_NO_ERROR;
    END IF;
    
    -- 성적 입력시 과목개설일이 SYSDATE 보다 미래면 예외처리
    SELECT SUB_STARTDATE INTO V_SUB_STARTDATE
    FROM SUB_LIST
    WHERE LIST_NO = V_LIST_NO;
    
    IF (V_SUB_STARTDATE > SYSDATE)
        THEN RAISE DATE_ERROR;
    END IF;
    
    -- 수강신청번호 생성(시퀀스 활용을 통해 자동 증가되게 설정)
    V_SCORE_NO := ('SCO-' || TO_CHAR(SEQ_SCORE.NEXTVAL));
    
    INSERT INTO SCORE(SCORE_NO, REG_NO, LIST_NO, ATTEND_SCORE, PRAC_SCORE, WRITE_SCORE)
    VALUES(V_SCORE_NO, V_REG_NO, V_LIST_NO, V_ATTEND_SCORE, V_PRAC_SCORE, V_WRITE_SCORE);
    
    COMMIT;
    
    EXCEPTION
        WHEN SCORE_NO_ERROR
            THEN RAISE_APPLICATION_ERROR(-20026, '이미 등록된 성적입니다.');
                ROLLBACK;
        WHEN DATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20033, '강의 예정인 과목입니다.');
                ROLLBACK;        
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==> Procedure PRC_SCORE_INSERT이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------
--31. 성적 정보 수정 프로시저 (확인)
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

    -- 성적 입력시 해당 성적(성적번호)이 성적 테이블에 존재하지 않으면 예외처리
    SELECT COUNT(*) INTO TEMP_NUM
    FROM SCORE
    WHERE SCORE_NO = V_SCORE_NO;

    IF (TEMP_NUM = 0)
        THEN RAISE SCORE_NO_ERROR;
    END IF;
    
    -- 성적 입력시 각 성적 점수가 [0-100]점을 벗어나면 예외처리
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
            THEN RAISE_APPLICATION_ERROR(-20004, '입력한 성적이 존재하지 않습니다.');
                 ROLLBACK;
        WHEN SCORE_VALUE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20028, '[0 - 100]점 범위 내에서 입력 가능합니다.');
                ROLLBACK;        
        WHEN OTHERS
            THEN ROLLBACK;        

END;
--==>> Procedure PRC_SCORE_UPDATE이(가) 컴파일되었습니다.


--------------------------------------------------------------------------------
--32. 성적 정보 삭제 프로시저 (확인)
CREATE OR REPLACE PROCEDURE PRC_SCORE_DELETE
( V_SCORE_NO      IN SCORE.SCORE_NO%TYPE
)
IS
    TEMP_NUM            NUMBER;
    SCORE_NO_ERROR      EXCEPTION;
BEGIN
    
    -- 성적 삭제시 해당 성적(성적번호)이 성적 테이블에 존재하지 않으면 예외처리
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
            THEN RAISE_APPLICATION_ERROR(-20004, '입력한 성적이 존재하지 않습니다.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
    
END;
--==>> Procedure PRC_SCORE_DELETE이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------
--33. 학생 성적 확인 출력문(확인)
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
    
    --커서 정의
    CURSOR CUR_PRO_SUNGJUK      -- CURSOR 커서명
    IS                          
    SELECT *
    FROM VIEW_SUNGJUK
    WHERE 학생아이디 = 'JJH234'; -- 여기에 학생정보 넣기
    

BEGIN
    --커서 오픈
    OPEN CUR_PRO_SUNGJUK;
    
    --반복문으로 출력
    LOOP
        -- 한 행씩 끄집어내어 가져오는 행위 → FETCH
        FETCH CUR_PRO_SUNGJUK INTO  V_PRO_ID, V_STU_ID,  V_STU_NAME, V_CUR_NAME, V_SUB_NAME
                        , V_SUB_STARTDATE, V_SUB_ENDDATE, V_BOOK_NAME
                        , V_ATTEND_SCORE, V_PRAC_SCORE, V_WRITE_SCORE
                        , V_TOTAL_SCORE , V_RANK;
        
        -- 커서에서 아무것도 찾지 못했을 때 반복문 종료
        EXIT WHEN CUR_PRO_SUNGJUK%NOTFOUND; 
        
        -- 출력
        DBMS_OUTPUT.PUT_LINE(  V_STU_NAME|| '   ' || V_CUR_NAME || '   ' || V_SUB_NAME
                         || '   ' || V_SUB_STARTDATE || '   ' || V_SUB_ENDDATE|| '   ' ||
                         V_BOOK_NAME || '   ' || V_ATTEND_SCORE || '   ' || V_PRAC_SCORE || '   ' || V_WRITE_SCORE 
                         || '   ' || V_TOTAL_SCORE || '   ' || V_RANK);
    END LOOP;
    
    -- 커서 클로즈
    CLOSE CUR_PRO_SUNGJUK;
END;
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

--------------------------------------------------------------------------------
--34. 학생의 중도탈락여부 출력 (확인)
DECLARE
    V_PRO_ID                       SUB_LIST.PRO_ID%TYPE;
    V_STU_ID                        STUDENT.STU_ID%TYPE;
    V_REG_NO                     REGISTRATION.REG_NO%TYPE;
    V_STU_NAME                 STUDENT.STU_NAME%TYPE;
    V_CUR_NAME                CURRICULUM.CUR_NAME%TYPE;
    V_SUB_NAME                 SUBJECT.SUB_NAME%TYPE;
    V_STU_DROPDATE         STU_DROP.STU_DROPDATE%TYPE;
    
    --커서 정의
    CURSOR CUR_STU_DROP   -- CURSOR 커서명
    IS                          
    SELECT *
    FROM  VIEW_DROP
    WHERE 학생아이디 = 'JJH234';
    

BEGIN
    --커서 오픈
    OPEN CUR_STU_DROP;
    
    --반복문으로 출력
    LOOP
        -- 한 행씩 끄집어내어 가져오는 행위 → FETCH
        FETCH CUR_STU_DROP INTO  V_PRO_ID, V_STU_ID, V_REG_NO,  V_STU_NAME, V_CUR_NAME, V_SUB_NAME, V_STU_DROPDATE;
        
        -- 커서에서 아무것도 찾지 못했을 때 반복문 종료
        EXIT WHEN CUR_STU_DROP%NOTFOUND; 
        
        -- 출력
        DBMS_OUTPUT.PUT_LINE(  V_REG_NO || '   ' || V_STU_NAME|| '   ' || V_CUR_NAME 
                    || '   ' || V_SUB_NAME || '   ' ||  V_STU_DROPDATE);
    END LOOP;
    
    -- 커서 클로즈
    CLOSE CUR_STU_DROP;
END;


--------------------------------------------------------------------------------
--35. 교수 성적 확인 출력문(확인)
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
    
    --커서 정의
    CURSOR CUR_PRO_SUNGJUK      -- CURSOR 커서명
    IS                          
    SELECT *
    FROM VIEW_SUNGJUK
    WHERE 교수아이디 = 'KHJ123';
    

BEGIN
    --커서 오픈
    OPEN CUR_PRO_SUNGJUK;
    
    --반복문으로 출력
    LOOP
        -- 한 행씩 끄집어내어 가져오는 행위 → FETCH
        FETCH CUR_PRO_SUNGJUK INTO  V_PRO_ID, V_STU_ID,  V_STU_NAME, V_CUR_NAME, V_SUB_NAME
                        , V_SUB_STARTDATE, V_SUB_ENDDATE, V_BOOK_NAME
                        , V_ATTEND_SCORE, V_PRAC_SCORE, V_WRITE_SCORE
                        , V_TOTAL_SCORE , V_RANK;
        
        -- 커서에서 아무것도 찾지 못했을 때 반복문 종료
        EXIT WHEN CUR_PRO_SUNGJUK%NOTFOUND; 
        
        -- 출력
        DBMS_OUTPUT.PUT_LINE( V_PRO_ID || '   ' ||  V_STU_NAME || '   ' || V_SUB_NAME
                         || '   ' || V_SUB_STARTDATE || '   ' || V_SUB_ENDDATE|| '   ' || V_BOOK_NAME 
                         || '   ' || V_ATTEND_SCORE || '   ' || V_PRAC_SCORE || '   ' || V_WRITE_SCORE 
                         || '   ' || V_TOTAL_SCORE || '   ' || V_RANK);
    END LOOP;
    
    -- 커서 클로즈
    CLOSE CUR_PRO_SUNGJUK;
END;
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

--------------------------------------------------------------------------------
--36. 교수의 학생 중도탈락여부 출력 확인 (확인)
DECLARE
    V_PRO_ID                       SUB_LIST.PRO_ID%TYPE;
    V_STU_ID                        STUDENT.STU_ID%TYPE;
    V_REG_NO                     REGISTRATION.REG_NO%TYPE;
    V_STU_NAME                 STUDENT.STU_NAME%TYPE;
    V_CUR_NAME                CURRICULUM.CUR_NAME%TYPE;
    V_SUB_NAME                 SUBJECT.SUB_NAME%TYPE;
    V_STU_DROPDATE         STU_DROP.STU_DROPDATE%TYPE;
    
    --커서 정의
    CURSOR CUR_STU_DROP   -- CURSOR 커서명
    IS                          
    SELECT *
    FROM  VIEW_DROP
    WHERE 교수아이디 = 'KHJ123';
    

BEGIN
    --커서 오픈
    OPEN CUR_STU_DROP;
    
    --반복문으로 출력
    LOOP
        -- 한 행씩 끄집어내어 가져오는 행위 → FETCH
        FETCH CUR_STU_DROP INTO  V_PRO_ID, V_STU_ID, V_REG_NO,  V_STU_NAME, V_CUR_NAME, V_SUB_NAME, V_STU_DROPDATE;
        
        -- 커서에서 아무것도 찾지 못했을 때 반복문 종료
        EXIT WHEN CUR_STU_DROP%NOTFOUND; 
        
        -- 출력
        DBMS_OUTPUT.PUT_LINE(  V_REG_NO || '   ' || V_STU_NAME|| '   ' || V_CUR_NAME 
                    || '   ' || V_SUB_NAME || '   ' ||  V_STU_DROPDATE);
    END LOOP;
    
    -- 커서 클로즈
    CLOSE CUR_STU_DROP;
END;

--------------------------------------------------------------------------------
--37. 중도탈락사유 생성 프로시저 (확인)
CREATE OR REPLACE PROCEDURE PRC_DRP_INSERT
( V_REASON        DROP_RES.REASON%TYPE
)
IS
    V_DRP_NO        DROP_RES.REASON_NO%TYPE;  -- 시퀀스 설정에 필요한 변수
    TEMP_NUM        NUMBER;                   -- 탈락사유번호 존재여부 확인에 필요한 변수
    
    REASON_ERROR    EXCEPTION; -- 동일 탈락사유가 이미 존재할 때 발생하는 에러
BEGIN
    -- 동일 탈락사유가 이미 존재할 때 에러 발생(UNIQUE)
    SELECT COUNT(*) INTO TEMP_NUM
    FROM DROP_RES
    WHERE REASON = V_REASON;
    
    IF (TEMP_NUM != 0)
        THEN RAISE REASON_ERROR;
    END IF;
    
    -- 탈락사유번호 생성(시퀀스 활용을 통해 자동 증가되게 설정)
    V_DRP_NO := ('DRP-' || TO_CHAR(SEQ_DROP_RES.NEXTVAL));
    
    -- INSERT 구문 작성
    INSERT INTO DROP_RES(REASON_NO, REASON)
    VALUES(V_DRP_NO, V_REASON);
    
    COMMIT;
    
    -- 예외 처리
    EXCEPTION 
        WHEN REASON_ERROR
            THEN RAISE_APPLICATION_ERROR(-20021, '이미 등록된 탈락사유입니다.'); 
            ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==> Procedure PRC_DRP_INSERT이(가) 컴파일되었습니다.


--------------------------------------------------------------------------------
--38. 중도탈락사유 삭제 프로시저 (확인)
CREATE OR REPLACE PROCEDURE PRC_DROPRES_DELETE
( V_REASON_NO       IN DROP_RES.REASON_NO%TYPE
)
IS
    TEMP_RNUM       NUMBER;     --탈락사유번호가 존재하는지 확인용 임시변수
    
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
            THEN RAISE_APPLICATION_ERROR(-20016, '입력한 탈락사유가 존재하지 않습니다.');
END;
--==> Procedure PRC_DROPRES_DELETE이(가) 컴파일되었습니다.


--------------------------------------------------------------------------------
--39. 수강신청 입력 프로시저(학생이 수강신청하는 프로시저) (확인)
CREATE OR REPLACE PROCEDURE PRC_REG_INSERT
( V_STU_ID      REGISTRATION.STU_ID%TYPE
, V_CUR_NO      REGISTRATION.CUR_NO%TYPE
)
IS
    V_REG_NO        DROP_RES.REASON_NO%TYPE;        -- 시퀀스 생성을 위한 변수
    TEMP_NUM        NUMBER;
    V_CUR_STARTDATE   CURRICULUM.CUR_STARTDATE%TYPE;    -- 수강신청일자를 받아오기 위한 변수
    
    REG_NO_ERROR    EXCEPTION;               -- 1. 동일 학생 아이디+과정번호가 이미 존재할 때 발생하는 에러
    DATE_ERROR      EXCEPTION;               -- 2. 수강신청일자가(SYSDATE) 과정시작일보다 미래일 때 발생하는 에러
BEGIN
    -- 1. 동일 학생 아이디+과정번호가 이미 존재할 때 에러 발생
    SELECT COUNT(*) INTO TEMP_NUM
    FROM REGISTRATION
    WHERE STU_ID = V_STU_ID AND CUR_NO = V_CUR_NO;
    
    IF (TEMP_NUM != 0)
        THEN RAISE REG_NO_ERROR;
    END IF;
    
    -- 2. 수강신청일자(SYSDATE) > 과정시작일 일 때 에러 발생
    SELECT CUR_STARTDATE INTO V_CUR_STARTDATE
    FROM CURRICULUM
    WHERE CUR_NO = V_CUR_NO;
    
    IF (SYSDATE > V_CUR_STARTDATE)
        THEN RAISE DATE_ERROR;
    END IF;
    
    -- 수강신청번호 생성(시퀀스 활용을 통해 자동 증가되게 설정)
    V_REG_NO := ('REG-' || TO_CHAR(SEQ_REGISTRATION.NEXTVAL));

    --INSERT 구문 작성
    INSERT INTO REGISTRATION(REG_NO, STU_ID, CUR_NO, REG_DATE)
    VALUES(V_REG_NO, V_STU_ID, V_CUR_NO, SYSDATE);
   
    COMMIT;
    
    -- 예외 처리
    EXCEPTION
        WHEN REG_NO_ERROR
            THEN RAISE_APPLICATION_ERROR(-20024, '이미 등록된 과정입니다.');
            ROLLBACK;
        WHEN DATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20036, '이미 시작된 과정입니다.');
            ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==> Procedure PRC_REG_INSERT이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------
--40. 수강신청 수정 프로시저(학생이 수강신청 수정하는 프로시저) (확인)
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
    --입력한 수강번호 존재여부 확인
    SELECT COUNT(*) INTO TEMP_RENUM
    FROM REGISTRATION
    WHERE REG_NO=V_REG_NO;
    
    IF (TEMP_RENUM=0)
        THEN RAISE REG_STU_ERROR;
    END IF;
    
    --해당 수강번호와 학생아이디 일치여부 확인
    SELECT STU_ID INTO TEMP_ID
    FROM REGISTRATION
    WHERE REG_NO=V_REG_NO;
    
    IF (TEMP_ID != V_STU_ID)
        THEN RAISE REG_STU_ERROR; 
    END IF;
    
    --입력한 과정번호 존재여부 확인
    SELECT COUNT(*) INTO TEMP_CNUM
    FROM CURRICULUM
    WHERE CUR_NO= V_CUR_NO;
    
    IF (TEMP_CNUM=0)
        THEN RAISE CUR_ERROR; 
    END IF;
    
    --이미 시작한 과정 제외
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
    
    
    --예외처리
    EXCEPTION
        WHEN REG_STU_ERROR
            THEN RAISE_APPLICATION_ERROR(-20010, '입력한 수강내역이 존재하지 않습니다.');
                 ROLLBACK;
        WHEN CUR_ERROR
            THEN RAISE_APPLICATION_ERROR(-20005, '입력한 과정번호가 존재하지 않습니다.');
                 ROLLBACK;
        WHEN CUR_DATE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20035, '이미 시작된 과정입니다');
                 ROLLBACK;
        WHEN OTHERS THEN ROLLBACK;

END;
--==> Procedure PRC_REG_UPDATE이(가) 컴파일되었습니다.

--------------------------------------------------------------------------------
--41. 수강신청 삭제 프로시저(학생이 수강 전 수강신청 철회하는 프로시저) (확인)
CREATE OR REPLACE PROCEDURE PRC_REG_DELETE
( V_REG_NO   IN REGISTRATION.REG_NO%TYPE
, V_STU_ID   IN STUDENT.STU_ID%TYPE
)
IS
   TEMP_RENUM   NUMBER;
   TEMP_ID      STUDENT.STU_ID%TYPE;
   
   REG_ERROR    EXCEPTION;
BEGIN
   --입력 수강번호가 존재하지 않는 경우
   SELECT COUNT(*) INTO TEMP_RENUM
   FROM REGISTRATION
   WHERE REG_NO=V_REG_NO;
   
   IF (TEMP_RENUM=0)
     THEN RAISE REG_ERROR;
   END IF;
   
   --수강번호와 학생ID가 일치하지 않는 경우
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


   --예외처리
   EXCEPTION
     WHEN REG_ERROR
        THEN RAISE_APPLICATION_ERROR(-20009, '입력한 수강신청 정보가 존재하지 않습니다.');
             ROLLBACK;
     WHEN OTHERS
        THEN ROLLBACK;
END;
--==>> Procedure PRC_REG_DELETE이(가) 컴파일되었습니다.
