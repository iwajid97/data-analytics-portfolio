# HR Workforce Analytics — SQL Portfolio Project

## Project Overview

A hands-on SQL analytics case study developed using PostgreSQL and three related HR datasets. The project demonstrates the practical application of SQL across data exploration, data quality assessment, data validation, data integration, advanced querying, and workforce analysis.

## Objective

To apply and demonstrate practical SQL skills by exploring HR workforce data, validating data integrity, integrating multiple datasets, and deriving meaningful workforce insights using PostgreSQL.

## Dataset

The project uses three related datasets:

* `general_data` — core employee information
* `employee_survey_data` — employee survey responses
* `manager_survey_data` — manager survey responses

The datasets are connected through `employee_id` and were consolidated for analytical purposes.

## Analytical Approach

The project follows an end-to-end SQL workflow:

**Data Exploration → Data Quality → Data Cleaning → Data Integration → Advanced SQL Analysis → Workforce Insights**

## SQL Skills Demonstrated

* Data exploration and profiling
* Filtering, sorting and aggregation
* `GROUP BY` and `HAVING`
* Conditional logic using `CASE`
* Table joins and data integration
* Common Table Expressions (CTEs)
* Subqueries
* Window functions
* `FIRST_VALUE()` and `LAST_VALUE()`
* NULL and duplicate handling
* Data consistency and integrity validation
* IQR-based outlier analysis
* Analytical views
* Workforce and descriptive analysis

## Data Quality & Validation

The project includes validation of employee uniqueness, duplicate records, NULL values, join behaviour, data consistency, and the integrity of the consolidated analytical dataset.

## Project Structure


01-HR-Workforce-Analytics/
│
├── README.md
├── data/
│   └── raw/
├── sql/
├── documentation/
└── images/
```

## Tools & Technologies

* PostgreSQL
* SQL
* pgAdmin
* GitHub

## Outcome

The project demonstrates the ability to work with relational HR datasets, perform structured data validation and transformation, apply intermediate-to-advanced SQL techniques, and translate data into workforce-oriented analytical insights.

## Project Purpose

This project was developed as a comprehensive hands-on SQL case study rather than around a single predefined business requirement. The broad scope was intentionally designed to demonstrate practical SQL capability across multiple stages of the data analytics workflow.





01-HR-Workforce-Analytics/
│
├── README.md
│
├── data/
│   └── raw/
│       ├── general_data.csv
│       ├── employee_survey_data.csv
│       └── manager_survey_data.csv
│
├── sql/
│   ├── 01-data-exploration.sql
│   ├── 02-data-quality-validation.sql
│   ├── 03-data-cleaning.sql
│   ├── 04-outlier-analysis.sql
│   ├── 05-window-functions.sql
│   ├── 06-master-dataset.sql
│   ├── 07-analytical-view.sql
│   └── 08-business-analysis.sql
│
├── documentation/
│   └── data-dictionary.md
│
└── images/
    ├── data-model.png
    ├── postgresql-tables.png
    └── query-results.png
