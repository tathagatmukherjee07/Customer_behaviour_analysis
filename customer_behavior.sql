CREATE DATABASE customer_behavior;
USE customer_behavior;
SELECT * FROM customer LIMIT 20;

-- Q1. Total revenue gennerated by male and female customer 
SELECT gender, SUM(purchase_amount) AS revenue
FROM customer
GROUP BY gender;


-- Q2. which customer used an discount but still spends more than average purchase amount?
SELECT customer_id, purchase_amount
FROM customer
WHERE discount_applied = 'Yes' AND purchase_amount >= (SELECT AVG(purchase_amount) FROM customer);

-- Q3. Which are the top 5 products with average highest review rating?
SELECT item_purchased, AVG(review_rating) as "Average Product Rating"
FROM customer
GROUP BY item_purchased
ORDER BY AVG(review_rating) DESC
LIMIT 5;


-- Q4. Compare the average Purchase Amounts between Standard and Express Shipping.
SELECT shipping_type,
ROUND(AVG(purchase_amount),2)
FROM customer 
WHERE shipping_type IN ('Standard', 'Express')
GROUP BY shipping_type;

-- Q5. Do subscribed customers spend more? Compare average spend and total revenue --between subscribers and non-subscribers
SELECT subscription_status,
COUNT(customer_id) AS total_customers,
ROUND(AVG(purchase_amount),2) AS avg_spend,
ROUND(SUM(purchase_amount)) AS total_revenue
FROM customer
GROUP BY subscription_status
ORDER BY total_revenue, avg_spend DESC;



-- Q6. Which 5 products have the highest percentage of purchases with discounts applied?
SELECT item_purchased,
ROUND(SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)/COUNT(*) * 100, 2) as discount_rate
FROM customer
GROUP BY item_purchased
ORDER By discount_rate DESC;



-- Q7. Segment customers into New, Returning, and Loyal based on their total number of previous purchases, and show the count of each segment.
WITH customer_type AS (
SELECT customer_id, previous_purchases,
CASE WHEN previous_purchases = '1' THEN 'new'
WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
ELSE 'Loyal'
END AS customer_segment
FROM customer
)

SELECT customer_segment, COUNT(*) as 'Number of Customers'
FROM customer_type
GROUP By customer_segment;



-- What are the top 3 most purchased product in each category?
WITH item_counts AS(
SELECt category, item_purchased,
COUNT(customer_id) AS total_orders,
ROW_NUMBER() OVER(PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS item_rank
FROM customer
GROUP BY category, item_purchased
)

SELECt item_rank, category, item_purchased, total_orders
FROM item_counts
WHERE item_rank<=3; 



-- Q9. Are customer's who are repeat buyers (more than 5 previous purchases) also likely to subscribe?
SELECT subscription_status,
COUNT(customer_id) AS repeat_buyers
FROM customer
WHERE previous_purchases > 5
GROUP BY subscription_status;



-- What is the revenue contribution by each age group
SELECT age_group,
SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY age_group
ORDER BY total_revenue DESC

