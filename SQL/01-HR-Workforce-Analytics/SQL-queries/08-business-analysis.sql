

--Task_10 - final business summary
Q1.

SELECT * FROM general_Data;   -- Total employee = 4410

Q2.

SELECT G.department,
COUNT(*) AS total_employees
FROM general_Data AS G
GROUP BY G.department;        -- Human Resources 189
							  -- Research & Development 2883
							  -- Sales 1338

Q3.

SELECT G.department,
ROUND(AVG(monthly_income),2) AS average_income
FROM general_Data AS G
GROUP BY G.department;       -- Human Resources 57904.44
							 -- Research & Development 67187.96
							 -- Sales 61384.48

Q4.


WITH emp_with_JS AS(
SELECT G.employee_id, 
G.department,
ES.job_satisfaction
FROM general_data AS G
LEFT JOIN employee_survey_data AS ES
ON ES.employee_id = G.employee_id)

SELECT EJ.department,
ROUND(AVG(EJ.job_satisfaction),2) AS Average_Job_Satisfaction
FROM emp_with_JS AS EJ
GROUP BY EJ.department;             -- Human Resources 2.68
									-- Research & Development 2.71
									-- Sales 2.78


Q5.



WITH emp_with_PR AS(
SELECT G.employee_id,
G.department,
MS.performance_rating
FROM general_data AS G
LEFT JOIN manager_survey_data AS MS
ON MS.employee_id = G.employee_id)

SELECT EP.department,
ROUND(AVG(EP.performance_rating),2) AS average_performance_rating
FROM emp_with_PR AS EP
GROUP BY Ep.department;                -- Human Resources 3.14
										-- Research & Development 3.16
										-- Sales 3.14

