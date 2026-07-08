/*
    * JOIN : 여러 개의 테이블을 연결(결합)하여 하나의 가상 테이블처럼 조회하는 구문
*/
-- * 직원 정보 조회 (직원번호, 이름, 부서코드)
SELECT EMP_ID, EMP_NAME, DEPT_CODE FROM employee;
-- * 부서 정보 조회
SELECT DEPT_ID, DEPT_TITLE FROM DEPARTMENT;
-- * 직원 정보 조회 (직원번호, 이름, 부서명)
SELECT EMP_ID 사원번호, EMP_NAME 직원명, DEPT_TITLE 부서명
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;
--> EMPLOYEE 테이블에서 부서코드(DEPT_CODE)가 NULL인 직원은 결과에서 제외됨!
--> DEPARTMENT 테이블에서 D3, D4, D7 부서코드에 해당하는 직원이 EMPLOYEE 테이블에 존재하지 않아 결과에서 제외됨!

-- * 직원 번호, 이름, 직급명 조회
SELECT EMP_ID 사원번호, EMP_NAME 직원명, JOB_NAME 직급명
FROM EMPLOYEE A, JOB B
WHERE A.JOB_CODE = B.JOB_CODE;
-- * ANSI 구문 *
/*
    * FROM 절에 기준이 되는 테이블을 작성
    * JOIN 절에 연결하고자 하는 테이블을 작성 + 조인 조건을 작성
        - USING : 컬럼명이 동일한 경우
        - ON    : 컬럼명이 동일하거나 다른 경우
*/
-- * 직원번호, 이름, 부서명 조회
SELECT EMP_ID 사원번호, EMP_NAME 직원명, DEPT_TITLE 부서명
FROM EMPLOYEE JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
-- * 직원번호, 이름, 직급명 조회
SELECT EMP_ID 사원번호, EMP_NAME 직원명, JOB_NAME 직급명
FROM EMPLOYEE JOIN JOB USING (JOB_CODE);
/*
    * 포괄 조인 / 외부 조인 (OUTER JOIN)
    : 두 테이블을 조인할 때, 조인 조건에 맞지 않는 행도 결과에 포함하는 구문
    - LEFT OUTER JOIN : 두 테이블 중 왼쪽에 작성된 테이블을 기준으로 조인
                        (왼쪽 테이블의 모든 행 + 조건에 맞는 오른쪽 테이블 행)
    - RIGHT OUTER JOIN : 두 테이블 중 오른쪽에 작성된 테이블을 기준으로 조인
                        (오른쪽 테이블의 모든 행 + 조건에 맞는 왼쪽 테이블 행)
    - FULL OUTER JOIN : 두 테이블이 가진 모든 행을 조회하는 구문(오라클 전용 구문 X)
*/
-- ** LEFT OUTER JOIN ** --
-- 오라클 구문 --
-- => 추가로 연결되는 테이블에 해당하는 컬럼 옆에 (+) 기호를 붙여 표현
-- * 이름, 부서명, 급여 정보 조회 (모든 직원 정보를 조회)
SELECT EMP_NAME 직원명, DEPT_TITLE 부서명, SALARY 급여 
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);
-- ANSI 구문 --
SELECT EMP_NAME 직원명, DEPT_TITLE 부서명, SALARY 급여 
FROM EMPLOYEE LEFT JOIN DEPARTMENT
ON DEPT_CODE = DEPT_ID;
-- ** RIGHT OUTER JOIN ** --
SELECT EMP_NAME 직원명, DEPT_TITLE 부서명, SALARY 급여 
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID;
-- ANSI 구문 --
SELECT EMP_NAME 직원명, DEPT_TITLE 부서명, SALARY 급여 
FROM EMPLOYEE RIGHT JOIN DEPARTMENT
ON DEPT_CODE = DEPT_ID;
-- ** FULL OUTER JOIN ** --
-- ANSI 구문 --
SELECT EMP_NAME 직원명, DEPT_TITLE 부서명, SALARY 급여 
FROM EMPLOYEE FULL OUTER JOIN DEPARTMENT
ON DEPT_CODE = DEPT_ID;
/*
    * 비등가 조인 (NON EQUAL JOIN)
    : 조인 조건에 '=' 대신 >, <, BRTWEEN, LIKE 등의 비교 연산자를 사용하여 매칭하는 조인
      (주로 범위 조건으로 매칭할 때 사용)
    * ANSI 구문에서는 JOIN ON만 사용 가능!
*/
-- 직원에 대한 급여 등급 조회 (이름, 급여, 등급)
-- 오라클 구문 --
SELECT EMP_NAME 직원명, SALARY 급여, SAL_LEVEL 
FROM EMPLOYEE, SAL_GRADE 
-- WHERE SALARY >= MIN_SAL AND SALARY <= MAX_SAL;
WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL;
-- ANSI 구문--
SELECT EMP_NAME 직원명, SALARY 급여, SAL_LEVEL 
FROM EMPLOYEE JOIN SAL_GRADE ON SALARY >= MIN_SAL AND SALARY <= MAX_SAL;
/*
    * 자체 조인 / 셀프 조인
      : 하나의 테이블을 마치 서로 다른 테이블처럼 별칭을 주어 조인하는 구문
        테이블 내에 자기 자신과 관계가 있는 데이터를 조회할 때 사용
*/
-- * 전체 직원의 직원번호, 이름, 부서코드
--                  사수직원번호, 사수명, 사수 부서코드 조회

