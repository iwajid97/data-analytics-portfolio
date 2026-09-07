--04-outlier-analysis

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

