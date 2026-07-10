-- * KH_연습 문제 *
-- * 연습용 계정 생성 후 아래 문제를 풀어봅시다 *
-- * 계정 정보 : C##TEST / TEST *
-- * 테이블이 존재하지 않을 경우, [연습 문제 6]을 참고하여 생성해 주세요. *
-- 1. TB_DEPT 테이블에 아래 3개의 부서 데이터를 삽입하는 SQL을 작성하세요.
--    10번: '인사팀'
--    20번: '개발팀'
--    30번: '디자인팀'
INSERT INTO TB_DEPT (DEPT_CD, DEPT_NAME) VALUES (10, '인사팀');
INSERT INTO TB_DEPT (DEPT_CD, DEPT_NAME) VALUES (20, '개발팀');
INSERT INTO TB_DEPT (DEPT_CD, DEPT_NAME) VALUES (30, '디자인팀');
-- 2. TB_EMP 테이블에 아래의 사원 정보를 삽입하는 SQL을 작성하세요.
--    사원번호: 1001, 이름: '홍길동', 성별: (기본값 설정 적용), 부서코드: 10, 연락처: '010-1111-2222'
--    사원번호: 1002, 이름: '김철수', 성별: 'M', 부서코드: 20, 연락처: '010-3333-4444'
--    사원번호: 1003, 이름: '이영희', 성별: 'F', 부서코드: 20, 연락처: '010-5555-6666'
INSERT INTO TB_EMP VALUES (1001, '홍길동', NULL, 10, '010-1111-2222');
INSERT INTO TB_EMP VALUES (1002, '김철수', 'M', 20, '010-3333-4444');
INSERT INTO TB_EMP VALUES (1003, '이영희', 'F', 20, '010-5555-6666');
-- 3. 아래의 SQL을 실행했을 때 에러가 발생하는 원인을 제약조건과 연결 지어 설명하고, 정상적으로 삽입되도록 SQL을 수정하세요.
--    INSERT INTO TB_EMP (EMP_NO, EMP_NAME, GENDER, DEPT_CD, CONTACT)
--    VALUES (1004, '박민수', 'X', 40, '010-1111-2222');
-- CHECK 'M', 'F' / DEPT_CD 외래키로 TB_DEPT의 DEPT_CD에 있는 값만 넣을 수 있음 / CONTACT의 UNIQUE로 인한 중복방지
INSERT INTO TB_EMP (EMP_NO, EMP_NAME, GENDER, DEPT_CD, CONTACT)
VALUES (1004, '박민수', NULL, 30, '010-1111-2221');
-- 4. '개발팀'의 부서코드(DEPT_CD)가 20번에서 50번으로 변경되어야 합니다. 아래 작업 항목에 따라 SQL문을 작성하세요.
--    * TB_DEPT 테이블에서 개발팀의 부서코드를 50으로 변경하는 SQL을 작성하세요.
--    * 부서코드가 변경됨에 따라 TB_EMP 테이블에서 개발팀(기존 20번) 소속이었던
--    * 사원들의 부서코드도 50으로 일괄 변경하는 SQL을 작성하세요.
-- * 간단한 방법 *
INSERT INTO TB_DEPT VALUES (50, '개발팀');
UPDATE TB_EMP SET DEPT_CD = 50 WHERE DEPT_CD = 20;
DELETE FROM TB_DEPT WHERE DEPT_CD = 20;
SELECT * FROM TB_DEPT;
-- * 복잡한 방법 *  --> 만약 TB_DEPT 테이블의 DEPT_NAME 컬럼에 UNIQUE가 설정되어 있다면?
ALTER TABLE TB_DEPT ADD CONSTRAINT UQ_TD UNIQUE(DEPT_NAME);
-- * 테이블 복제 --> 구조 + NOT NULL 제약 조건만 복제 (다른 제약조건은 복제되지 않음!)
-- * 해당 직원 데이터를 백업(복제) --> 부서코드가 20번 직원
SELECT * FROM TB_EMP WHERE DEPT_CD = 20;
CREATE TABLE TB_EMP_20 AS (SELECT * FROM TB_EMP WHERE DEPT_CD = 20);
-- * 해당 직원 데이터를 삭제
DELETE FROM TB_EMP WHERE DEPT_CD = 20;
UPDATE TB_DEPT SET DEPT_CD = 50 WHERE DEPT_CD = 20;
SELECT * FROM TB_EMP;
-- * 백업해둔 직원 정보 복원(추가)
UPDATE TB_EMP_20 SET DEPT_CD = 50 WHERE DEPT_CD = 20;
-- 직원 정보 복원
INSERT INTO TB_EMP (EMP_NO, EMP_NAME, GENDER, DEPT_CD, CONTACT) (SELECT * FROM TB_EMP_20)
-- 5. TB_DEPT 테이블에서 10번 부서('인사팀')를 삭제하려고 합니다. 
--    하지만 현재 10번 부서에는 '홍길동' 사원이 소속되어 있어 외래키 무결성 에러가 발생합니다.
--    에러를 내지 않고 10번 부서를 안전하게 삭제하기 위한 SQL을 작성하세요.
