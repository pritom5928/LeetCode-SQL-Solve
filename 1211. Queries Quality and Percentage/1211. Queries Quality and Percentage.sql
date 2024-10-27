1211. Queries Quality and Percentage
Easy
SQL Schema
Table: Queries

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| query_name  | varchar |
| result      | varchar |
| position    | int     |
| rating      | int     |
+-------------+---------+
There is no primary key for this table, it may have duplicate rows.
This table contains information collected from some queries on a database.
The position column has a value from 1 to 500.
The rating column has a value from 1 to 5. Query with rating less than 3 is a poor query.
 

We define query quality as:

The average of the ratio between query rating and its position.

We also define poor query percentage as:

The percentage of all queries with rating less than 3.

Write an SQL query to find each query_name, the quality and poor_query_percentage.

Both quality and poor_query_percentage should be rounded to 2 decimal places.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Queries table:
+------------+-------------------+----------+--------+
| query_name | result            | position | rating |
+------------+-------------------+----------+--------+
| Dog        | Golden Retriever  | 1        | 5      |
| Dog        | German Shepherd   | 2        | 5      |
| Dog        | Mule              | 200      | 1      |
| Cat        | Shirazi           | 5        | 2      |
| Cat        | Siamese           | 3        | 3      |
| Cat        | Sphynx            | 7        | 4      |
+------------+-------------------+----------+--------+
Output: 
+------------+---------+-----------------------+
| query_name | quality | poor_query_percentage |
+------------+---------+-----------------------+
| Dog        | 2.50    | 33.33                 |
| Cat        | 0.66    | 33.33                 |
+------------+---------+-----------------------+
Explanation: 
Dog queries quality is ((5 / 1) + (5 / 2) + (1 / 200)) / 3 = 2.50
Dog queries poor_ query_percentage is (1 / 3) * 100 = 33.33

Cat queries quality equals ((2 / 5) + (3 / 3) + (4 / 7)) / 3 = 0.66
Cat queries poor_ query_percentage is (1 / 3) * 100 = 33.33


1. Faster Solution with CTE & JOIN Runtime 1136 ms Beats 81.63% :

WITH CTE AS(
	SELECT 
		query_name AS QueryName,
        COUNT(*) AS PoorCount
    FROM Queries
    WHERE rating < 3
	GROUP BY query_name
)
SELECT 
    a.query_name,
    ROUND(SUM((rating/position))/COUNT(*), 2) AS quality,
    IFNULL( ROUND(b.PoorCount / COUNT(*) * 100, 2), 0) AS poor_query_percentage 
FROM Queries a LEFT JOIN CTE b 
ON a.query_name = b.QueryName
GROUP BY a.query_name;

Time Complexity: O(nlogn)
Space Complexity: O(g) where g < n; n = number of rows

2. Solution with AVG clause Runtime 1565 ms Beats 11.51%: 

SELECT 
	query_name,
    ROUND(AVG(rating/position), 2) AS quality ,
    ROUND(AVG(rating < 3) * 100, 2) AS poor_query_percentage 
FROM queries
GROUP BY query_name;

Time Complexity: O(nlogn)
Space Complexity: O(g) where g < n; n = number of rows

3. Solution by window function Runtime 399 ms Beats 55.59%: 

SELECT 
    res.query_name,
    ROUND(AVG(avg_qua), 2) AS quality,
    poor_query_percentage 
FROM (
    SELECT 
        m.*,
        rating / position AS avg_qua,
        ROUND(
            (SUM(IF(rating < 3, 1, 0)) OVER (PARTITION BY query_name) 
             / COUNT(*) OVER (PARTITION BY query_name)) * 100, 2
        ) AS poor_query_percentage
    FROM queries m
) AS res
WHERE res.query_name IS NOT NULL
GROUP BY res.query_name;

Time Complexity: O(nlogk)
Space Complexity: O(n)


