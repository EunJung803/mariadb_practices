-- 문제1.
-- 현재 평균 연봉보다 많은 월급을 받는 직원은 몇 명이나 있습니까?
select count(*)
from salaries a, employees b
where a.emp_no = b.emp_no
and a.to_date = '9999-01-01'
and a.salary >= (select avg(salary)
				from salaries
				where to_date = '9999-01-01');

-- 문제2.
-- 현재, 각 부서별로 최고의 급여를 받는 사원의 사번, 이름, 부서, 연봉을 조회하세요. 단 조회결과는 연봉의 내림차순으로 정렬되어 나타나야 합니다.
select d.emp_no, d.first_name, c.dept_name, a.salary
from salaries a, dept_emp b, departments c, employees d
where a.emp_no = b.emp_no
and a.emp_no = d.emp_no
and b.dept_no = c.dept_no
and a.to_date = '9999-01-01'
and b.to_date = '9999-01-01'
and (a.salary, b.dept_no) in (select max(a.salary), b.dept_no
							from salaries a, dept_emp b, departments c
							where a.emp_no = b.emp_no
							and b.dept_no = c.dept_no
							and a.to_date = '9999-01-01'
							and b.to_date = '9999-01-01'
							group by b.dept_no)
group by c.dept_name
order by a.salary desc;                             


-- 문제3.
-- 현재, 자신의 부서 평균 급여보다 연봉(salary)이 많은 사원의 사번, 이름과 연봉을 조회하세요
select d.emp_no, d.first_name, a.salary
from salaries a, dept_emp b, departments c, employees d,
	(select avg(a.salary) as avg_salary, b.dept_no
	from salaries a, dept_emp b, departments c
	where a.emp_no = b.emp_no
	and b.dept_no = c.dept_no
	and a.to_date = '9999-01-01'
	and b.to_date = '9999-01-01'
	group by c.dept_name) e
where a.emp_no = b.emp_no
and a.emp_no = d.emp_no
and b.dept_no = c.dept_no
and a.to_date = '9999-01-01'
and b.to_date = '9999-01-01'
and a.salary >= e.avg_salary
and b.dept_no = e.dept_no
order by a.salary;

-- 문제4.
-- 현재, 사원들의 사번, 이름, 매니저 이름, 부서 이름으로 출력해 보세요.
select a.emp_no, a.first_name as emp_name, m.first_name as manager_name, b.dept_name
from employees a, departments b, dept_emp c,
	(select a.first_name, c.dept_name
	from employees a, dept_manager b, departments c
	where a.emp_no = b.emp_no
	and b.dept_no = c.dept_no
	and b.to_date = '9999-01-01') m
where c.emp_no = a.emp_no
and b.dept_no = c.dept_no
and b.dept_name = m.dept_name
and c.to_date = '9999-01-01'
order by a.emp_no;

-- 문제5.
-- 현재, 평균연봉이 가장 높은 부서의 사원들의 사번, 이름, 직책, 연봉을 조회하고 연봉 순으로 출력하세요.
select a.emp_no, a.first_name, b.title, c.salary
from employees a, titles b, salaries c, dept_emp d
where a.emp_no = b.emp_no
and a.emp_no = c.emp_no
and a.emp_no = d.emp_no
and b.to_date = '9999-01-01'
and c.to_date = '9999-01-01'
and d.to_date = '9999-01-01'
and d.dept_no = (select b.dept_no
				from salaries a, dept_emp b
				where a.emp_no = b.emp_no
				and a.to_date = '9999-01-01'
				and b.to_date = '9999-01-01'
				group by b.dept_no
				order by avg(a.salary) desc limit 0, 1)
order by c.salary desc, a.emp_no;

-- 문제6.
-- 평균 연봉이 가장 높은 부서는?
select c.dept_name, avg(a.salary)
from salaries a, dept_emp b, departments c
where a.emp_no = b.emp_no
and b.dept_no = c.dept_no
and a.to_date = '9999-01-01'
and b.to_date = '9999-01-01'
group by b.dept_no
order by avg(a.salary) desc limit 0, 1;

-- 문제7.
-- 평균 연봉이 가장 높은 직책?
select b.title, avg(a.salary)
from salaries a, titles b
where a.emp_no = b.emp_no
and a.to_date = '9999-01-01'
and b.to_date = '9999-01-01'
group by b.title
order by avg(a.salary) desc limit 0, 1;


-- 문제8.
-- 현재 자신의 매니저보다 높은 연봉을 받고 있는 직원은?
-- 부서이름, 사원이름, 연봉, 매니저 이름, 메니저 연봉 순으로 출력합니다.
select c.dept_name, a.first_name as emp_name, d.salary, m.first_name as manager_name, m.salary
from employees a, dept_manager b, departments c, salaries d, dept_emp e,
	(select a.first_name, c.dept_name, d.salary
	from employees a, dept_manager b, departments c, salaries d
	where a.emp_no = b.emp_no
    and d.emp_no = a.emp_no
	and b.dept_no = c.dept_no
	and b.to_date = '9999-01-01'
	and d.to_date = '9999-01-01') m
where d.salary > m.salary
and a.emp_no = d.emp_no
and a.emp_no = e.emp_no
and e.dept_no = c.dept_no
and c.dept_name = m.dept_name
and d.to_date = '9999-01-01'
and e.to_date = '9999-01-01';