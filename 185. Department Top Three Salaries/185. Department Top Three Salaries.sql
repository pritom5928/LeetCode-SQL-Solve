185. Department Top Three Salaries
Hard

SQL Schema
Table: Employee

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| id           | int     |
| name         | varchar |
| salary       | int     |
| departmentId | int     |
+--------------+---------+
id is the primary key column for this table.
departmentId is a foreign key of the ID from the Department table.
Each row of this table indicates the ID, name, and salary of an employee. It also contains the ID of their department.
 

Table: Department

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
+-------------+---------+
id is the primary key column for this table.
Each row of this table indicates the ID of a department and its name.
 

A company's executives are interested in seeing who earns the most money in each of the company's departments. A high earner in a department is an employee who has a salary in the top three unique salaries for that department.

Write an SQL query to find the employees who are high earners in each of the departments.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Employee table:
+----+-------+--------+--------------+
| id | name  | salary | departmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 85000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
| 5  | Janet | 69000  | 1            |
| 6  | Randy | 85000  | 1            |
| 7  | Will  | 70000  | 1            |
+----+-------+--------+--------------+
Department table:
+----+-------+
| id | name  |
+----+-------+
| 1  | IT    |
| 2  | Sales |
+----+-------+
Output: 
+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| IT         | Joe      | 85000  |
| IT         | Randy    | 85000  |
| IT         | Will     | 70000  |
| Sales      | Henry    | 80000  |
| Sales      | Sam      | 60000  |
+------------+----------+--------+
Explanation: 
In the IT department:
- Max earns the highest unique salary
- Both Randy and Joe earn the second-highest unique salary
- Will earns the third-highest unique salary

In the Sales department:
- Henry earns the highest salary
- Sam earns the second-highest salary
- There is no third-highest salary as there are only two employees



Formula: COUNT(DISTINCT(outer query value < inner query value)) ==> THIS FORMULA, mainly defines
 that how many values from inner query is greater than the each iteration of outer query.

1. Solution by Correlated Subquery that runtime 1226ms beats 35.78% MySQL online submissions :

	- Time complexity: O(n*mlogm)
	- Space complexity: O(m)

SELECT 
    d.name AS Department,
    e1.name AS Employee,
    e1.salary AS Salary
FROM employee e1 JOIN department d ON e1.DepartmentId = d.id
WHERE 3 > (SELECT COUNT(distinct(salary)) FROM employee e2 
			WHERE e1.DepartmentId = e2.DepartmentId AND e1.Salary < e2.salary
		  )
		  


2.  Solution by Window function that runtime 826ms beats 97.79% MySQL online submissions :

	- Time complexity: O(n log m)
	- Space complexity: O(n)

SELECT 
    res.Department,
    res.Employee,
    res.salary
FROM (
    SELECT 
        b.name AS Department,
        a.name AS Employee,
        a.salary,
        DENSE_RANK() OVER (
            PARTITION BY a.departmentid 
            ORDER BY a.salary DESC
        ) AS rnk
    FROM employee a 
    JOIN Department b 
    ON  a.departmentid = b.id
) res
WHERE res.rnk <= 3;