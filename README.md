📦 Retail ETL Pipeline
End-to-End Data Engineering Project (Python + PostgreSQL)
🚀 Project Overview

This project implements a production-style ETL pipeline to process transactional retail data and load it into a PostgreSQL data warehouse using a star schema design.

The pipeline extracts raw Excel data, performs data cleaning and transformation using Python (Pandas), and loads structured fact and dimension tables into PostgreSQL for analytics.

🏗 Architecture

Raw Excel Data
      ↓
Extract (Pandas)
      ↓
Transform (Data Cleaning + Business Logic)
      ↓
Load (PostgreSQL Star Schema)
      ↓
SQL Analytics

🧰 Tech Stack

Python (Pandas)

PostgreSQL

SQLAlchemy

Star Schema Modeling

Window Functions

Index Optimization

📊 Data Model (Star Schema)
🔹 Dimension Tables

dim_customers

customer_id (Primary Key)

country

dim_products

product_id (Primary Key)

description

🔹 Fact Table

fact_sales

sale_id (SERIAL Primary Key)

invoice_no

product_id (Foreign Key)

customer_id (Foreign Key)

quantity

unit_price

total_amount

invoice_date

🔄 Data Transformation Logic

Removed null customer IDs

Filtered cancelled invoices

Removed negative quantities

Standardized column names

Converted invoice_date to TIMESTAMP

Created derived column:
total_amount = quantity × unit_price

Enforced referential integrity using Foreign Keys

📈 SQL Analytical Queries Implemented
1️⃣ Total Sales Transactions.

SELECT COUNT(*) FROM fact_sales;

2️⃣ Total Revenue Generated.

SELECT ROUND(SUM(total_amount)::NUMERIC,2) AS total_revenue
FROM fact_sales;

3️⃣ Total Number of Customers.

SELECT COUNT(*) FROM dim_customers;

4️⃣ Revenue by Country.

SELECT c.country,
       ROUND(SUM(total_amount)::NUMERIC,2) AS revenue
FROM fact_sales AS f
JOIN dim_customers AS c
ON f.customer_id = c.customer_id
GROUP BY c.country
ORDER BY revenue DESC;

5️⃣ Monthly Revenue.

SELECT DATE_TRUNC('month', invoice_date) AS month,
       ROUND(SUM(total_amount)::NUMERIC,2) AS revenue
FROM fact_sales
GROUP BY month
ORDER BY revenue DESC;

6️⃣ Top 10 Products by Revenue.

SELECT p.description,
       ROUND(SUM(total_amount)::NUMERIC,2) AS revenue
FROM fact_sales AS f
JOIN dim_products AS p
ON f.product_id = p.product_id
GROUP BY p.description
ORDER BY revenue DESC
LIMIT 10;

7️⃣ Top 5 Customers by Spending.

SELECT customer_id,
       ROUND(SUM(total_amount)::NUMERIC,2) AS total_spent
FROM fact_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;

8️⃣ Repeat Customers (More Than 5 Purchases).

SELECT customer_id,
       COUNT(invoice_no) AS purchase_count
FROM fact_sales
GROUP BY customer_id
HAVING COUNT(invoice_no) > 5
ORDER BY purchase_count DESC;

9️⃣ Most Profitable Month.

SELECT DATE_TRUNC('month', invoice_date) AS month,
       ROUND(SUM(total_amount)::NUMERIC,2) AS revenue
FROM fact_sales
GROUP BY month
ORDER BY revenue DESC
LIMIT 1;

🔟 Average Order Value.

SELECT SUM(total_amount) / COUNT(DISTINCT invoice_no) AS avg_order_value
FROM fact_sales;

1️⃣1️⃣ Running Total Revenue by Month (Window Function).

SELECT month,
       SUM(revenue) OVER (ORDER BY month) AS running_total
FROM (
    SELECT DATE_TRUNC('month', invoice_date) AS month,
           ROUND(SUM(total_amount)::NUMERIC,2) AS revenue
    FROM fact_sales
    GROUP BY month
) t;

⚡ Performance Optimization

Primary Keys for uniqueness

Foreign Keys for integrity

Indexing on:

invoice_date

customer_id

Aggregation queries optimized with GROUP BY and JOIN

Window Functions for advanced analytics

🧠 Key Data Engineering Concepts Demonstrated

Star Schema Design

Dimensional Modeling

Data Cleaning & Transformation

SQL Aggregations & Window Functions

Index Optimization

Full Refresh ETL Strategy

Referential Integrity Enforcement

🔮 Future Enhancements

Incremental Load using UPSERT

Slowly Changing Dimensions (SCD Type 2)

Spark-based transformation

Docker containerization

Cloud deployment (Snowflake / Databricks)

🎯 Project Outcome

This project demonstrates practical data engineering skills including ETL design, schema modeling, query optimization, and analytical reporting using structured SQL.

