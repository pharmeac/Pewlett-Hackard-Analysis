# Pewlett-Hackard-Analysis

## Overview
The purpose of this analysis was to determine the number of retiring employees per title, and identify employees who are eligible to participate in a mentorship program. A large number of employees will be retiring in the next few years at Pewlett Hackard. They would like create a program where seasoned  employees mentor newly hired employees.

## Results
 - We estimated there were 41,380 (13.8%) employees retiring out of 300,024 total employees, when we included a hire date filter. However, when we removed    that filer we revealed that there are potentially 72,458 (24.2%) employees of retirement age. This is nearly a quarter of their workforce!
 - The two titles with the most retiring employees are Senior Engineer and Senior Staff. These 2 titles account for over 50,000 of the employees retiring.
 - Only 2 managers are of retirement age.
 ![image](https://user-images.githubusercontent.com/109913335/194723918-b6165730-4bad-4f6b-ba15-76da0e659ca7.png)
 
 - There are 1,549 employees who are eligible for the mentorship program.

## Summary
Provide high-level responses to the following questions, then provide two additional queries or tables that may provide more insight into the upcoming "silver tsunami."
 - A total of 72,458 roles will need to be filled as the "silver tsunami" begins to make an impact.
 - It is unlikely that that will be enough retirement-ready employees in all departments to mentor the next generation of Pewlett Hackard employees.
 - Additional analysis of the titles and count of employees under each title of those that qualify for the mentorship program.
 
 1) First we can create a member_eligibility_titles table
 
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

2) Then we can count the number of mentorship employees under each title

Select COUNT (title), title
INTO mentorship_titles
FROM member_eligibility_titles
GROUP BY title
Order by COUNT DESC;

![image](https://user-images.githubusercontent.com/109913335/194727438-dbea5450-1368-439b-b437-399a0a7d691d.png)

3) Then we can combine the member_eligibilty data and the mentorship titles tables to see a summary. This tells uss the two titles with the most upcoming vacancies, also has the least percent of mentors eligible.

Select rt.title as Title, 
	rt.count as "Retiring Count",
	mt.count as "Mentorship Count",
	--mt.count/rt.count as "(%)Available Mentors"
	CAST (mt.count AS DECIMAL (5,2))/ rt.count *100 AS "(%) Available Mentors"
--INTO title_summary
FROM retiring_titles as rt
LEFT JOIN mentorship_titles as mt
ON (rt.title = mt.title)
GROUP BY rt.title, rt.count, mt.count
ORDER by rt.count DESC;

![image](https://user-images.githubusercontent.com/109913335/194727980-9ab5118e-2799-4670-977e-1146d7e8e86f.png)
