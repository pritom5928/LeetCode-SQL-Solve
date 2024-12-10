176. Second Highest Salary
Medium


Add to List

Share
SQL Schema
Table: Employee

+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| salary      | int  |
+-------------+------+
id is the primary key column for this table.
Each row of this table contains information about the salary of an employee.
 

Write an SQL query to report the second highest salary from the Employee table. If there is no second highest salary, the query should report null.

The query result format is in the following example.

 

Example 1:

Input: 
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
Output: 
+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+
Example 2:

Input: 
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
+----+--------+
Output: 
+---------------------+
| SecondHighestSalary |
+---------------------+
| null                |
+---------------------+


1. Naive solution with Window function with Runtime 255ms (Beats 91.73%):

SELECT 
	salary as SecondHighestSalary
FROM (
    SELECT 
        e.*,
        DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM employee e
) res
WHERE res.rnk = 2
UNION ALL
SELECT NULL
WHERE NOT EXISTS (
    SELECT 1
    FROM (
        SELECT 
            e.*,
            RANK() OVER (ORDER BY salary DESC) AS rnk
        FROM employee e
    ) res
    WHERE res.rnk = 2
)
LIMIT 1;

	- Time complexity: O(N log N)
	- Space complexityL: O(N)

solution: 


SELECT IFNULL((SELECT DISTINCT(Salary) FROM employee ORDER BY Salary DESC LIMIT 1, 1), null) as SecondHighestSalary ;

