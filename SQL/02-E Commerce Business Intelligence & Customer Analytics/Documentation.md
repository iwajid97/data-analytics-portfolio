E-Commerce Business Intelligence & Customer Analytics


--Documentation Structure:
1. Project Title
2. Project Overview
3. Business Objective
4. Business Questions
5. Dataset Description
6. Data Model
7. Tools and Technologies
8. Methodology
9. SQL Analysis Sections
10. Key Findings
11. Business Recommendations
12. Data Quality Checks
13. Limitations
14. Project Structure
15. Conclusion

--Project Overview
This project analyses the e-commerce data from the Kaggle site, which is published by the Olist dataset of Brazilian e-commerce. Furthermore, it analyses and studies the performance of the business along with seller performance, customer retention and value, customer behaviour, sales across periods, and others by using PostgreSQL to understand the complex dataset and transform it into a business-ready summarised version.

--Business Objective
The objective of this project is to understand the sales activity across the period, customer behaviours based on their review score after the orders they received, which can identify opportunity to enhance the sales revenue accordingly.

--Business Questions (By AI Generative)
1.Customer Analytics
What percentage of customers made repeat purchases?
How many customers made only one purchase?
Which customers generated the highest lifetime value?

2.Revenue Analytics
Which product categories generated the highest revenue?
Which sellers contributed the most revenue?
How concentrated was revenue among the top sellers?

3.Delivery Analytics
What was the average delivery duration?
What percentage of orders were delivered late?
Which sellers had the highest late-delivery rate?

4.Customer Experience
What was the average review score?
Which categories received the highest review scores?
Did late deliveries affect customer reviews?

(Prompted AI to behave like a data analyst lead -- Practise Purpose)

--Dataset Description
The project uses the Brazilian E-Commerce Public Dataset by Olist.
The dataset contains information about orders, customers, sellers,
products, reviews, and delivery dates.

Tables	Description
Orders_Dataset	- Order-Level Information - One row per order id
Customer_Dataset	- Customer Identifiers and their locations - one row per customer id info
Order_Item_Dataset	- Product purchases within each order - one row per item ordered id.
Product_Dataset	- Product details such as size, material etc - one row per product id  info
Seller_Dataset	- seller information such as branch, city , state etc - one row per seller id info
Review_Dataset	- customer review information such as review score - one row per order id review 

--Data Model
customer_dataset
        |
        | customer_id (Left Join or Inner Join - Depends on requirement)
        |
orders_dataset
        |
        | order_id (Left Join or Inner Join - Depends on requirement)
        |
order_item_dataset
        |
        | product_id (Left Join or Inner Join - Depends on requirement)
        |
product_dataset
        
review_dataset
        |
        | order_id (Left Join or Inner Join - Depends on requirement)
        |
orders_dataset
        |
        | order_id (Left Join or Inner Join - Depends on requirement)
        |
order_item_dataset
        |
        | seller_id (Left Join or Inner Join - Depends on requirement)
        |
seller_dataset

--Tools and Technologies

-PostgreSQL (Storing the CSV files in On-premises via PostgreSQL)
-PGAdmin (Used to manipulate the data)
-SQL (to write query for extraction or summarised)
-Generative AI (ChatGPT) - Only for evaluations and receiving instruction from Gen AI.
-CSV raw files
-Common table expressions (Inside the query)
-Windows functions (Inside the query)
-Aggregate functions (Inside the query)
-GITHUB (To store the work or project as a showcase)


--Methodology

### 1. Data Preparation
- Reviewed table structures. (Each table before writing query)
- Checked null values. (Found few columns null and asked myself to remove or keep it as it is)
- Checked duplicate identifiers. (Make sure to have no duplication)
- Reviewed available order statuses. (No unexpected term exists in order status column)

### 2. Data Filtering
- Used delivered orders for customer and revenue analysis. (To analyse only in delivered orders instead of including all such as canceled and others)
- Excluded irrelevant or invalid records where required. 

### 3. Data Transformation
- Converted timestamps into monthly periods. (By using DATE_TRUNC function to transform the month from timestamps)
- Calculated delivery duration. (just by subtracting with two values and using extract function along with EPOCH to get the accurate duration)
- Created customer and seller segments. (By using CASE function to create segments)

### 4. Data Aggregation
- Aggregated customer-level metrics. (AVG/COUNT/SUM) along with GROUP BY clause)
- Aggregated seller-level metrics. (AVG/COUNT/SUM) along with GROUP BY clause)
- Aggregated product-category metrics. (AVG/COUNT/SUM) along with GROUP BY clause)

