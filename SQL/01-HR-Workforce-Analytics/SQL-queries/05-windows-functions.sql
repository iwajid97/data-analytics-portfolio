
--05-window-functions

--SQL advanced windows functions - FIRST VALUE()


--Basic understanding

--Task_1

SELECT G.employee_id,
G.department,
G.years_at_company,
G.monthly_income,
FIRST_VALUE(G.monthly_income) OVER(
PARTITION BY G.department
ORDER BY G.monthly_income
) AS Lowest_monthly_income_each_dept
FROM general_data AS G;

--Task_2

SELECT G.employee_ID,
G.department,
G.years_at_company,
G.monthly_income,
FIRST_VALUE(G.monthly_income) OVER(
PARTITION BY G.department
ORDER BY G.years_at_company DESC
) AS Income_of_longest_tenured_Employee
FROM General_data AS G;


--Real_HR DATA


--Task_3

SELECT G.employee_id,
G.monthly_income,
FIRST_VALUE(G.monthly_income) OVER(
PARTITION BY G.department
ORDER BY G.monthly_income DESC
) AS highest_monthly_income_within_department
FROM General_data AS G;




--Task_4

SELECT G.employee_id,
G.department,
G.years_at_company,
FIRST_VALUE(G.years_at_company) OVER(
PARTITION BY G.department
ORDER BY G.years_at_company DESC
) AS Highest_experience_within_Dept
FROM General_data AS G;


--Task_5

SELECT G.employee_id,
G.department,
G.monthly_income,
FIRST_VALUE(G.monthly_income) OVER(
PARTITION BY G.department
ORDER BY G.years_at_company DESC
) AS highest_salary_within_depart
FROM general_data AS G;

--Task_6

SELECT G.employee_id,
G.department,
G.years_since_last_promotion,
FIRST_VALUE(years_since_last_promotion) OVER(
PARTITION BY G.department
ORDER BY G.years_since_last_promotion ASC
) AS Minimum_years_since_promotion
FROM General_Data AS G;

--Task_7

SELECT G.employee_id,
G.department,
G.job_role,
G.monthly_income,
FIRST_VALUE(G.monthly_income) OVER(
PARTITION BY G.department
ORDER BY G.years_at_company DESC
) AS Benchmark_income,
G.years_at_company,
(FIRST_VALUE(G.monthly_income) OVER(
PARTITION BY G.department
ORDER BY G.years_at_company DESC
) - G.monthly_income )AS Difference
FROM general_data AS G;

--LAST_VALUE () Practice

--Task_1 Last salary by department

SELECT G.employee_id,
G.department,
G.monthly_income,
LAST_VALUE(G.monthly_income) OVER(
PARTITION BY G.department
ORDER BY G.years_at_company ASC
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
) AS last_emp_monthly_income
FROM General_data AS G;

--Task_2 - Longest-tenured employee's income

SELECT G.employee_id,
G.department,
G.years_at_company,
G.monthly_income,
LAST_VALUE(G.monthly_income) OVER(
PARTITION BY G.department
ORDER BY G.years_at_company ASC
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
) AS Income_of_employee_longest_tenure
FROM general_data AS G;


 
--Task_3 - Most recent promotion benchmark

SELECT G.employee_id,
G.department,
G.years_since_last_promotion,
LAST_VALUE(G.years_since_last_promotion) OVER(
PARTITION BY G.department
ORDER BY G.years_since_last_promotion ASC
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
) AS highest_years_since_last_promotion
FROM General_data AS G;

--Task_4 - Highest tenure in each job role

SELECT G.employee_id,
G.job_role,
G.years_at_company,
LAST_VALUE(G.years_at_company) OVER(
PARTITION BY G.job_role
ORDER BY G.years_at_company ASC
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
) AS highest_years_at_company_within_jobrole
FROM general_data AS G;

--Task_5 - Salary gap from the longest tenured employee


SELECT G.employee_id,
G.department,
G.monthly_income,
G.years_at_company,
LAST_VALUE(G.monthly_income) OVER(
PARTITION BY G.department
ORDER BY G.years_at_company ASC
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
) AS Benchmark,
(G.monthly_income - LAST_VALUE(G.monthly_income) OVER(
PARTITION BY G.department
ORDER BY G.years_at_company ASC
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)) AS Difference
FROM general_data AS G;


--Task_6 - Compare current manager tenure


SELECT G.employee_id,
G.department,
G.years_with_curr_manager,
LAST_VALUE(G.years_with_curr_manager) OVER(
PARTITION BY G.department
ORDER BY G.years_with_curr_manager ASC
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
) AS higest_years_with_manager
FROM General_data AS G;


-- Task_7 - Department Benchmark Analysis

SELECT G.employee_id,
G.department,
G.job_role,
G.monthly_income,
G.years_at_company,
LAST_VALUE(G.monthly_income) OVER(
PARTITION BY G.department
ORDER BY G.years_at_company ASC
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
) AS benchmark_income,
(G.monthly_income-LAST_VALUE(G.monthly_income) OVER(
PARTITION BY G.department
ORDER BY G.years_at_company ASC
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)) AS Difference,
G.years_with_curr_manager,
LAST_VALUE(G.years_with_curr_manager) OVER(
PARTITION BY G.department
ORDER BY G.years_with_curr_manager ASC
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
) AS highest_years_with_curr_manager_in_dept
FROM General_data AS G;


