
--Data cleaning (Handling NULL)
--finding employees whose num_companies_worked are nulls

SELECT G.employee_id,
G.num_companies_worked,
G.total_working_years
FROM general_data AS G
WHERE G.num_companies_worked IS NULL ;


--finding employees whose num_companies_worked and total_working_years are nulls

SELECT G.employee_id,
G.num_companies_worked,
G.total_working_years
FROM general_data AS G
WHERE G.num_companies_worked IS NULL
AND G.total_working_years IS NULL;

--finding employees whose num_companies_worked is null and total_working_years are equal to the years at company


SELECT G.employee_id,
G.num_companies_worked,
G.total_working_years,
G.years_at_company
FROM general_data AS G
WHERE G.num_companies_worked IS NULL
AND (G.total_working_years > G.years_at_company)


--finding employees whose num_companies_worked is null and total_working_years are equal to the years at company with additional information


SELECT G.employee_id,
G.age,
G.num_companies_worked,
G.total_working_years,
G.years_at_company,
G.years_since_last_promotion,
G.years_with_curr_manager
FROM general_data AS G
WHERE G.num_companies_worked IS NULL
AND (G.total_working_years > G.years_at_company);


--Find employees where:num_companies_worked = 0 AND total_working_years = years_at_company

SELECT G.employee_id,
G.num_companies_worked,
G.total_working_years,
G.years_at_company
FROM general_data AS G
WHERE num_companies_worked = 0 AND total_working_years = years_At_company;



--Find the blanks for each column

SELECT * 
FROM general_data 
WHERE years_with_curr_manager IS NULL


-- SQL data cleaning - duplicate detection and management

--identifying the same information employees exclude the employee ID

SELECT (age,
gender,department,
job_role,
marital_status,
education_field) AS Unique_column,
COUNT(*) AS employees
FROM general_data
GROUP BY (age,
gender,department,
job_role,
marital_status,
education_field)
HAVING COUNT(*)  > 1
ORDER BY employees DESC;



--identifying the same information employees exclude the employee ID CTE merged

WiTH potential_duplicate AS (
SELECT (age,
gender,department,
job_role,
marital_status,
education_field) AS Unique_column,
COUNT(*) AS employees
FROM general_data
GROUP BY (age,
gender,department,
job_role,
marital_status,
education_field)
HAVING COUNT(*)  > 1
ORDER BY employees DESC),

All_emp AS (SELECT G.Employee_id, (G.age,
G.gender,G.department,
G.job_role,
G.marital_status,
G.education_field) AS Unique_column
FROM general_data AS G)

SELECT AE.employee_id,
AE.Unique_column,
PD.employees
FROM all_emp AS AE
INNER JOIN potential_duplicate AS PD
ON PD.unique_column = AE.unique_column
ORDER BY employees DESC, AE.employee_ID;
