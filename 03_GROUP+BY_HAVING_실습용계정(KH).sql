/*
    * GROUP BY 절 : 그룹 기준을 제시할 수 있는 부분
*/
-- * 전체 직원의 급여 총 합 조회
SELECT SUM(SALARY) FROM EMPLOYEE;
-- * 부서별 급여 총 합 조회
SELECT DEPT_CODE, SUM(SALARY) FROM employee
GROUP BY DEPT_CODE;
-- * 부서별 직원 수 조회
SELECT DEPT_CODE, COUNT(*) FROM employee GROUP BY DEPT_CODE;
-- * 부서코드가 D6, D9, D1인 각 부서별 급여 총합, 직원 수 조회
SELECT DEPT_CODE, SUM(SALARY), COUNT(*) FROM EMPLOYEE
WHERE DEPT_CODE IN ('D6', 'D9', 'D1') GROUP BY DEPT_CODE;
-- * 직급 별 총 직원수, 보너스를 받은 직원수, 급여 총합, 평균 급여, 최저 급여, 최고 급여 조회 (직급코드 오름차순 정렬)
SELECT JOB_CODE, COUNT(*) "총 인원수", COUNT(BONUS) "보너스를 받는 직원수", 
SUM(SALARY) "급여 총합", FLOOR(AVG(SALARY))"평균 급여", MIN(SALARY) "최저급여", MAX(SALARY) "최고급여"
FROM EMPLOYEE GROUP BY JOB_CODE ORDER BY JOB_CODE;
-- * 부서 내 직급별로 직원 수, 급여 총합 조회
SELECT DEPT_CODE, JOB_CODE, COUNT(*) "직원 수", SUM(SALARY) "급여 총합"
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY DEPT_CODE, JOB_CODE;
/*
    * HAVING : 그룹에 대한 조건을 제시할 때 사용하는 부분
*/
-- 각 부서별 평균 급여가 300만원 이상인 부서만 조회
-- * 부서별 평균 급여 조회
SELECT DEPT_CODE, FLOOR(AVG(SALARY)) "평균 급여"
FROM EMPLOYEE GROUP BY dept_code;
SELECT DEPT_CODE, FLOOR(AVG(SALARY)) "평균 급여"
FROM EMPLOYEE GROUP BY dept_code HAVING FLOOR(AVG(SALARY)) >= 3000000;
-- => 전 직원을 부서별로 묶어서 평균 급여가 300만원 이상인 데이터를 츄려내서 조회
SELECT DEPT_CODE, FLOOR(AVG(SALARY)) "평균 급여"
FROM EMPLOYEE
WHERE SALARY >= 3000000 GROUP BY dept_code; -- 직원의 급여가 300만원 이상인 데이터만 추려내서 조회
-- 직급 별 급여 총합 조회 (급여 총합이 1000만원 이상인 직급만 조회)
SELECT JOB_CODE, SUM(SALARY) "급여 총합"
FROM EMPLOYEE GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000;
-- 보너스를 받는 직원이 없는 부서 정보 조회
SELECT DEPT_CODE 부서코드, COUNT(BONUS)
FROM EMPLOYEE GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0;

