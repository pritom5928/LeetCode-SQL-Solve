1204. Last Person to Fit in the Bus
Medium

SQL Schema
Table: Queue

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| person_id   | int     |
| person_name | varchar |
| weight      | int     |
| turn        | int     |
+-------------+---------+
person_id is the primary key column for this table.
This table has the information about all people waiting for a bus.
The person_id and turn columns will contain all numbers from 1 to n, where n is the number of rows in the table.
turn determines the order of which the people will board the bus, where turn=1 denotes the first person to board and turn=n denotes the last person to board.
weight is the weight of the person in kilograms.
 

There is a queue of people waiting to board a bus. However, the bus has a weight limit of 1000 kilograms, so there may be some people who cannot board.

Write an SQL query to find the person_name of the last person that can fit on the bus without exceeding the weight limit. The test cases are generated such that the first person does not exceed the weight limit.

The query result format is in the following example.

 

Example 1:

Input: 
Queue table:
+-----------+-------------+--------+------+
| person_id | person_name | weight | turn |
+-----------+-------------+--------+------+
| 5         | Alice       | 250    | 1    |
| 4         | Bob         | 175    | 5    |
| 3         | Alex        | 350    | 2    |
| 6         | John Cena   | 400    | 3    |
| 1         | Winston     | 500    | 6    |
| 2         | Marie       | 200    | 4    |
+-----------+-------------+--------+------+
Output: 
+-------------+
| person_name |
+-------------+
| John Cena   |
+-------------+
Explanation: The folowing table is ordered by the turn for simplicity.
+------+----+-----------+--------+--------------+
| Turn | ID | Name      | Weight | Total Weight |
+------+----+-----------+--------+--------------+
| 1    | 5  | Alice     | 250    | 250          |
| 2    | 3  | Alex      | 350    | 600          |
| 3    | 6  | John Cena | 400    | 1000         | (last person to board)
| 4    | 2  | Marie     | 200    | 1200         | (cannot board)
| 5    | 4  | Bob       | 175    | ___          |
| 6    | 1  | Winston   | 500    | ___          |
+------+----+-----------+--------+--------------+



1. Solution with WINDOW FUNCTION Runtime 896ms that Beats 65.19% MySQL Submissions:

SELECT 
	person_name
FROM (
	SELECT 
		person_name, SUM(weight) OVER(ORDER BY turn) AS Sum
	FROM queue
) AS Res
WHERE Sum <= 1000
ORDER BY Sum DESC LIMIT 1;


2.Solution with CORRELATED SUB-QUERY & CTE Runtime 1672ms that Beats 30.50% MySQL Submissions:

WITH cte AS (
    SELECT 
        * 
    FROM queue
    ORDER BY turn
)
SELECT 
    person_name
FROM cte AS a
WHERE 1000 >= (
    SELECT 
        SUM(weight) 
    FROM queue AS b 
    WHERE a.turn >= b.turn
)
ORDER BY turn DESC
LIMIT 1;


3. Solution with JOIN & CTE Runtime 1543ms that Beats 35.36% MySQL Submissions:

WITH cte AS (
    SELECT 
        * 
    FROM queue
    ORDER BY turn
)
SELECT 
    a.person_name 
FROM cte a
JOIN queue b ON a.turn >= b.turn
GROUP BY a.person_id
HAVING SUM(b.weight) <= 1000
LIMIT 1;
