--List the following details of each employee: employee number, last name, first name, sex, and salary.

SELECT 
	employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salaries
FROM employees
INNER JOIN salaries ON employees.emp_no = salaries.emp_no;

--List first name, last name, and hire date for employees who were hired in 1986.

SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date LIKE '%1986'

--List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name.

SELECT employees.emp_no, employees.last_name, employees.first_name, dept_manager.dept_no
FROM employees
JOIN dept_manager
ON (employees.emp_no = dept_manager.emp_no)
WHERE dept_no IN 
	(SELECT dept_no
	FROM dept_manager);
	
CREATE VIEW manager AS
SELECT employees.emp_no, employees.last_name, employees.first_name, dept_manager.dept_no
FROM employees
JOIN dept_manager
ON (employees.emp_no = dept_manager.emp_no)
WHERE dept_no IN 
	(SELECT dept_no
	FROM dept_manager);

SELECT * FROM manager

SELECT m.emp_no, m.last_name, m.first_name, m.dept_no, d.dept_name
FROM manager as m
JOIN departments as d
ON (d.dept_no = m.dept_no)


--List the department of each employee with the following information: employee number, last name, first name, and department name.

SELECT e.emp_no, e.last_name, e.first_name, de.dept_no
FROM employees as e
JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE e.emp_no IN 
	(SELECT emp_no 
	FROM dept_emp);
	
CREATE VIEW employee_info AS 
SELECT e.emp_no, e.first_name, e.last_name, de.dept_no
FROM employees as e
JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE e.emp_no IN 
	(SELECT emp_no 
	FROM dept_emp);
	
SELECT * FROM employee_info

SELECT em.emp_no, em.last_name, em.first_name, d.dept_name 
FROM employee_info as em
JOIN departments as d
ON (em.dept_no = d.dept_no);


--List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."

SELECT first_name, last_name, sex
FROM employees
WHERE emp_no IN

	(SELECT emp_no 
	FROM employees
	WHERE first_name = 'Hercules'
	AND last_name LIKE 'B%');

--List all employees in the Sales department, including their employee number, last name, first name, and department name.

CREATE VIEW table_emp AS
SELECT em.emp_no, em.last_name, em.first_name, d.dept_name 
FROM employee_info as em
JOIN departments as d
ON (em.dept_no = d.dept_no);

SELECT * from table_emp

SELECT *
FROM table_emp
WHERE dept_name = 'Sales'

--List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.

SELECT *
FROM table_emp
WHERE dept_name = 'Sales'
OR dept_name = 'Development'

--In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT last_name,
COUNT (last_name) AS last_name_count
FROM employees
GROUP BY last_name
ORDER BY last_name_count DESC

--BONUS: Average salary by title
--Merged data from employees table and salaries table, created view 

SELECT e.emp_no, e.emp_title, s.salaries
FROM employees as e
JOIN salaries as s
ON (e.emp_no = s.emp_no)

CREATE VIEW average_salary AS 
SELECT e.emp_no, e.emp_title, s.salaries
FROM employees as e
JOIN salaries as s
ON (e.emp_no = s.emp_no)


CREATE VIEW name_title AS 
SELECT emp_title,
	ROUND(AVG(salaries),2) as avg_salary
FROM average_salary
GROUP BY emp_title;



CREATE VIEW staff_avg_salary AS
SELECT t.staff, nt.emp_title, nt.avg_salary
FROM name_title AS nt
JOIN titles as t
ON (nt.emp_title=t.title_id)