-- * 직원 정보 => EMPLOYEE / 사수 직원 정보 => EMPLOYEE
-- ** 오라클 구문 **
SELECT E.EMP_ID "직원번호", E.EMP_NAME "직원명", E.DEPT_CODE "직원 부서코드"
            , M.EMP_ID "사수 직원번호", M.EMP_NAME "사수명", M.DEPT_CODE "사수 부서코드"
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MANAGER_ID = M.EMP_ID;

-- ** ANSI 구문 **
SELECT E.EMP_ID "직원번호", E.EMP_NAME "직원명", E.DEPT_CODE "직원 부서코드"
            , M.EMP_ID "사수 직원번호", M.EMP_NAME "사수명", M.DEPT_CODE "사수 부서코드"
FROM EMPLOYEE E
    JOIN EMPLOYEE M ON E.MANAGER_ID = M.EMP_ID;

-- * 사수가 없는 직원도 조회 (결과 행: 23)
SELECT E.EMP_ID "직원번호", E.EMP_NAME "직원명", E.DEPT_CODE "직원 부서코드"
            , M.EMP_ID "사수 직원번호", M.EMP_NAME "사수명", M.DEPT_CODE "사수 부서코드"
FROM EMPLOYEE E
    LEFT JOIN EMPLOYEE M ON E.MANAGER_ID = M.EMP_ID;

SELECT E.EMP_ID "직원번호", E.EMP_NAME "직원명", E.DEPT_CODE "직원 부서코드"
            , M.EMP_ID "사수 직원번호", M.EMP_NAME "사수명", M.DEPT_CODE "사수 부서코드"
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MANAGER_ID = M.EMP_ID(+);
/*
    * 다중 조인 : 2개 이상의 테이블을 조인하는 것
*/
-- * 직원번호, 직원명, 부서명, 직급명 조회
-- 오라클 구문
SELECT EMP_ID 사원번호, EMP_NAME 직원명, DEPT_TITLE 부서명, JOB_NAME 직급명
FROM EMPLOYEE E, DEPARTMENT M, JOB J
WHERE DEPT_CODE = DEPT_ID AND E.JOB_CODE = J.JOB_CODE
ORDER BY EMP_ID;
-- ANSI 구문
SELECT EMP_ID 사원번호, EMP_NAME 직원명, DEPT_TITLE 부서명, JOB_NAME 직급명
FROM EMPLOYEE E 
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID 
-- JOIN JOB J ON E.JOB_CODE = J.JOB_CODE 
JOIN JOB J USING (JOB_CODE) 
ORDER BY EMP_ID;
-- * 직원번호, 직원명, 부서명, 지역명 조회
-- 오라클 구문
SELECT EMP_ID 사원번호, EMP_NAME 직원명, DEPT_TITLE 부서명, LOCAL_NAME 지역명
FROM EMPLOYEE, DEPARTMENT, LOCATION
WHERE DEPT_CODE = DEPT_ID AND LOCATION_ID = LOCAL_CODE;
-- ANSI 구문
SELECT EMP_ID 사원번호, EMP_NAME 직원명, DEPT_TITLE 부서명, LOCAL_NAME 지역명
FROM DEPARTMENT JOIN EMPLOYEE ON DEPT_ID = DEPT_CODE
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE;
