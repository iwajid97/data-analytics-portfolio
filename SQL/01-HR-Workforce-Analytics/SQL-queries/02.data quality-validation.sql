
-- 01.Data quality - validation

-- Logical consistency (Years of experience/ Total years of experience/ current role experience)

--Task_1 find the employees who has inconsistency among G.total_working_years < G.years_at_company;

SELECT G.employee_id,
G.total_working_years,
G.years_at_company
FROM general_Data AS G
WHERE G.total_working_years < G.years_at_company;


--Task_2 find the employees who has inconsistency among G.years_since_last_promotion > G.total_working_years;

SELECT G.employee_id,
G.total_working_years,
G.years_since_last_promotion
FROM general_Data AS G
WHERE G.years_since_last_promotion > G.total_working_years;


--Task_3 find the employees who has inconsistency among G.years_since_last_promotion > G.years_at_company;


SELECT G.employee_id,
G.years_at_company,
G.years_since_last_promotion,
G.years_with_curr_manager
FROM general_data AS G
WHERE G.years_since_last_promotion > G.years_at_company;



--Task_4 find the employees who has inconsistency among G.years_with_curr_manager > G.years_at_company;


SELECT G.employee_id,
G.years_at_company,
G.years_with_curr_manager
FROM general_data AS G
WHERE G.years_with_curr_manager > G.years_at_company;



--Task 5 finding the employees with inconsistency their age and years of experience

SELECT G.employee_id,
G.age,
G.total_working_years
FROM general_data AS G
WHERE G.total_working_years > (age - 18);




--Lesson 2. Duplicate Detection

--Task-6 --Identify the employee ID duplication

SELECT G.employee_id,
COUNT(*) 
FROM General_data AS G
GROUP BY G.employee_id
HAVING COUNT(*) > 1;


--Task-7 Potential Duplication detection

SELECT (G.age,G.gender,
G.department,G.job_role,
G.marital_status,G.education_field) AS one_column,
COUNT(*)
FROM general_data AS G
GROUP BY (G.age,G.gender,
G.department,G.job_role,
G.marital_status,G.education_field)
HAVING COUNT(*) > 1;


--Task 8 Outliners detection (Exploratory Analysis) 

--company level exploration

SELECT 
MIN(G.monthly_income) AS lowest_salary,
MAX(G.monthly_income) AS highest_salary,
AVG(G.monthly_income) AS average_salary 
FROM general_data AS G


SELECT job_role , AVG(monthly_income)
FROM general_data
GROUP BY job_role
HAVING job_role = 'Research Scientist';



--- IQR - Interquartile Range

--Outlier Investigation

SELECT 
PERCENTILE_CONT(0.25)
		WITHIN GROUP (ORDER BY monthly_income) AS Q1,
PERCENTILE_CONT(0.75)
		 WITHIN GROUP (ORDER BY monthly_income) AS Q3
FROM general_data;



--Calculating the IQR of monthly income\

SELECT 
PERCENTILE_CONT(0.25)
		WITHIN GROUP (ORDER BY monthly_income) AS Q1,   -- Q1 calculation 
PERCENTILE_CONT(0.75)
		 WITHIN GROUP (ORDER BY monthly_income) AS Q3,  -- Q3 calculation
	((PERCENTILE_CONT(0.75)
		 WITHIN GROUP (ORDER BY monthly_income)) -  (PERCENTILE_CONT(0.25)
		WITHIN GROUP (ORDER BY monthly_income))) AS IQR  -- IQR calculation
FROM general_data;


--Calculating the IQR of monthly income with lower and upper boundary

SELECT 
PERCENTILE_CONT(0.25)
		WITHIN GROUP (ORDER BY monthly_income) AS Q1,   -- Q1 calculation 