-- ** KH_연습문제 **
-- 1. EMPLOYEE테이블에서 사원 명과 직원의 주민번호를 이용하여 생년, 생월, 생일 조회
SELECT EMP_NAME 직원명, SUBSTR(EMP_NO, 1, 2) "생년", SUBSTR(EMP_NO, 3, 2) "생월", 
SUBSTR(EMP_NO, 5, 2) "생일" FROM EMPLOYEE;
-- 2. EMPLOYEE테이블에서 사원명, 주민번호 조회 (단, 주민번호는 생년월일만 보이게 하고, '-'다음 값은 '*'로 바꾸기)
SELECT EMP_NAME 직원명, SUBSTR(EMP_NO, 1, 7) || '*******' 주민등록번호 FROM EMPLOYEE;
SELECT EMP_NAME 직원명, RPAD(SUBSTR(EMP_NO, 1, 7), 14, '*') FROM employee;
-- 3. EMPLOYEE테이블에서 사원명, 입사일-오늘, 오늘-입사일 조회
--     (단, 각 별칭은 근무일수1, 근무일수2가 되도록 하고 모두 정수(내림), 양수가 되도록 처리)
SELECT EMP_NAME 직원명, ABS(FLOOR(HIRE_DATE - SYSDATE)) 근무일수1, ABS(FLOOR(SYSDATE - HIRE_DATE)) 근무일수2 FROM EMPLOYEE;
-- 4. EMPLOYEE테이블에서 사번이 홀수인 직원들의 정보 모두 조회
SELECT * FROM EMPLOYEE WHERE MOD(EMP_ID, 2) != 0;
-- 5. EMPLOYEE테이블에서 근무 년수가 20년 이상인 직원 정보 조회
SELECT * FROM EMPLOYEE WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) >= 20;
SELECT * FROM EMPLOYEE WHERE MONTHS_BETWEEN(SYSDATE, HIRE_DATE) >= 240;
-- 6. EMPLOYEE 테이블에서 사원명, 급여 조회 (단, 급여는 '\9,000,000' 형식으로 표시)
SELECT EMP_NAME 직원명, TO_CHAR(SALARY, 'L9,999,999') "급여" FROM EMPLOYEE;
-- 7. EMPLOYEE테이블에서 직원 명, 부서코드, 생년월일, 나이(만) 조회
--     (단, 생년월일은 주민번호에서 추출해서 00년 00월 00일로 출력되게 하며 
--          나이는 주민번호에서 출력해서 날짜데이터로 변환한 다음 계산)
SELECT EMP_NAME 직원명, DEPT_CODE 부서코드, CONCAT(SUBSTR(EMP_NO, 1, 2) || '년', 
SUBSTR(EMP_NO, 3, 2) || '월') || CONCAT(SUBSTR(EMP_NO, 5, 2), '일') "생년월일", 
EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1, 2), 'RR')) 나이 FROM EMPLOYEE;
-- 8. EMPLOYEE테이블에서 부서코드가 D5, D6, D9인 사원만 조회하되 D5면 총무부, D6면 기획부, D9면 영업부로 처리
--    (단, 부서코드 오름차순으로 정렬)
SELECT EMP_ID 사원번호, EMP_NAME 직원명, DEPT_CODE 부서코드,
DECODE(DEPT_CODE, 'D5', '총무부', 'D6', '기획부', 'D9', '영업부') "부서명"
FROM EMPLOYEE WHERE DEPT_CODE IN ('D5', 'D6', 'D9') ORDER BY DEPT_CODE;
-- 9. EMPLOYEE테이블에서 사번이 201번인 사원명, 주민번호 앞자리, 주민번호 뒷자리, 
--     주민번호 앞자리와 뒷자리의 합 조회
SELECT EMP_NAME 직원명, SUBSTR(EMP_NO, 1, 6) "주민번호 앞자리", SUBSTR(EMP_NO, 8, 7) "주민번호 뒷자리",
SUBSTR(EMP_NO, 1, 6) +  SUBSTR(EMP_NO, 8, 7) "주민번호 합" FROM EMPLOYEE WHERE EMP_ID = '201';
-- 10. EMPLOYEE테이블에서 부서코드가 D5인 직원의 보너스 포함 연봉 합 조회
SELECT SUM((SALARY + (SALARY*NVL(BONUS, 0)))*12) "D5부서 연봉 합" FROM EMPLOYEE WHERE DEPT_CODE = 'D5';
-- 11. EMPLOYEE테이블에서 직원들의 입사일로부터 년도만 가지고 각 년도별 입사 인원수 조회
--      |  전체 직원 수 | 2001년 | 2002년 | 2003년 | 2004년  |
SELECT COUNT(*) "전체 직원 수",
COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), 2001, 1)) "2001년",
COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), 2002, 1)) "2002년",
COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), 2003, 1)) "2003년",
COUNT(DECODE(EXTRACT(YEAR FROM HIRE_DATE), 2004, 1)) "2004년"
FROM EMPLOYEE;
/*
    * ROLLUP, CUBE : 그룹 별 산출 결과 값의 집계 계산 함수
    - ROLLUP : 전달 받은 그룹 중 가장 먼저 지정한 그룹 별로 추가적 집계 반환
    - CUBE   : 전달 받은 그룹들로 가능한 모든 조합 별로 집계 반환
*/
-- * 각 부서 내 직급 별 급여 합, 부서 별 급여 합, 전체 직원 급여 총합 조회
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY) "급여 총합" FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY 1;
-- * 부서별 급여 합, 직급별 급여 합, 부서 내 직급 별 급여 합, 전체 직원 급여 총합 조회
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY) "급여 총합"
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1;

SELECT DEPT_CODE, JOB_CODE, SUM(SALARY) "급여 총합",
        CASE
            WHEN GROUPING(DEPT_CODE) = 0 AND GROUPING(JOB_CODE) = 1 THEN '부서별 합계'
            WHEN GROUPING(DEPT_CODE) = 1 AND GROUPING(JOB_CODE) = 0 THEN '직급별 합계'
            WHEN GROUPING(DEPT_CODE) = 1 AND GROUPING(JOB_CODE) = 1 THEN '총 합계'
            ELSE '그룹별 합계'
        END "구분"
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1;
/*
    * 집합 연산자 : 여러 개의 SQL문을 하나의 SQL문으로 만들어주는 연산자
    - UNION     : 합집합 (두 SQL문의 결과를 더해줌) --> OR와 유사
    - INTERSECT : 교집합 (두 SQL문을 수행한 결과의 중복되는 부분을 추출해줌) --> AND와 유사
    - UNION ALL : 합집합 + 교집합 (중복되는 데이터는 두 번 조회될 수 있음)
    - MINUS     : 차집합 (선행 결과에서 후행 결과를 뺀 나머지)
*/
-- * UNION *
-- 부서코드가 D5인 사원 또는 급여가 300만원 초과인 사원들의 정보 조회(직원번호, 이름, 부서코드, 급여)
SELECT EMP_ID 사원번호, EMP_NAME 직원명, DEPT_CODE 부서코드, SALARY 급여 FROM EMPLOYEE
WHERE DEPT_CODE = '05' OR SALARY >= 3000000;

SELECT EMP_ID 사원번호, EMP_NAME 직원명, DEPT_CODE 부서코드, SALARY 급여 FROM EMPLOYEE
WHERE DEPT_CODE = '05'
UNION
SELECT EMP_ID 사원번호, EMP_NAME 직원명, DEPT_CODE 부서코드, SALARY 급여 FROM EMPLOYEE
WHERE SALARY > 3000000;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION ALL
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- * INTERSECT *
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY > 3000000;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
INTERSECT
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- * MINUS *
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'     -- 6
MINUS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;
/*
    * 집합 연산자 사용 시 주의 사항 *
    [1] SQL문들의 컬럼 개수가 동일해야 함
    [2] 컬럼 자리마다 동일한 타입으로 작성해줘야 함
    [3] 정렬하고자 한다면 ORDER BY절은 "마지막"에 작성해야 함
*/
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'     -- 6
-- ORDER BY EMP_ID -- 오류발생!
MINUS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000
ORDER BY EMP_ID;