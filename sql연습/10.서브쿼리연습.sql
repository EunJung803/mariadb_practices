--
-- subquery
--

--
-- 1) select 절, insert into t1 values(...)
--

-- 
-- 2) from 절의 서브쿼리
--
select now() as n, sysdate() as s, 3+1 as r from dual;

select n, s
from (
	select now() as n, sysdate() as s, 3+1 as r 
    from dual
    ) a;

-- 
-- 3) where 절의 서브쿼리
-- 

-- 예제 ) 현재, Fai Bale이 근무하는 부서에서 근무하는 다른 직원의 사번과 이름을 출력하세요.
select b.dept_no
from employees a, dept_emp b
where a.emp_no = b.emp_no
and b.to_date = '9999-01-01'
and concat(a.first_name, ' ', a.last_name) = 'Fai Bale';

-- 'd004'
select a.emp_no, a.first_name
from employees a, dept_emp b
where a.emp_no = b.emp_no
and b.to_date = '9999-01-01'
and b.dept_no = 'd004';

select a.emp_no, a.first_name
from employees a, dept_emp b
where a.emp_no = b.emp_no
and b.to_date = '9999-01-01'
and b.dept_no = (select b.dept_no
				from employees a, dept_emp b
				where a.emp_no = b.emp_no
				and b.to_date = '9999-01-01'
				and concat(a.first_name, ' ', a.last_name) = 'Fai Bale');

-- 3-1) 단일행 연산자 : =, >, <, >=, <=, <>, !
-- 실습문제 1
-- 현재, 전체 사원의 평균 연봉보다 적은 급여를 받는 사원의 이름과 급여를 출력하세요.
select a.first_name, b.salary
from employees a, salaries b
where a.emp_no = b.emp_no
and b.to_date = '9999-01-01'
and b.salary < (select avg(salary)
				from salaries
				where to_date = '9999-01-01')
order by b.salary desc;

-- 실습문제 2
-- 현재, 직책별 평균 급여 중에 가장 작은 직책의 직책과 그 평균 급여를 출력하세요.
-- 1. 직책별 평균 급여
select a.title, avg(salary)
from titles a, salaries b
where a.emp_no = b.emp_no
and a.to_date = '9999-01-01'
and b.to_date = '9999-01-01'
group by a.title;

-- 2. 직책별 가장 적은 평균 급여 : from 절 subquery
select min(avg_sal)
from (select a.title, avg(salary) as avg_sal
		from titles a, salaries b
		where a.emp_no = b.emp_no
		and a.to_date = '9999-01-01'
		and b.to_date = '9999-01-01'
		group by a.title) aa;

-- 3. sol1) where절 subquery
select a.title, avg(salary)
from titles a, salaries b
where a.emp_no = b.emp_no
and a.to_date = '9999-01-01'
and b.to_date = '9999-01-01'
group by a.title
having avg(salary) = ( select min(avg_sal)
						from ( select a.title as tt, avg(salary) as avg_sal
								from titles a, salaries b
								where a.emp_no = b.emp_no
								and a.to_date = '9999-01-01'
								and b.to_date = '9999-01-01'
								group by a.title) aa);

-- 3. sol2) top-k (limit)
select a.title, avg(salary) as avg_sal
from titles a, salaries b
where a.emp_no = b.emp_no
and a.to_date = '9999-01-01'
and b.to_date = '9999-01-01'
group by a.title
order by avg_sal asc limit 0, 1;

-- 3-2) 복수행 연산자 : in, not in, 비교연산자any, 비교연산자all

-- any 사용법
-- 1. =any : in
-- 2. >any, >=any : 최소값
-- 3. <any, <=any : 최대값
-- 4. <>any, !=any : not in

-- all 사용법
-- 1. =all : (x)
-- 2. >all, >=all : 최대값
-- 3. <all, <=all : 최소값
-- 4. <>all, !=all

-- 실습문제 3
-- 현재 급여가 50000 이상인 직원의 이름과 급여를 출력하세요.

-- sol1) join
select a.first_name, b.salary
from employees a, salaries b 
where a.emp_no = b.emp_no
and b.to_date = '9999-01-01'
and b.salary >= 50000
order by b.salary asc;

select a.first_name, b.salary
from employees a join salaries b on (a.emp_no = b.emp_no)
where b.to_date = '9999-01-01'
and b.salary >= 50000
order by b.salary asc;

-- sol2) subquery - where절 in연산자
select a.first_name, b.salary
from employees a, salaries b
where a.emp_no = b.emp_no
and b.to_date = '9999-01-01'
and (a.emp_no, b.salary) in (select emp_no, salary
							from salaries
							where to_date = '9999-01-01'
							and salary >= 50000)
order by b.salary asc;

-- sol3) subquery - where절 any연산자
select a.first_name, b.salary
from employees a, salaries b
where a.emp_no = b.emp_no
and b.to_date = '9999-01-01'
and (a.emp_no, b.salary) = any (select emp_no, salary
							from salaries
							where to_date = '9999-01-01'
							and salary >= 50000)
order by b.salary asc;

-- 실습문제 4
-- 현재, 각 부서별로 최고 급여를 받고 있는 직원의 이름과 급여를 출력하세요.

-- sol1) where절 subquery (in)
select c.dept_name, a.first_name, b.salary
from employees a, salaries b, departments c, dept_emp d
where a.emp_no = b.emp_no
and b.emp_no = d.emp_no
and c.dept_no = d.dept_no
and b.to_date = '9999-01-01'
and d.to_date = '9999-01-01'
and (d.dept_no, b.salary) in (select d.dept_no, max(b.salary)
								from salaries b, dept_emp d
								where b.emp_no = d.emp_no
								and b.to_date = '9999-01-01'
								and d.to_date = '9999-01-01'
                                group by d.dept_no);

-- sol2) from절 subquery & join
select c.dept_name, a.first_name, b.salary
from employees a, 
	 salaries b, 
     departments c, 
     dept_emp d, 
	 (select d.dept_no, max(b.salary) as max_sal
	 from salaries b, dept_emp d
	 where b.emp_no = d.emp_no
	 and b.to_date = '9999-01-01'
	 and d.to_date = '9999-01-01'
     group by d.dept_no) e
where a.emp_no = b.emp_no
and b.emp_no = d.emp_no
and c.dept_no = d.dept_no
and e.dept_no = d.dept_no
and b.to_date = '9999-01-01'
and d.to_date = '9999-01-01'
and b.salary = e.max_sal;
