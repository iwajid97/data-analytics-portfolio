# Data Dictionary

## 1. Overview

## 2. Dataset: General Data

## 3. Dataset: Employee Survey Data

## 4. Dataset: Manager Survey Data

## 5. Common Key

## 6. Data Relationships



# Data Dictionary

## 1. Overview

This document describes the datasets used in the HR Workforce Analytics
SQL portfolio project.

The project uses three related datasets:

- General Employee Data
- Employee Survey Data
- Manager Survey Data

The datasets are linked using Employee ID and were analysed using PostgreSQL.

---

## 2. Dataset: General Data

| Column | Description | Data Type |
|---|---|---|
| employee_id | Unique identifier for each employee | Integer |
| department | Employee's department | Text |
| job_role | Employee's job role | Text |
| salary | Employee salary category/value | Numeric |
| years_at_company | Number of years employed by the company | Integer |
| age | Employee age | Integer |

---

## 3. Dataset: Employee Survey Data

| Column | Description | Data Type |
|---|---|---|
| employee_id | Unique employee identifier | Integer |
| job_satisfaction | Employee's job satisfaction rating | Integer |
| environment_satisfaction | Employee's satisfaction with the work environment | Integer |
| relationship_satisfaction | Employee's relationship satisfaction rating | Integer |

---

## 4. Dataset: Manager Survey Data

| Column | Description | Data Type |
|---|---|---|
| employee_id | Unique employee identifier | Integer |
| job_involvement | Employee's level of job involvement | Integer |
| performance_rating | Employee performance rating | Integer |

---

## 5. Common Key

The `employee_id` column is used as the common identifier across the datasets.

It enables the datasets to be joined and consolidated into a master analytical
dataset.

---

## 6. Data Relationships

General Data
    |
    | employee_id
    |
    +---- Employee Survey Data
    |
    +---- Manager Survey Data
    
