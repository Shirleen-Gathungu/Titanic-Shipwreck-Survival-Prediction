USE restaurant_db;
SHOW TABLES;

#finding the number of items in the menu_items table

DESCRIBE menu_items;

SELECT COUNT(DISTINCT item_name) FROM menu_items;

# What are the least and most expensive items on the menu?
SELECT MIN(price) FROM menu_items;
SELECT MAX(price) FROM menu_items;

SELECT item_name
FROM menu_items
WHERE price = (SELECT MIN(price) FROM menu_items);


SELECT item_name
FROM menu_items
WHERE price = (SELECT MAX(price) FROM menu_items);


# How many Italian dishes are on the menu? What are the least and most expensive Italian dishes on the menu?

SELECT COUNT(item_name) FROM menu_items WHERE category = 'Italian';

#least expensive dish
SELECT item_name, price
FROM menu_items
WHERE category = 'Italian'
ORDER BY price
LIMIT 1;

#most expensive dish
SELECT item_name, price
FROM menu_items
WHERE category = 'Italian'
ORDER BY price DESC
LIMIT 1;



# How many dishes are in each category? What is the average dish price within each category?
SELECT category, COUNT(*) AS dish_count
FROM menu_items
GROUP BY category;

SELECT category, AVG(price)  
FROM menu_items 
GROUP BY category;


# order_details table
DESCRIBE order_details;

# What is the date range of the table?
SELECT
    MIN(order_date) AS min_date,
    MAX(order_date) AS max_date
   --  MAX(order_date) - MIN(order_date) AS date_range
FROM
    order_details;



# How many orders were made within this date range? How many items were ordered within this date range?
SELECT 
    COUNT(order_id) AS total_orders,
    COUNT(order_details_id) AS total_order_details
FROM 
    order_details
WHERE 
    order_date BETWEEN (SELECT MIN(order_date) FROM order_details) AND (SELECT MAX(order_date) FROM order_details);


# Which orders had the most number of items?

WITH OrderItemsCount AS (
    SELECT 
        order_id,
        COUNT(order_details_id) AS total_items
    FROM 
        order_details
    GROUP BY 
        order_id
)
SELECT 
    order_id,
    total_items
FROM 
    OrderItemsCount
WHERE 
    total_items = (SELECT MAX(total_items) FROM OrderItemsCount);



# How many orders had more than 12 items?
SELECT order_id, COUNT(order_details_id) AS total_items
FROM order_details
GROUP BY order_id
HAVING total_items > 12;


#Combining menu_items and order_details

SELECT *
FROM menu_items
CROSS JOIN order_details;


# What were the least and most ordered items? What categories were they in?
SELECT item_name,category,COUNT(order_details_id) AS total_purchases
FROM order_details od LEFT JOIN menu_items mi
	ON od.item_id = mi.menu_item_id
GROUP BY item_name,category
ORDER BY total_purchases DESC	

# What were the top 5 orders that spent the most money?

SELECT *
FROM order_details od LEFT JOIN menu_items mi ON od.item_id = mi.menu_item_id
LIMIT 100 OFFSET 0;


SELECT order_id , SUM(price) AS total_spend
FROM order_details od LEFT JOIN menu_items mi 
	ON od.item_id = mi.menu_item_id
GROUP BY order_id
ORDER BY total_spend DESC
LIMIT 5 ;


# View the details of the highest spend order. What insights can you gather from it ?
SELECT category, COUNT(item_id) AS num_items
FROM order_details od LEFT JOIN menu_items mi 
	ON od.item_id = mi.menu_item_id
WHERE order_id = 440
GROUP BY category;


#  View the details of the top 5 highest spend orders. What Insight can you gather from here?

SELECT order_id, category, COUNT(item_id) AS num_items
FROM order_details od LEFT JOIN menu_items mi 
	ON od.item_id = mi.menu_item_id
WHERE order_id IN (440,2075,1957,330,2675)
GROUP BY order_id, category;

