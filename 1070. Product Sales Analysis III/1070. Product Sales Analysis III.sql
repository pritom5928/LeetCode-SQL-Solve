1070. Product Sales Analysis III
Medium

Companies
SQL Schema
Table: Sales

+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| sale_id     | int   |
| product_id  | int   |
| year        | int   |
| quantity    | int   |
| price       | int   |
+-------------+-------+
(sale_id, year) is the primary key of this table.
product_id is a foreign key to Product table.
Each row of this table shows a sale on the product product_id in a certain year.
Note that the price is per unit.
 

Table: Product

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
+--------------+---------+
product_id is the primary key of this table.
Each row of this table indicates the product name of each product.
 

Write an SQL query that selects the product id, year, quantity, and price for the first year of every product sold.

Return the resulting table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Sales table:
+---------+------------+------+----------+-------+
| sale_id | product_id | year | quantity | price |
+---------+------------+------+----------+-------+ 
| 1       | 100        | 2008 | 10       | 5000  |
| 2       | 100        | 2009 | 12       | 5000  |
| 7       | 200        | 2011 | 15       | 9000  |
+---------+------------+------+----------+-------+
Product table:
+------------+--------------+
| product_id | product_name |
+------------+--------------+
| 100        | Nokia        |
| 200        | Apple        |
| 300        | Samsung      |
+------------+--------------+
Output: 
+------------+------------+----------+-------+
| product_id | first_year | quantity | price |
+------------+------------+----------+-------+ 
| 100        | 2008       | 10       | 5000  |
| 200        | 2011       | 15       | 9000  |
+------------+------------+----------+-------+



1. Solution with GROUP BY & Sub-query with 1080 ms Runtime Beats 66.61% MySQL Submission:

SELECT 
    product_id,
    year AS first_year,
    quantity ,
    price
FROM sales 
WHERE (product_id, year) IN (
        SELECT 
            product_id,
            MIN(year) AS first_year
        FROM sales
        GROUP BY product_id
);

	- Time Complexity: O(n log n) + O(N*M) (with indexing optimizations)
	- Space Complexity: O(m)

2. Solution with Window function with 1094 ms Runtime Beats 63.36% MySQL Submission:


SELECT 
    res.product_id,
    res.min_year AS first_year,
    res.quantity,
    res.price
FROM (
    SELECT 
        a.*,
        MIN(year) OVER (PARTITION BY product_id) AS min_year
    FROM sales a
) res
WHERE res.year = res.min_year;


	- Time Complexity: O(n log n)
	- Space Complexity: O(n)

3. Solution with CTE & JOIN with 1091ms Runtime Beats 64.01% MySQL Submission:

WITH min_year_cte AS (
    SELECT 
        product_id,
        MIN(year) AS min_year
    FROM sales
    GROUP BY product_id
)
SELECT 
    s.product_id,
    my.min_year AS first_year,
    s.quantity,
    s.price
FROM sales s
JOIN min_year_cte my ON s.product_id = my.product_id AND s.year = my.min_year;


	- Time Complexity: O(n)
	- Space Complexity: O(n)
