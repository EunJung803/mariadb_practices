-- 문제 1.
-- 현재 급여가 많은 직원부터 직원의 사번, 이름, 그리고 연봉을 출력 하시오.
select a.emp_no, a.first_name, b.salary
from employees a join salaries b on a.emp_no = b.emp_no
where b.to_date = '9999-01-01'
order by b.salary desc;

-- 문제2.
-- 전체 사원의 사번, 이름, 현재 직책을 이름 순서로 출력하세요.
select a.emp_no, a.first_name, b.title
from employees a join titles b on a.emp_no = b.emp_no
order by a.first_name;

-- 문제3.
-- 전체 사원의 사번, 이름, 현재 부서를 이름 순서로 출력하세요.
select a.emp_no, a.first_name, b.dept_name
from employees a, departments b, dept_emp c
where b.dept_no = c.dept_no
and a.emp_no = c.emp_no
order by a.first_name;

-- 문제4.
-- 현재 사원의 사번, 이름, 연봉, 직책, 부서를 모두 이름 순서로 출력합니다.
select a.emp_no, a.first_name, s.salary, b.title, c.dept_name
from employees a, titles b, departments c, dept_emp d, salaries s
where c.dept_no = d.dept_no
and a.emp_no = d.emp_no
and a.emp_no = b.emp_no
and a.emp_no = s.emp_no
and b.to_date = '9999-01-01'
and d.to_date = '9999-01-01'
order by a.first_name;


-- 문제5.
-- ‘Technique Leader’의 직책으로 과거에 근무한 적이 있는 모든 사원의 사번과 이름을 출력하세요. 
-- (현재 ‘Technique Leader’의 직책(으로 근무하는 사원은 고려하지 않습니다.) 
-- 이름은 first_name 출력 합니다.
select a.emp_no, a.first_name
from employees a, titles b
where a.emp_no = b.emp_no
and b.title = 'Technique Leader'
and b.to_date not like '9999%';

-- 문제6.
-- 직원 이름(last_name) 중에서 S로 시작하는 직원들의 이름, 부서명, 직책을 조회하세요.
select a.first_name, b.dept_name, c.title
from employees a, departments b, titles c, dept_emp d
where a.last_name like 'S%'
and b.dept_no = d.dept_no
and d.emp_no = a.emp_no
and d.emp_no = c.emp_no;

-- 문제7.
-- 현재, 직책이 Engineer인 사원 중에서 현재 급여가 40000 이상인 사원을 급여가 큰 순서대로 출력하세요.
-- 사번 이름 급여 타이틀
select c.emp_no, c.first_name, b.salary, a.title
from employees c, titles a, salaries b
where a.emp_no = b.emp_no
and c.emp_no = a.emp_no
and b.salary >= 40000
and b.to_date = '9999-01-01'
and a.to_date = '9999-01-01'
and a.title = 'Engineer'
order by b.salary desc;

-- 문제8.
-- 현재, 평균 급여가 50000이 넘는 직책을 직책, 평균 급여로 평균 급여가 큰 순서대로 출력하시오
select a.title, avg(b.salary)
from titles a join salaries b on a.emp_no = b.emp_no
where a.to_date = '9999-01-01'
and b.to_date = '9999-01-01'
group by a.title
having avg(b.salary) >= 50000
order by avg(b.salary) desc;

-- 문제9.
-- 현재, 부서별 평균 연봉을 연봉이 큰 부서 순서대로 출력하세요.
select b.dept_name, avg(a.salary)
from salaries a, departments b, dept_emp c
where b.dept_no = c.dept_no
and a.emp_no = c.emp_no
and a.to_date = '9999-01-01'
and c.to_date = '9999-01-01'
group by b.dept_name
order by avg(a.salary) desc;

-- 문제10.
-- 현재, 직책별 평균 연봉을 연봉이 큰 직책 순서대로 출력하세요.
select b.title, avg(a.salary)
from salaries a 
join titles b on a.emp_no = b.emp_no
where a.to_date = '9999-01-01'
and b.to_date = '9999-01-01'
group by b.title
order by avg(a.salary) desc;
