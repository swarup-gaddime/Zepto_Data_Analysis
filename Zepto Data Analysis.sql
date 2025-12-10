CREATE DATABASE zepto;

USE zepto;

-- Data Exploration

-- Count of rows
SELECT COUNT(*) FROM zepto_v2;

-- Sample Data
SELECT * FROM zepto_v2;

-- Null values
SELECT * FROM zepto_v2
WHERE name IS NULL
OR
Category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
availableQuantity IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

-- Different product categories
SELECT DISTINCT category
FROM zepto_v2
ORDER BY category;

-- Products in stock vs out of stock
SELECT outOfStock, COUNT(*)
FROM zepto_v2
GROUP BY outOFStock;

-- Product names present multiple times
SELECT name, COUNT(*)  
FROM zepto_v2
GROUP BY name
hAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;

-- Data Cleaning

-- Products with price = 0
SELECT * FROM zepto_v2
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto_v2
WHERE mrp = 0;

-- Convert paise to rupees
UPDATE zepto_v2
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp, discountedSellingPrice FROM zepto_v2;

-- Data analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.

SELECT DISTINCT name, mrp, discountPercent FROM zepto_v2
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2.What are the Products with High MRP but Out of Stock

SELECT DISTINCT name, mrp, outOFStock FROM zepto_v2
WHERE outOFStock = 'TRUE' AND mrp > 300
ORDER BY mrp DESC;


-- Q3.Calculate Estimated Revenue for each category

SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto_v2
GROUP BY category
ORDER BY  total_revenue;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.

SELECT DISTINCT name, mrp, discountPercent From zepto_v2
WHERE mrp > 500 and discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.

SELECT category, ROUND(AVG(discountPercent),2) AS highest_avg_dis_percent FROM zepto_v2
GROUP BY category
ORDER BY highest_avg_dis_percent DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.

SELECT DISTINCT name, weightInGms, discountedSellingPrice, discountedSellingPrice/weightInGms AS price_per_gram
FROM zepto_v2
WHERE weightInGms > 100
ORDER BY price_per_gram DESC;

-- Q7.Group the products into categories like Low, Medium, Bulk.

SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
     WHEN weightInGms < 5000 THEN 'Medium'
     ELSE 'Bulk'
     END AS weight_category
FROM zepto_v2;

-- Q8.What is the Total Inventory Weight Per Category

SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto_v2
GROUP BY category
ORDER BY total_weight;