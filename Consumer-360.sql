use consumer_360


SELECT * FROM customer_shopping_data_new LIMIT 10;
select * from customer_shopping_data_new LIMIT 10;
SELECT COUNT(*) FROM customer_shopping_data_new;
SELECT COUNT(DISTINCT customer_id) FROM customer_shopping_data_new;

-- Remove duplicates
DELETE FROM customer_shopping_data_new
WHERE invoice_no IN (
  SELECT invoice_no
  FROM (
    SELECT invoice_no, ROW_NUMBER() OVER (PARTITION BY invoice_no ORDER BY invoice_no) AS rnum
    FROM customer_shopping_data_new
  ) t
  WHERE t.rnum > 1
);


ALTER TABLE customer_shopping_data_new ADD COLUMN total_amount DECIMAL(12,2);

-- Monthly Sales Trend
SELECT 
  DATE_FORMAT(invoice_date, '%Y-%m') AS month,
  SUM(total_amount) AS monthly_sales
FROM customer_shopping_data_new
GROUP BY month
ORDER BY month;

-- Top 5 Product Categories by Revenue
SELECT 
  category,
  SUM(total_amount) AS revenue
FROM customer_shopping_data
GROUP BY category
ORDER BY revenue DESC
LIMIT 5;

-- Shopping Mall (Country/City) Wise Revenue 
SELECT 
  shopping_mall,
  SUM(total_amount) AS revenue
FROM customer_shopping_data
GROUP BY shopping_mall
ORDER BY revenue DESC;

-- Customer RFM Analysis Prep
SELECT 
  customer_id,
  MAX(invoice_date) AS last_purchase_date,
  COUNT(DISTINCT invoice_no) AS frequency,
  SUM(total_amount) AS monetary
FROM customer_shopping_data
GROUP BY customer_id;
