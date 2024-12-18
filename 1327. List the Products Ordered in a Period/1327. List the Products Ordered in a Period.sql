1327. List the Products Ordered in a Period
Easy

SQL Schema
Table: Products

+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| product_id       | int     |
| product_name     | varchar |
| product_category | varchar |
+------------------+---------+
product_id is the primary key for this table.
This table contains data about the companys products.
 

Table: Orders

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| order_date    | date    |
| unit          | int     |
+---------------+---------+
There is no primary key for this table. It may have duplicate rows.
product_id is a foreign key to the Products table.
unit is the number of products ordered in order_date.
 

Write an SQL query to get the names of products that have at least 100 units ordered in February 2020 and their amount.

Return result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Products table:
+-------------+-----------------------+------------------+
| product_id  | product_name          | product_category |
+-------------+-----------------------+------------------+
| 1           | Leetcode Solutions    | Book             |
| 2           | Jewels of Stringology | Book             |
| 3           | HP                    | Laptop           |
| 4           | Lenovo                | Laptop           |
| 5           | Leetcode Kit          | T-shirt          |
+-------------+-----------------------+------------------+
Orders table:
+--------------+--------------+----------+
| product_id   | order_date   | unit     |
+--------------+--------------+----------+
| 1            | 2020-02-05   | 60       |
| 1            | 2020-02-10   | 70       |
| 2            | 2020-01-18   | 30       |
| 2            | 2020-02-11   | 80       |
| 3            | 2020-02-17   | 2        |
| 3            | 2020-02-24   | 3        |
| 4            | 2020-03-01   | 20       |
| 4            | 2020-03-04   | 30       |
| 4            | 2020-03-04   | 60       |
| 5            | 2020-02-25   | 50       |
| 5            | 2020-02-27   | 50       |
| 5            | 2020-03-01   | 50       |
+--------------+--------------+----------+
Output: 
+--------------------+---------+
| product_name       | unit    |
+--------------------+---------+
| Leetcode Solutions | 130     |
| Leetcode Kit       | 100     |
+--------------------+---------+
Explanation: 
Products with product_id = 1 is ordered in February a total of (60 + 70) = 130.
Products with product_id = 2 is ordered in February a total of 80.
Products with product_id = 3 is ordered in February a total of (2 + 3) = 5.
Products with product_id = 4 was not ordered in February 2020.
Products with product_id = 5 is ordered in February a total of (50 + 50) = 100.


1. Solution with Join & GROUP BY with Runtime 762 ms (Beats 60.75%):

SELECT 
    p.product_name,
    SUM(o.unit) AS unit
FROM products p JOIN Orders o ON p.product_id = o.product_id
WHERE o.order_date >= '2020-02-01' AND o.order_date <= '2020-02-29'
GROUP BY p.product_id
HAVING unit >= 100;

	- Time complexity: O(N * M), here N = numbers of products, M = number of orders
	- Space complexity: O(N + M + G), G = numbers of total unique products on orders table after satisfying WHERE condition 
	
2. Solution with Join, CTE & Window function with Runtime 763 ms (Beats 60.43%):

WITH filtered_Order AS (
    SELECT 
        o.product_id,
        SUM(o.unit) OVER (PARTITION BY o.product_id) AS total,
        ROW_NUMBER() OVER (PARTITION BY o.product_id ORDER BY o.product_id) AS rn
    FROM Orders o 
    WHERE o.order_date >= '2020-02-01' 
          AND o.order_date <= '2020-02-29'
)
SELECT 
    p.product_name,
    r.total AS unit
FROM filtered_Order r
JOIN products p ON p.product_id = r.product_id
WHERE r.rn = 1 
  AND r.total >= 100;


	- Time complexity: O(N + M), here N = numbers of products, M = number of orders
	- Space complexity: O(M)
	
	
3. Solution with Join, Sub-query & Group by with Runtime 669 ms (Beats 90.14%):

SELECT 
    p.product_name,
    o.total_units AS unit
FROM products p
JOIN (
    SELECT 
        o.product_id,
        SUM(o.unit) AS total_units
    FROM Orders o
    WHERE o.order_date >= '2020-02-01' 
          AND o.order_date <= '2020-02-29'
    GROUP BY o.product_id
    HAVING SUM(o.unit) >= 100
) o ON p.product_id = o.product_id
ORDER BY p.product_name;

	- Time complexity: O(M log M + N + k + K log K), here N = numbers of products, M = number of orders, K = size of the sub-query result
	- Space complexity: O(K), here K = numbers of unique product_id from sub-query result