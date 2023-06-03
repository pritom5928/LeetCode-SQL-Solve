1435. Create a Session Bar Chart
SQL Schema 

Difficulty: Easy

Table: Sessions

+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| session_id          | int     |
| duration            | int     |
+---------------------+---------+
session_id is the primary key for this table.
duration is the time in seconds that a user has visited the application.
 

You want to know how long a user visits your application. You decided to create bins of "[0-5>", "[5-10>", "[10-15>" and "15 minutes or more" and count the number of sessions on it.

Write an SQL query to report the (bin, total) in any order.

The query result format is in the following example.

Sessions table:
+-------------+---------------+
| session_id  | duration      |
+-------------+---------------+
| 1           | 30            |
| 2           | 299           |
| 3           | 340           |
| 4           | 580           |
| 5           | 1000          |
+-------------+---------------+

Result table:
+--------------+--------------+
| bin          | total        |
+--------------+--------------+
| [0-5>        | 3            |
| [5-10>       | 1            |
| [10-15>      | 0            |
| 15 or more   | 1            |
+--------------+--------------+

For session_id 1, 2 and 3 have a duration greater or equal than 0 minutes and less than 5 minutes.
For session_id 4 has a duration greater or equal than 5 minutes and less than 10 minutes.
There are no session with a duration greater or equial than 10 minutes and less than 15 minutes.
For session_id 5 has a duration greater or equal than 15 minutes.


Solution with UNION & CTE:

WITH CTE AS(
	SELECT 
		*
	FROM Sessions
)
SELECT 
	'[0-5>' AS bin,
    COUNT(duration) AS total
FROM CTE
WHERE ROUND(duration/60, 2) >= 0 AND ROUND(duration/60, 2)<5
UNION
SELECT 
	'[5-10>' AS bin,
    COUNT(duration) AS total
FROM CTE
WHERE ROUND(duration/60, 2) >= 5 AND ROUND(duration/60, 2)<10
UNION
SELECT 
	'[10-15>' AS bin,
    COUNT(duration) AS total
FROM CTE
WHERE ROUND(duration/60, 2) >= 10 AND ROUND(duration/60, 2)<15
UNION
SELECT 
	'15 or more' AS bin,
    COUNT(duration) AS total
FROM CTE
WHERE ROUND(duration/60, 2) >= 15;