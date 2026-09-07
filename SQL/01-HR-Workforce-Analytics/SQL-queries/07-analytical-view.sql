
--Task_9 - create a database view

CREATE VIEW HR_dataset AS

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



SELECT COUNT(DISTINCT employee_id) FROM HR_dataset;