PERCENTILE_CONT(0.75)
		 WITHIN GROUP (ORDER BY monthly_income) AS Q3,  -- Q3 calculation
	((PERCENTILE_CONT(0.75)
		 WITHIN GROUP (ORDER BY monthly_income)) -  (PERCENTILE_CONT(0.25)
		WITHIN GROUP (ORDER BY monthly_income))) AS IQR,  -- IQR calculation
(PERCENTILE_CONT(0.25)
		WITHIN GROUP (ORDER BY monthly_income))- (1.5 * ((PERCENTILE_CONT(0.75)
		 WITHIN GROUP (ORDER BY monthly_income)) -  (PERCENTILE_CONT(0.25)
		WITHIN GROUP (ORDER BY monthly_income)))) AS Lower_Boundary,   -- Lower Boundary Calculation
(PERCENTILE_CONT(0.75)
		 WITHIN GROUP (ORDER BY monthly_income)) + (1.5 * ((PERCENTILE_CONT(0.75)
		 WITHIN GROUP (ORDER BY monthly_income)) -  (PERCENTILE_CONT(0.25)
		WITHIN GROUP (ORDER BY monthly_income)))) AS Upper_Boundary  -- Upper Boundary Calculation
FROM general_data;


-- Finding employees whose salary is greater than statistical IQR


WITH Upper_boundary_dataset AS (
SELECT 
(PERCENTILE_CONT(0.75)
		 WITHIN GROUP (ORDER BY monthly_income)) + (1.5 * ((PERCENTILE_CONT(0.75)
		 WITHIN GROUP (ORDER BY monthly_income)) -  (PERCENTILE_CONT(0.25)
		WITHIN GROUP (ORDER BY monthly_income)))) AS Upper_Boundary  -- Upper Boundary Calculation
FROM general_data)

SELECT G.employee_id,
G.monthly_income,
U.Upper_boundary
FROM general_data AS G
CROSS JOIN Upper_boundary_dataset AS U
WHERE G.monthly_income > U.Upper_boundary;

-- Finding particular job roles in outlier


WITH Upper_boundary_dataset AS (
SELECT 
(PERCENTILE_CONT(0.75)
		 WITHIN GROUP (ORDER BY monthly_income)) + (1.5 * ((PERCENTILE_CONT(0.75)
		 WITHIN GROUP (ORDER BY monthly_income)) -  (PERCENTILE_CONT(0.25)
		WITHIN GROUP (ORDER BY monthly_income)))) AS Upper_Boundary  -- Upper Boundary Calculation
FROM general_data)

SELECT G.job_role,
COUNT(*)
FROM general_data AS G
CROSS JOIN Upper_boundary_dataset AS U
WHERE G.monthly_income > U.Upper_boundary
GROUP BY G.job_role
ORDER BY COUNT(*) DESC;


-- Finding particular job roles in outlier %


WITH Upper_boundary_dataset AS (
SELECT 
(PERCENTILE_CONT(0.75)
		 WITHIN GROUP (ORDER BY monthly_income)) + (1.5 * ((PERCENTILE_CONT(0.75)
		 WITHIN GROUP (ORDER BY monthly_income)) -  (PERCENTILE_CONT(0.25)
		WITHIN GROUP (ORDER BY monthly_income)))) AS Upper_Boundary  -- Upper Boundary Calculation
FROM general_data),

Job_role_HC AS (
SELECT G.job_role,
COUNT(*) AS total_employees
FROM General_data AS G
GROUP BY G.Job_role),

Outlier_Emp_table AS (
SELECT G.job_role,
COUNT(*) AS Outlier_Employees
FROM general_data AS G
CROSS JOIN Upper_boundary_dataset AS U
WHERE G.monthly_income > U.Upper_boundary
GROUP BY G.job_role)


SELECT JH.Job_role,
OET.Outlier_Employees,
JH.total_employees,
ROUND((COALESCE(OET.Outlier_Employees,0) :: numeric/JH.total_employees)*100,2) AS Outlier_Employees_Percentage
FROM Job_role_HC AS JH
LEFT JOIN Outlier_Emp_table AS OET
ON JH.job_role = OET.job_role
ORDER BY Outlier_Employees_Percentage DESC;



