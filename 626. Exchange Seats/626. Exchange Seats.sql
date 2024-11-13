626. Exchange Seats
Medium

SQL Schema
Table: Seat

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| student     | varchar |
+-------------+---------+
id is the primary key column for this table.
Each row of this table indicates the name and the ID of a student.
id is a continuous increment.
 

Write an SQL query to swap the seat id of every two consecutive students. If the number of students is odd, the id of the last student is not swapped.

Return the result table ordered by id in ascending order.

The query result format is in the following example.

 

Example 1:

Input: 
Seat table:
+----+---------+
| id | student |
+----+---------+
| 1  | Abbot   |
| 2  | Doris   |
| 3  | Emerson |
| 4  | Green   |
| 5  | Jeames  |
+----+---------+
Output: 
+----+---------+
| id | student |
+----+---------+
| 1  | Doris   |
| 2  | Abbot   |
| 3  | Green   |
| 4  | Emerson |
| 5  | Jeames  |
+----+---------+
Explanation: 
Note that if the number of students is odd, there is no need to change the last one's seat.


1. Solution with CTE & Conditional statement with Runtime 325ms Beats 99.10% of MySQL online submissions :


WITH max_cte AS (
	SELECT 
		MAX(Id) AS max_id 
	FROM Seat
)
SELECT 
   IF(Id < (SELECT max_id FROM max_cte), 
		IF(Id%2 = 1, Id+1, Id-1), 
		IF(Id%2 = 1, Id, Id-1)
	 ) AS id,
   student
FROM Seat
ORDER BY Id;


2. Optimal solution for large Datasets by LEFT JOIN with Runtime 325ms Beats 94.02% of MySQL online submissions :

SELECT 
    s.id,
    COALESCE(c.student, s.student) AS student
FROM Seat s 
LEFT JOIN  Seat c 
	ON (s.id % 2 != 0 AND s.id + 1 = c.id) 
    OR (s.id % 2 = 0 AND s.id - 1 = c.id);
	

3.Solution by WINDOW FUNCTION with Runtime 334ms Beats 90.20% of MySQL online submissions:

SELECT 
    CASE 
        WHEN Id < MAX(Id) OVER () THEN 
            CASE 
                WHEN Id % 2 = 1 THEN LEAD(Id) OVER (ORDER BY Id)  
                ELSE LAG(Id) OVER (ORDER BY Id)                  
            END
        ELSE 
            CASE 
                WHEN Id % 2 = 1 THEN Id                         
                ELSE LAG(Id) OVER (ORDER BY Id)                 
            END
    END AS id,
    student
FROM Seat
ORDER BY Id;