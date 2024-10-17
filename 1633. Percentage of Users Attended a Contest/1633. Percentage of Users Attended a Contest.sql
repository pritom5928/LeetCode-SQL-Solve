1633. Percentage of Users Attended a Contest

Easy
SQL Schema
Table: Users

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| user_name   | varchar |
+-------------+---------+
user_id is the primary key for this table.
Each row of this table contains the name and the id of a user.
 

Table: Register

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| contest_id  | int     |
| user_id     | int     |
+-------------+---------+
(contest_id, user_id) is the primary key for this table.
Each row of this table contains the id of a user and the contest they registered into.
 

Write an SQL query to find the percentage of the users registered in each contest rounded to two decimals.

Return the result table ordered by percentage in descending order. In case of a tie, order it by contest_id in ascending order.

The query result format is in the following example.

 

Example 1:

Input: 
Users table:
+---------+-----------+
| user_id | user_name |
+---------+-----------+
| 6       | Alice     |
| 2       | Bob       |
| 7       | Alex      |
+---------+-----------+
Register table:
+------------+---------+
| contest_id | user_id |
+------------+---------+
| 215        | 6       |
| 209        | 2       |
| 208        | 2       |
| 210        | 6       |
| 208        | 6       |
| 209        | 7       |
| 209        | 6       |
| 215        | 7       |
| 208        | 7       |
| 210        | 2       |
| 207        | 2       |
| 210        | 7       |
+------------+---------+
Output: 
+------------+------------+
| contest_id | percentage |
+------------+------------+
| 208        | 100.0      |
| 209        | 100.0      |
| 210        | 100.0      |
| 215        | 66.67      |
| 207        | 33.33      |
+------------+------------+
Explanation: 
All the users registered in contests 208, 209, and 210. The percentage is 100% and we sort them in the answer table by contest_id in ascending order.
Alice and Alex registered in contest 215 and the percentage is ((2/3) * 100) = 66.67%
Bob registered in contest 207 and the percentage is ((1/3) * 100) = 33.33%


1. Solution with Aggregate function Runtime 1417 ms Beats 97.93% MySQL Submission:

WITH CTE AS (
	SELECT 
		COUNT(*) AS  TotalUser
	FROM Users
)
SELECT 
	contest_id,
    ROUND((COUNT(user_id) / (SELECT TotalUser FROM CTE)) * 100, 2) AS percentage
FROM Register
GROUP BY contest_id
ORDER BY percentage DESC, contest_id;




2. Optimal solution with Window function Runtime 1555 ms Beats 90.22% MySQL Submission:

WITH CTE AS (
	SELECT 
		COUNT(*) AS  TotalUser
	FROM Users
)

SELECT 
	DISTINCT contest_id,
	ROUND( (COUNT(*) OVER(PARTITION BY contest_id) / (SELECT TotalUser FROM CTE)) * 100, 2) AS  percentage
FROM  Register
ORDER BY percentage DESC, contest_id;


3. Another solution by JOIN & Subquery Runtime 934 ms (Beats 62.66%) MySQL Submission:

SELECT 
    DISTINCT r.contest_id,
    ROUND(
        COUNT(u.user_id) OVER (PARTITION BY r.contest_id) 
        / (SELECT COUNT(DISTINCT user_id) FROM users) * 100, 
    2) AS percentage 
FROM users u 
LEFT JOIN register r 
    ON u.user_id = r.user_id
WHERE r.contest_id IS NOT NULL
ORDER BY percentage DESC, r.contest_id ASC;
