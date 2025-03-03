1731. The Number of Employees Which Report to Each Employee
Easy
Topics
Companies
SQL Schema
Pandas Schema
Table: Employees

+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| employee_id | int      |
| name        | varchar  |
| reports_to  | int      |
| age         | int      |
+-------------+----------+
employee_id is the column with unique values for this table.
This table contains information about the employees and the id of the manager they report to. Some employees do not report to anyone (reports_to is null). 
 

For this problem, we will consider a manager an employee who has at least 1 other employee reporting to them.

Write a solution to report the ids and the names of all managers, the number of employees who report directly to them, and the average age of the reports rounded to the nearest integer.

Return the result table ordered by employee_id.

The result format is in the following example.

 

Example 1:

Input: 
Employees table:
+-------------+---------+------------+-----+
| employee_id | name    | reports_to | age |
+-------------+---------+------------+-----+
| 9           | Hercy   | null       | 43  |
| 6           | Alice   | 9          | 41  |
| 4           | Bob     | 9          | 36  |
| 2           | Winston | null       | 37  |
+-------------+---------+------------+-----+
Output: 
+-------------+-------+---------------+-------------+
| employee_id | name  | reports_count | average_age |
+-------------+-------+---------------+-------------+
| 9           | Hercy | 2             | 39          |
+-------------+-------+---------------+-------------+
Explanation: Hercy has 2 people report directly to him, Alice and Bob. Their average age is (41+36)/2 = 38.5, which is 39 after rounding it to the nearest integer.


1. Solution with simple INNER JOIN & GROUP BY Runtime 987ms Beats 94.03% of MySQL Submissions:

select 
	e1.employee_id,
    e1.name,
    count(*) as reports_count ,
    round(avg(e2.age)) as average_age 
from Employees e1 join Employees e2 on e1.employee_id = e2.reports_to
group by e1.employee_id
order by e1.employee_id

	- Time Complexity: Without indexing, O(n^2); with indexing on reports_to, O(n log n).
	- Space Complexity: O(n).
 
2. Optimal solution with CTE & JOIN  Runtime 619ms Beats 89.28% of MySQL Submissions:

WITH reporting_summary AS (
    SELECT 
        e.reports_to,
        COUNT(*) AS reports_count,
        ROUND(AVG(age)) AS average_age
    FROM employees e
    GROUP BY e.reports_to
    HAVING e.reports_to IS NOT NULL
)
SELECT 
    e.employee_id,
    e.name,
    r.reports_count,
    r.average_age
FROM employees e 
JOIN reporting_summary r 
ON e.employee_id = r.reports_to
ORDER BY e.employee_id; 

	- Time Complexity: Without indexing, O(n^2); with indexing on reports_to, O(n log n).
	- Space Complexity: O(n).


3. Solution with WINDOW function & JOIN Runtime 651ms Beats 79.57% of MySQL Submissions:

SELECT 
	DISTINCT m.employee_id,
    m.name,
    n.reports_count,
    n.average_age
FROM employees m
JOIN (
    SELECT 
        DISTINCT e.reports_to,
        COUNT(1) OVER w AS reports_count,
        ROUND(AVG(age) OVER w) AS average_age
    FROM employees e
    WHERE e.reports_to IS NOT NULL
    WINDOW w AS (PARTITION BY e.reports_to)
) n ON m.employee_id = n.reports_to
ORDER BY m.employee_id;

	- Time Complexity: Without indexing, O(n^2); with indexing on reports_to, O(n log n).
	- Space Complexity: O(n).

4. Solution with Correlated Subquery Runtime 1115ms Beats 9.68% of MySQL Submissions:

SELECT 
    m.employee_id,
    m.name,
    (SELECT 
            COUNT(*)
        FROM employees p
        WHERE p.reports_to = m.employee_id
	) AS reports_count,
    ROUND(
		(SELECT 
			AVG(p.age)
         FROM employees p
         WHERE p.reports_to = m.employee_id)
	) AS average_age
FROM
    employees m
WHERE EXISTS(
		SELECT 
            1
        FROM employees n
        WHERE n.reports_to = m.employee_id
	)
ORDER BY m.employee_id;

	- Time Complexity: O(n^2)
	- Space Complexity: O(n).