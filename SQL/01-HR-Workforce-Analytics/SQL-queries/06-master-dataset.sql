

--06-master-dataset

-- Build the analytical / Master HR dataset

-- Task- 1

--1. Primary table is General\_data, 
--2. We should go with employee\_id column because of primary key
--3. LEFT JOIN to have all information even if it is NULL


--Task_2 - Build the first part of the master dataset

SELECT G.employee_id,
G.age,
G.gender,
G.department,
G.job_role,
G.monthly_income,
ES.environment_satisfaction,
ES.job_satisfaction,
ES.work_life_balance
FROM General_data AS G
LEFT JOIN employee_survey_data AS ES
ON G.employee_id = ES.employee_id;

-- Task 3 - find the rows which has nulls from the both tables(both sides)

SELECT G.employee_id,
G.age,
G.gender,
G.department,
G.job_role,
G.monthly_income,
ES.environment_satisfaction,
ES.job_satisfaction,
ES.work_life_balance
FROM General_data AS G
LEFT JOIN employee_survey_data AS ES
ON G.employee_id = ES.employee_id
WHERE ES.employee_id IS NULL;

SELECT G.employee_id,
G.age,
G.gender,
G.department,
G.job_role,
G.monthly_income,
ES.environment_satisfaction,
ES.job_satisfaction,
ES.work_life_balance
FROM employee_survey_data  AS ES
LEFT JOIN general_data AS G
ON G.employee_id = ES.employee_id
WHERE G.employee_id IS NULL;



--Task_4 adding the manager survey table

SELECT G.employee_id,
G.age,
G.gender,
G.department,
G.job_role,
G.monthly_income,
ES.environment_satisfaction,
ES.job_satisfaction,
ES.work_life_balance,
MS.job_involvement,
MS.performance_rating
FROM General_data AS G
LEFT JOIN employee_survey_data AS ES
ON G.employee_id = ES.employee_id
LEFT JOIN manager_survey_data AS MS
ON G.employee_id = MS.employee_id;



--Task_5 - check for row multiplication


WITH HR_dataset AS (
SELECT G.employee_id,
G.age,
G.gender,
G.department,
G.job_role,
G.monthly_income,
ES.environment_satisfaction,
ES.job_satisfaction,
ES.work_life_balance,
MS.job_involvement,
MS.performance_rating
FROM General_data AS G
LEFT JOIN employee_survey_data AS ES
ON G.employee_id = ES.employee_id
LEFT JOIN manager_survey_data AS MS
ON G.employee_id = MS.employee_id)

SELECT HR.employee_id,
COUNT(*) AS Total_rows
FROM HR_dataset AS HR
GROUP BY HR.employee_id
HAVING COUNT(*) > 1;


--Task_6 - NULL Validation

SELECT G.employee_id,
G.age,
G.gender,
G.department,
G.job_role,
G.monthly_income,
ES.environment_satisfaction,
ES.job_satisfaction,
ES.work_life_balance,
MS.job_involvement,
MS.performance_rating
FROM General_data AS G
LEFT JOIN employee_survey_data AS ES
ON G.employee_id = ES.employee_id
LEFT JOIN manager_survey_data AS MS
ON G.employee_id = MS.employee_id
WHERE ES.environment_satisfaction IS NULL OR
ES.job_satisfaction IS NULL OR
ES.work_life_balance IS NULL OR
MS.job_involvement IS NULL OR 
MS.performance_rating IS NULL;

-- Task_7  - final dataset validation


--total rows = 4410
--unique employees = 4410
--duplicate employees = 0
--all three source tables are properly connected



--Task_8 - create the analytical dataset

WITH Master_emp AS (
SELECT G.employee_id,
G.age,
G.gender,
G.department,
G.job_role,
G.monthly_income
FROM general_Data AS G),

emp_survey AS (
SELECT ES.employee_id,
ES.environment_satisfaction,
ES.job_satisfaction,
ES.work_life_balance
FROM employee_survey_data AS ES
),

manager_survey AS(
SELECT MS.employee_id,
MS.job_involvement,
MS.performance_rating 
FROM manager_survey_data AS MS
)

SELECT ME.employee_id,
ME.age,
ME.gender,
ME.department,
ME.job_role,
ME.monthly_income,
ES1.environment_satisfaction,
ES1.job_satisfaction,
ES1.work_life_balance,
MS1.job_involvement,
MS1.performance_rating
FROM Master_emp AS ME
LEFT JOIN emp_survey AS ES1
ON ES1.employee_id = ME.employee_id
LEFT JOIN manager_survey AS MS1
ON MS1.employee_id = ME.employee_id;

