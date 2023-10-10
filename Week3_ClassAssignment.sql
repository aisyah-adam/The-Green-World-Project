-- Name: Nur Aisyah Bte Abdul Mutalib
-- Matric: U2110399H
-- Class Exercise 3

-- 1.	Show a list of all the tables in the database.
show tables;

-- 2.	Display the names (first name, last name) and gender of all employees.
select first_name, last_name, gender
from employees;

-- 3.	Find all distinct job titles.
select distinct(title)
from titles;

-- 4.	What is the total number of employees?
select count(*) as emp_amt
from employees;

-- 5.	How many salary records are there?
select count(*) as salary_amt
from salaries;

-- 6.	How many departments are there?
select count(*) as dep_amt
from departments;

-- 7.	What are the names of these departments?
select dept_name
from departments;

-- 8.	Display the names of all female employees.
select first_name, last_name
from employees
where gender = 'F';

-- 9.	How many male employees are there?
select count(*) as MaleAmt
from employees
where gender = 'M';

-- 10.	Display employee information for those who were hired before the year 1990.
select*
from employees
where hire_date < '1990-01-01';

-- 11.	Find male employees who were hired after 1995;
select*
from employees
where hire_date >= '1995-01-01'
and gender = 'M';

-- 12.	How many employees have their first names as either Adin, Deniz, Youssef and Roded?
select count(*) as emp_amt
from employees
where first_name in ('Adin', 'Deniz', 'Youssef', 'Roded');

-- 13.	How many employees are:

-- a. engineers?
select count(*) as amt
from titles
where title like '%Engineer%';

-- b. non-engineers?
select count(*) as amt
from titles
where title not like '%Engineer%';

-- 14.	How many employees were hired between 1990/01/01 and 1994/01/01.
select count(*) as amt
from employees
where hire_date between '1990-01-01' and '1994-01-01';

-- 15.	Find the list of unique last names of female employees (in alphabetical order), who were born before the year 1970, and hired after 1996. 
select distinct(last_name)
from employees
where gender = 'F'
and birth_date < '1970-01-01'
and hire_date >= '1996-01-01'
order by last_name asc;

-- 16.	For each gender, how many employees were hired before 1989;
select gender, count(*) as amt
from employees
where hire_date < '1989-01-01'
group by gender;

-- 17.	For each gender:

-- a.	how many employees are in each department?

select *
from employees, dept_emp
where employees.emp_no = dept_emp.emp_no
and dept_emp.dept_no = departments.dept_no
group by gender, dept_name;

-- b.	hired between the years of 1994-1996?

select gender, count(*)
from employees
where hire_date >= '1994-01-01'
and hire_date <= '1996-12-31'
group by gender;

-- 18.	List the names of all employees with department managers appointed starting from 1992/09/08 and ending at 1996/01/03.

select *
from dept_emp, employees
where dept_no = 
(
	select dept_no
	from dept_manager
	where from_date >= '1992-09-08'
	and to_date <= '1996-01-03'
) and
dept_emp.emp_no = employees.emp_no
and from_date >= '1992-09-08'
and to_date <= '1996-01-03';

-- 19.	List the names of employees and their respective job titles.

select *
from
(
	select employees.emp_no, max(to_date) as maxDate
	from titles, employees
	where titles.emp_no = employees.emp_no
	group by emp_no
) T1, titles
where titles.emp_no = T1.emp_no
and titles.to_date = t1.maxDate
and T1.emp_no = employees.emp_no;

-- 20.	Find the average amount of paid salary (i.e., all salary records) of every department.

select dept_no, avg(salary)
from salaries, 

-- 21.	Find the average paid salary (i.e., all salary records) of every department and the number of employees.

select dept_no, avg(salary), count(distinct(dept_emp.emp_no))
from salaries, dept_emp
where salaries.emp_no = dept_emp.emp_no
group by dept_no;

-- 22.	Number of employees in every department who have received more than $130000 in a salary transaction.

select *
from salaries, dept_emp
where salaries.emp_no = dept_emp.emp_no
and salary > 130000
group by dept_no;

