-- * CREATE SESSION 권한 부여 후 접속 성공!
-- * 테이블 생성 * __
/*
    테이블명: TEST
    컬럼: TEST_ID (숫자), TEST_NAME (가변문자 10)
*/
CREATE TABLE TEST (
    TEST_ID NUMBER,
    TEST_NAME VARCHAR2(10)
);
--> 관리자 계정으로부터 CREATE TABLE 권한을 부여 받은 후 테이블 생성 성공!
INSERT INTO TEST VALUES (1, 'UI');
SELECT * FROM TEST;