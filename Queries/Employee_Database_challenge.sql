--The Number of Retiring Employees by Title
Select * from titles
Select * from employees
Select * from dept_employee

Select e.emp_no, e.first_name, e.last_name, t.title, t.from_date, t.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as t
ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no, t.to_date DESC


-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no, 
	first_name, 
	last_name, 
	title
INTO unique_titles
FROM retirement_titles
WHERE to_date = '9999-01-01'
ORDER BY emp_no, to_date DESC;

select * from unique_titles

Select COUNT (title), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
Order by COUNT DESC;

--Create a Mentorship Eligibility table that holds the employees who are
--eligible to participate in a mentorship program.
Select DISTINCT ON (e.emp_no) e.emp_no, 
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date
INTO mentorship_eligibility
FROM employees as e
INNER JOIN dept_employee as de
ON (e.emp_no = de.emp_no)
INNER JOIN titles as t
ON (e.emp_no = t.emp_no)
WHERE (de.to_date = '9999-01-01')
AND (e.birth_date between '1965-01-01' and '1965-12-31') 
ORDER BY e.emp_no, de.to_date DESC

Select * from mentorship_eligibility

--First we can create a member_eligibility_titles table
SELECT me.emp_no, 
me.first_name, 
me.last_name, 
me.birth_date, 
me.from_date, 
me.to_date, 
t.title 
INTO member_eligibility_titles 
FROM mentorship_eligibility as me 
JOIN titles as t 
ON (me.emp_no = t.emp_no);

--Then we can count the number of mentorship employees under each title
Select COUNT (title), title 
INTO mentorship_titles 
FROM member_eligibility_titles 
GROUP BY title 
Order by COUNT DESC;

--Then we can combine the member_eligibilty data and the mentorship titles 
--tables to see a summary. This tells uss the two titles with the most upcoming 
--vacancies, also has the least percent of mentors eligible.

Select rt.title as Title, 
rt.count as "Retiring Count", 
mt.count as "Mentorship Count", 
CAST (mt.count AS DECIMAL (5,2))/ (rt.count) *100
	AS "(%) Available Mentors"
INTO title_summary 
FROM retiring_titles as rt 
LEFT JOIN mentorship_titles as mt 
ON (rt.title = mt.title) 
GROUP BY rt.title, rt.count, mt.count 
ORDER by rt.count DESC;