1164. Product Price at a Given Date
Medium

Companies
SQL Schema
Table: Products

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| new_price     | int     |
| change_date   | date    |
+---------------+---------+
(product_id, change_date) is the primary key of this table.
Each row of this table indicates that the price of some product was changed to a new price at some date.
 

Write an SQL query to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Products table:
+------------+-----------+-------------+
| product_id | new_price | change_date |
+------------+-----------+-------------+
| 1          | 20        | 2019-08-14  |
| 2          | 50        | 2019-08-14  |
| 1          | 30        | 2019-08-15  |
| 1          | 35        | 2019-08-16  |
| 2          | 65        | 2019-08-17  |
| 3          | 20        | 2019-08-18  |
+------------+-----------+-------------+
Output: 
+------------+-------+
| product_id | price |
+------------+-------+
| 2          | 50    |
| 1          | 35    |
| 3          | 10    |
+------------+-------+



1. Naive solution with Correlated subquery with Runtime 2463 ms beats 5.4% MySQL Online submission:

SELECT 
    DISTINCT a.product_id,
    IF(b.new_price IS NULL, 10, b.new_price) AS price
FROM products a LEFT JOIN (
	SELECT 
	p.product_id,
        p.new_price
    FROM products p 
	WHERE p.change_date >= (
		SELECT 
			MAX(p1.change_date) 
		FROM products p1
		WHERE p1.product_id = p.product_id and p1.change_date <= '2019-08-16'
    ) AND p.change_date <= '2019-08-16'
) AS b ON a.product_id = b.product_id;



2. More optimal solution with JOIN, Subquery & UNION with Runtime 994 ms Beats 38.70% MySQL Online submission:

SELECT 
     product_id, 
     10 AS price
FROM Products
GROUP BY product_id
HAVING (MIN(change_date) > '2019-08-16')
UNION
SELECT
	product_id,
    new_price AS price
FROM products WHERE (product_id, change_date) IN (
	SELECT 
		product_id,
        MAX(change_date) AS change_date
	FROM Products
	WHERE change_date <= '2019-08-16'
	GROUP BY product_id
) ;


3. Solution with Subquery & JOIN with Runtime 553 ms Beats 51.46% MySQL Online submission:

WITH filtered_date AS (
    SELECT 
        product_id,
        new_price,
        change_date
    FROM products 
    WHERE (product_id, change_date) IN (
        SELECT 
            product_id,
            MAX(change_date)
        FROM products
        WHERE change_date <= '2019-08-16'
        GROUP BY product_id
    )
),
all_ids AS (
    SELECT DISTINCT 
        product_id
    FROM products
)
SELECT 
    a.product_id,
    IF(b.new_price IS NULL, 10, b.new_price) AS price
FROM all_ids a
LEFT JOIN filtered_date b ON a.product_id = b.product_id

