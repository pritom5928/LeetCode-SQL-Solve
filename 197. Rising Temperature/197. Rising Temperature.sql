197. Rising Temperature
Easy

SQL Schema
Table: Weather

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| recordDate    | date    |
| temperature   | int     |
+---------------+---------+
id is the primary key for this table.
This table contains information about the temperature on a certain day.
 

Write an SQL query to find all dates' Id with higher temperatures compared to its previous dates (yesterday).

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Weather table:
+----+------------+-------------+
| id | recordDate | temperature |
+----+------------+-------------+
| 1  | 2015-01-01 | 10          |
| 2  | 2015-01-02 | 25          |
| 3  | 2015-01-03 | 20          |
| 4  | 2015-01-04 | 30          |
+----+------------+-------------+
Output: 
+----+
| id |
+----+
| 2  |
| 4  |
+----+
Explanation: 
In 2015-01-02, the temperature was higher than the previous day (10 -> 25).
In 2015-01-04, the temperature was higher than the previous day (20 -> 30).


1. Naive Solution with correlated sub-query with TC O(N^2) => Runtime 1016ms (Beats 7.89%) and SC=> O(1): 

SELECT 
    id
FROM weather w
WHERE w.temperature > (
        SELECT 
            w1.temperature
        FROM weather w1
        WHERE DATE_SUB(w.recorddate, INTERVAL 1 DAY) = w1.recorddate
    );


2. Optimal Solution with CROSS JOIN with TC O(N^2)=> Runtime 467ms (Beats 42.02%) and SC=> O(N^2):

SELECT 
	w1.id 
FROM Weather w1, Weather w2 
WHERE w1.Temperature > w2.Temperature 
    AND DATEDIFF(w1.recorddate, w2.recorddate) = 1;
	
3. Super Optimal solution with Window function & CTE with TC O(n log n)=> Runtime 320ms (Beats 93.69%) and SC=> O(N):
WITH cte AS (
    SELECT 
        w.*, 
        LAG(recorddate) OVER (ORDER BY recorddate) AS prev_date, 
        LAG(temperature) OVER (ORDER BY recorddate) AS prev_temp
    FROM  weather w
)
SELECT 
    id
FROM cte c
WHERE DATEDIFF(c.recorddate, c.prev_date) = 1 AND c.temperature > c.prev_temp;