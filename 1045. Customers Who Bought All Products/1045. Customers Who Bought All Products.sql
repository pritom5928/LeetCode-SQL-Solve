1045. Customers Who Bought All Products
Medium
SQL Schema
Table: Customer

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| customer_id | int     |
| product_key | int     |
+-------------+---------+
There is no primary key for this table. It may contain duplicates. customer_id is not NULL.
product_key is a foreign key to Product table.
 

Table: Product

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_key | int     |
+-------------+---------+
product_key is the primary key column for this table.
 

Write an SQL query to report the customer ids from the Customer table that bought all the products in the Product table.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Customer table:
+-------------+-------------+
| customer_id | product_key |
+-------------+-------------+
| 1           | 5           |
| 2           | 6           |
| 3           | 5           |
| 3           | 6           |
| 1           | 6           |
+-------------+-------------+
Product table:
+-------------+
| product_key |
+-------------+
| 5           |
| 6           |
+-------------+
Output: 
+-------------+
| customer_id |
+-------------+
| 1           |
| 3           |
+-------------+
Explanation: 
The customers who bought all the products (5 and 6) are customers with IDs 1 and 3.

1. solution Runtime 582ms beats 76.21% MySQL submission:

SELECT 
    c.customer_id
FROM customer c
GROUP BY c.customer_id
HAVING COUNT(DISTINCT c.product_key) = (
        SELECT 
            COUNT(DISTINCT p.product_key)
        FROM 
            product p
);