### 5. Validation
- Checked duplicate records. (used count function for validation the row numbers across multiple tables)
- Checked missing timestamps. (Checked and excluded the null rows due to not important to analyse for business)
- Checked unmatched customer records. (Used joins and try to find the null in other table)
- Validated order statuses. (No unexpected term exists in order status column)

--SQL Analysis Sections (Important Query only)

1. Revenue by Product Category
   
WITH product_cat_with_revenue AS (
SELECT OI.Order_id,
OI.product_id,
OI.price,
P.product_category_name
FROM order_item_dataset AS OI
LEFT JOIN products_dataset AS P
ON P.product_id = OI.product_id)

SELECT product_category_name,
SUM(price) AS revenue,
ROUND(SUM(price) / (SELECT SUM(price) FROM product_cat_with_revenue) *100,2) AS Revenue_percentage
FROM product_cat_with_revenue
GROUP BY product_category_name
ORDER BY revenue DESC;

2. Delivery Duration Analysis

  WITH Orders_duration AS (
	SELECT DATE_TRUNC('month',order_purchase_timestamp):: DATE AS Month,
		EXTRACT(EPOCH FROM (order_delivered_customer_date - order_purchase_timestamp))/86400 AS total_duration,
		order_status
	FROM orders_dataset
		WHERE order_status = 'delivered' AND
			EXTRACT(EPOCH FROM (order_delivered_customer_date - order_purchase_timestamp))/86400 IS NOT NULL)

	SELECT OD.Month,
		ROUND(AVG(OD.total_duration),2) AS Average_Delivery_Days
	FROM Orders_duration AS OD
	GROUP BY OD.Month
	ORDER BY OD.Month;

  3.Average review score by product category

  WITH Product_cat_with_reviews AS (
SELECT R.review_id,
R.review_score,
P.product_category_name
FROM order_reviews_dataset AS R
INNER JOIN order_item_dataset AS OI
ON R.order_id = OI.order_id
INNER JOIN products_dataset AS P
ON OI.product_id = P.product_id
WHERE P.product_category_name IS NOT NULL)

SELECT Product_category_name,
COUNT(DISTINCT review_id) AS Number_of_Reviews,
ROUND(AVG(Review_Score),2) AS Average_Review_Score
FROM product_cat_with_reviews
GROUP BY product_category_name
HAVING COUNT(DISTINCT review_id) >=100
ORDER BY Average_Review_Score ASC;



--Key Findings

Finding Area and Business meaning.
1.Customer Retention	Repeat customer rate was approximately 3%	Retention opportunity
2.Revenue	beleza_saude - Product Category generated the highest revenue	Important revenue driver
3.Sellers	Top 10 sellers contributed 10% of revenue	Revenue concentration
4.Delivery	Late delivery rate was 8.11%	Logistics improvement opportunity
5.Reviews	Average review score was 4	Customer experience indicator

--Business Recommendations
1.Improve customer retention by providing post-purchase campaign or exclusive offers
2.Focus on the low revenue generated product category for marketing campaign
3.It would be better to compensate them for achieving and it boost others to give their full potential
4.Analyse on particular delay locations and if require increase manpower or resource to cover the deliveries for on time milestones
5.Eventhough we get 4 average score. there might be some customers with low satisfaction to focus on them and retain the same level of positive review score


--Data Quality Check
Check	Purpose	Result
Unmatched orders	- Check referential integrity	- There are no unmatched orders found
Duplicate customer IDs	- Identify duplicate records	- There are no unexpected duplicates record
Null purchase timestamps	- Validate time analysis	- There are few null in timestamp column which can be exclude due to the order status as canceled or unavailable
Multiple unique - IDs per customer ID	Check identifier consistency	Customer unique ID is found as distinct
Unexpected order statuses- 	Validate business categories- 	No unexpected order status word


--Limitations

The dataset, downloaded from Kaggle for practice, lacks real-time visibility and is therefore not current.  It covers data from the end of 2018 onwards but the starting and ending months are missing data records.

--Projects Structure

E-Commerce-Business-Intelligence and customer analytics

├── sql/
├── documentation/
├── screenshots/
└── visuals/

--Conclusion
1. As I mentioned earlier, this project is for practice purposes to retain my hands-on experience and to gain visibility into the customer and sales domain, which I am not familiar with.
2. It includes revenue by different categories such as seller, periods, customers,product category, and others. Additionally, it focuses on customer behaviour like repeated purchases/ one-time purchases, review scores by delay, freight cost, and others.
3.Used windows functions,aggregate functions, clauses, CTE and sub query whenever it occured
4.The result demonstrate the descriptive analysis and to understand the numbers for executive level and for business intelligence report tools such as power bi, tableau.

