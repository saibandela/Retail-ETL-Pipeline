select * from dim_customers;

select * from dim_products;

select * from fact_sales;


-- 1️. Total number of sales transactions.
SELECT COUNT(*) FROM fact_sales;


-- 2️. Total revenue generated.
SELECT ROUND(SUM(total_amount)::NUMERIC,2) as total_revenue
FROM fact_sales;

-- 3️. Total number of customers.
SELECT COUNT(*) FROM dim_customers;

-- 4️. List first 10 customers.
SELECT * FROM dim_customers
LIMIT 10;

-- 5️. Revenue by Country.
SELECT c.country,
      ROUND(SUM(total_amount)::NUMERIC,2) AS revenue from fact_sales AS f
JOIN dim_customers AS c
ON f.customer_id = c.customer_id
GROUP BY c.country
ORDER BY revenue DESC;

-- 6️. Monthly Revenue.
SELECT
    DATE_TRUNC('month', invoice_date) AS month,
    ROUND(SUM(total_amount)::NUMERIC,2) as revenue
FROM fact_sales
GROUP BY month
ORDER BY revenue desc;

-- 7️. Top 10 Products by Revenue.
SELECT
     p.description,
	 ROUND(SUM(total_amount)::NUMERIC,2) AS revenue
FROM fact_sales AS f
JOIN dim_products AS p
ON f.product_id = p.product_id
GROUP BY p.description
ORDER BY revenue DESC
LIMIT 10

-- 8️. Top 5 Customers by Spending.
SELECT 
    customer_id,
    ROUND(SUM(total_amount)::NUMERIC,2) AS total_spent
FROM fact_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- 9️. Repeat Customers (More Than 5 Purchases).
SELECT 
    customer_id,
    COUNT(invoice_no) AS purchase_count
FROM fact_sales
GROUP BY customer_id
HAVING COUNT(invoice_no) > 5
ORDER BY purchase_count DESC;

-- 10. Most Profitable Month.
SELECT 
    DATE_TRUNC('month', invoice_date) AS month,
    ROUND(SUM(total_amount)::NUMERIC,2) AS revenue
FROM fact_sales
GROUP BY month
ORDER BY revenue DESC
LIMIT 1;

-- 1️1. Average Order Value.
SELECT 
    SUM(total_amount) / COUNT(DISTINCT invoice_no) AS avg_order_value
FROM fact_sales;

-- 1️3. Running Total Revenue by Month.
SELECT 
    month,
    SUM(revenue) OVER (ORDER BY month) AS running_total
FROM (
    SELECT 
        DATE_TRUNC('month', invoice_date) AS month,
        ROUND(SUM(total_amount)::NUMERIC,2) AS revenue
    FROM fact_sales
    GROUP BY month
) t;




