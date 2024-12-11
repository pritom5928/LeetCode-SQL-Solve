180. Consecutive Numbers
Medium


SQL Schema
Table: Logs

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| num         | varchar |
+-------------+---------+
id is the primary key for this table.
id is an autoincrement column.
 

Write an SQL query to find all numbers that appear at least three times consecutively.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Logs table:
+----+-----+
| id | num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+
Output: 
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
Explanation: 1 is the only number that appears consecutively for at least three times.



1. Solution with Cross Join with Runtime 733ms (Beats 20.59%): 

	- Time complexity: O(N^3)
	- Space complexity: O(N^3)

SELECT 
	DISTINCT(l1.Num) AS ConsecutiveNums
FROM Logs l1, Logs l2, Logs l3 
WHERE (l2.id = l1.id+1 AND l3.id = l2.id+1) AND (l1.num = l2.num AND l1.num = l3.num);


2. Solution with Self Join Runtime 579ms (Beats 64.83%):

	- Time complexity: O(N^2)
	- Space complexity: O(N^2)

SELECT 
	DISTINCT l1.Num AS ConsecutiveNums
FROM Logs l1
JOIN Logs l2 ON l2.id = l1.id + 1
JOIN Logs l3 ON l3.id = l2.id + 1
WHERE l1.num = l2.num AND l1.num = l3.num;