-- Data quality validation

--find the employees whose years since last promotion greater than company experience


SELECT G.employee_id,
G.years_at_company,
G.years_since_last_promotion
FROM general_data AS G
WHERE  G.years_at_company = 0 AND G.years_since_last_promotion >0;

--find the employees whose years with current manager is greater than company experience

SELECT G.employee_id,
G.years_at_company,
G.years_with_curr_manager
FROM general_data AS G
WHERE G.years_with_curr_manager  > G.years_at_company;

--find the employees whose years with current manager is greater than company experience (NULL findings)

SELECT G.employee_id,
G.years_at_company,
G.years_with_curr_manager
FROM general_data AS G
WHERE G.years_at_company = 0 AND G.years_with_curr_manager <>0 
AND G.years_with_curr_manager IS NOT NULL ;



--find the employees who are more than 10 years in job level 1


SELECT G.employee_id,
G.job_level,
G.years_at_company
FROM general_data AS G
WHERE G.job_level = 1 AND G.years_at_company >10;


--Categorizing the tenure

SELECT
CASE
	WHEN G.years_at_company >= 0 AND G.years_at_company <=5 THEN '0-5 years'
	WHEN G.years_at_company > 5 AND G.years_at_company <=10 THEN '6-10 years'
	WHEN G.years_at_company > 10 AND G.years_at_company <=15 THEN '11-15 years'
	ELSE '16 years+'
END AS Tenure_category,
COUNT(*) AS Employees
FROM General_data AS G
GROUP BY CASE
	WHEN G.years_at_company >= 0 AND G.years_at_company <=5 THEN '0-5 years'
	WHEN G.years_at_company > 5 AND G.years_at_company <=10 THEN '6-10 years'
	WHEN G.years_at_company > 10 AND G.years_at_company <=15 THEN '11-15 years'
	ELSE '16 years+'
END
ORDER BY tenure_category;
	


--total working years greater than age ..

SELECT G.employee_id,
G.age,
G.total_working_years
FROM General_data AS G
WHERE G.total_working_years > (G.age-18);


--finding employees whose experience is 0 and no other companies have worked ever


SELECT G.employee_id,
G.num_companies_worked,
G.total_working_years
FROM general_data AS G
WHERE G.num_companies_worked = 0 AND G.total_working_years >0;



--For each tenure band, what is the average number of years employees have been with their current manager?


WITH Tenure_with_avg_yrs_with_manager AS (
SELECT 
CASE
	WHEN G.years_at_company >= 0 AND G.years_at_company <=5 THEN '0-5 years'
	WHEN G.years_at_company > 5 AND G.years_at_company <=10 THEN '6-10 years'
	WHEN G.years_at_company > 10 AND G.years_at_company <=15 THEN '11-15 years'
	ELSE '16 years+'
END AS Tenure,
ROUND(AVG(G.years_with_curr_manager),2) AS average_years_with_manager
FROM General_data AS G
GROUP BY 
CASE
	WHEN G.years_at_company >= 0 AND G.years_at_company <=5 THEN '0-5 years'
	WHEN G.years_at_company > 5 AND G.years_at_company <=10 THEN '6-10 years'
	WHEN G.years_at_company > 10 AND G.years_at_company <=15 THEN '11-15 years'
	ELSE '16 years+'
END)


SELECT TAM.Tenure,
TAM.average_years_with_manager
FROM Tenure_with_avg_yrs_with_manager AS TAM
ORDER BY 
CASE
	WHEN Tenure = '0-5 years' THEN 1
	WHEN Tenure = '6-10 years' THEN 2
	WHEN Tenure = '11-15 years' THEN 3
	WHEN Tenure = '16 years+' THEN 4
END;
