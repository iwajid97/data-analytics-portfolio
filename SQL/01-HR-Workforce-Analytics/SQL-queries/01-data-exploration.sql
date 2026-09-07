-- 01-data-exploration

--Clearing the tables

TRUNCATE TABLE employee_survey_data,
				general_data,
				manager_survey_data;

SELECT COUNT(*) AS total_employees FROM general_data;

SELECT * FROM general_data
WHERE employee_id = 1


--Exploring the table (General data)

SELECT *
FROM general_data
ORDER BY employee_id
LIMIT 10;

-- checking the tables structure

SELECT column_name,
       data_type
FROM information_schema.columns
WHERE table_name = 'manager_survey_data'  -- can change the table name for profiling
ORDER BY ordinal_position;

-- Confirming the rows (unique)

SELECT COUNT(*) AS total_employees,
COUNT(DISTINCT employee_id) AS unique_employees
FROM general_data;

--Department wise HC

SELECT G.Department,
COUNT(*) AS employees_count
FROM general_data AS G
GROUP BY G.department
ORDER BY employees_count DESC;

--Checking missing values in monthly income


SELECT COUNT(*) AS employees_count,
COUNT(monthly_income) AS available_income,
COUNT(*) - COUNT(monthly_income)  AS missing_Income
FROM General_data;


-- checking the important columns

SELECT 
COUNT(*) - COUNT(monthly_income)  AS missing_Income,
COUNT(*) - COUNT(age) AS missing_Age,
COUNT(*) - COUNT(department) AS missing_dept,
COUNT(*) - COUNT(gender) AS missing_gender,
COUNT(*) - COUNT(business_travel) AS missing_BT,
COUNT(*) - COUNT(num_companies_worked) AS missing_NCW,
COUNT(*) - COUNT(total_working_years) AS missing_TWY
FROM General_data;

--Investigating the missing records


SELECT employee_id,
age,
department,
job_role,
num_companies_worked,
total_working_years
FROM general_data
WHERE num_companies_worked IS NULL
OR total_working_years IS NULL;

-- Metrics of data profiling


SELECT COUNT(*) AS total_employees,
COUNT(*) - COUNT(num_companies_worked) AS Missing_NCW,
ROUND(((COUNT(*) - COUNT(num_companies_worked))::numeric/ COUNT(*))*100,2) AS Missing_Percentage_NCW,
COUNT(*) - COUNT(total_working_years) AS Missing_TWY,
ROUND(((COUNT(*) - COUNT(total_working_years))::numeric/ COUNT(*))*100,2) AS Missing_Percentage_TWY
FROM General_data;


--Categorical value

--Inconsistent Categorical Values

--For Department

SELECT G.department,
Count(*) AS Employees
FROM general_data AS G
GROUP BY G.department
ORDER BY COUNT(*) DESC;

--For Job Role

SELECT G.job_role,
Count(*) AS Employees
FROM general_data AS G
GROUP BY G.job_role
ORDER BY COUNT(*) DESC;

--For Age Validation


SElECT Employee_id,
Age,
total_working_years
FROM general_data
ORDER BY total_working_years ASC
LIMIT 40;

--Validation of age raneg

SELECT employee_id,
age
FROM general_data
WHERE age > 60 OR age < 18;
