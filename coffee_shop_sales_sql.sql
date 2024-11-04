create database coffee_shop_sales;
select  * from coffee_shop_sales;

SET SQL_SAFE_UPDATES = 0;

UPDATE coffee_shop_sales 
SET transaction_date = STR_TO_DATE(transaction_date, '%d-%m-%Y');

ALTER TABLE coffee_shop_sales
MODIFY COLUMN transaction_date DATE;

UPDATE coffee_shop_sales 
SET transaction_time = STR_TO_DATE(transaction_time, '%H:%i:%s');

ALTER TABLE coffee_shop_sales
MODIFY COLUMN transaction_time TIME;

select  * from coffee_shop_sales;

ALTER TABLE coffee_shop_sales
CHANGE COLUMN transaction_id transaction_id INT;

SELECT CONCAT((ROUND(SUM(unit_price * transaction_qty)))/1000, "K") AS Total_Sales
FROM coffee_shop_sales
WHERE
MONTH(transaction_date) = 3 -- may months

-- Selected Months / CM - May=5
-- PM - April = 4

SELECT
      MONTH(transaction_date) AS month,  -- Number of Months
      ROUND(SUM(unit_Price * transaction_qty)) AS total_sales, -- Total Sales column
      (SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1) -- Months sales difference
      OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(unit_price * transaction_qty), 1) -- Division by Percentage
      OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage -- Percentage 
FROM
    coffee_shop_sales
WHERE 
     MONTH(transaction_date) IN (4, 5) -- for months of April (PM) and May (CM)
GROUP BY
      MONTH(transaction_date)
ORDER BY
       MONTH(transaction_date);
     
SELECT COUNT(transaction_id) AS Total_Orders
FROM coffee_shop_sales
WHERE
MONTH(transaction_date) = 3 -- March Months
      
SELECT 
      MONTH(transaction_date) AS MONTH,
      ROUND(COUNT(transaction_id)) AS total_orders,
      (COUNT(transaction_id) - LAG(COUNT(transaction_id), 1)
      OVER (ORDER BY MONTH(transaction_date))) / LAG(COUNT(transaction_id), 1)
      OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM
    coffee_shop_sales
WHERE
    MONTH(transaction_date) IN (4, 5) -- for April and May
GROUP BY
     MONTH(transaction_date)
ORDER BY
      MONTH(transaction_date);
      
SELECT SUM(transaction_qty) AS Total_Ouantity_Sold
FROM coffee_shop_sales
WHERE
MONTH(transaction_date) = 5 -- May Months
      
SELECT 
     MONTH(transaction_date) AS month,
     ROUND(SUM(transaction_qty)) AS total_quantity_sold,
     (SUM(transaction_qty) - LAG(SUM(transaction_qty), 1)
     OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(transaction_qty), 1)
     OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM
   coffee_shop_sales
WHERE
    MONTH(transaction_date) IN (4, 5) -- FOR April and May
GROUP BY
       MONTH(transaction_date)
ORDER BY 
       MONTH(transaction_date);
    
SELECT 
     CONCAT(ROUND(SUM(unit_price * transaction_qty) / 1000, 1), 'K') AS Total_sales,
     CONCAT(ROUND(SUM(transaction_qty) / 1000, 1), 'K') AS Total_Qty_Sold,
     CONCAT(ROUND(COUNT(transaction_id) / 1000, 1), 'K') AS Total_Orders
FROM coffee_shop_sales
WHERE
    transaction_date = '2023-05-18';
    
-- Weekends - Sat and Sun
-- Weekdays - Monday - Friday

Sun = 1
Mon = 2
.
.
Sat = 7

SELECT
    CASE WHEN DAYOFWEEK(transaction_date) IN (1,7) THEN 'Weekends'
    ELSE 'Weekdays'
    END AS day_type,
    CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,1),'K') As Total_sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5 -- May Month
GROUP BY
	CASE WHEN DAYOFWEEK(transaction_date) IN (1,7) THEN 'Weekends'
    ELSE 'Weekdays'
    END
    
SELECT
     store_location,
     CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,2), 'K') AS Total_sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5 -- May
GROUP BY store_location
ORDER BY SUM(unit_price * transaction_qty) DESC

SELECT 
     CONCAT(ROUND(AVG(total_sales) / 1000, 1), 'K') AS Avg_Sales
FROM
    (
    SELECT SUM(transaction_qty * unit_price) AS total_sales
    FROM coffee_shop_sales
    WHERE MONTH(transaction_date) = 5
    GROUP BY transaction_date
    ) AS Internal_query;
    
SELECT
     DAY(transaction_date) AS day_of_month,
     SUM(unit_price * transaction_qty) as total_sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5
GROUP BY DAY(transaction_date)
ORDER BY DAY(transaction_date)

SELECT 
     day_of_month,
     CASE
         WHEN total_sales > avg_sales THEN 'Above Average'
         WHEN total_sales < avg_sales THEN 'Below Average'
         ELSE 'Equal To Average'
	END AS sales_status,
    total_sales
FROM(
    SELECT
         DAY(transaction_date) AS day_of_month,
         SUM(unit_price * transaction_qty) AS total_sales,
         AVG(SUM(unit_price * transaction_qty)) OVER () AS avg_sales
	FROM
       coffee_shop_sales
	WHERE
        MONTH(transaction_date) = 5 -- Filter for May
	GROUP BY
          DAY(transaction_date)
) AS sales_data
ORDER BY
       day_of_month;

SELECT 
      product_category,
      SUM(unit_price * transaction_qty) AS total_sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5 AND product_category = 'Coffee'
GROUP BY product_type
ORDER BY SUM(unit_price * transaction_qty) DESC
LIMIT 10   

SELECT 
    CASE
      SUM(unit_price * transaction_qty) AS total_sales,
      SUM(transaction_qty) AS Total_qty_sold,
      COUNT(*) AS Total_order
      FROM coffee_shop_sales
      WHERE MONTH(transaction_date) = 5 -- May
      AND DAYOFWEEK(transaction_date) = 2 -- Monday
      AND HOUR(transaction_time) = 14 -- Hour No 14
	
SELECT 
     HOUR(transaction_time),
     SUM(unit_price * transaction_qty) AS total_sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5
GROUP BY HOUR(transaction_time)
ORDER BY HOUR(transaction_time)


SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END AS Day_of_Week,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5 -- Filter for May (month number 5)
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END;

SELECT * from coffee_shop_sales;
describe coffee_shop_sales;