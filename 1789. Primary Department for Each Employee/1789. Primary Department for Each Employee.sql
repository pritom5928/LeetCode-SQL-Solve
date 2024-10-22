1789. Primary Department for Each Employee
Table: Employee

+---------------+---------+
| Column Name   |  Type   |
+---------------+---------+
| employee_id   | int     |
| department_id | int     |
| primary_flag  | varchar |
+---------------+---------+
(employee_id, department_id) is the primary key (combination of columns with unique values) for this table.
employee_id is the id of the employee.
department_id is the id of the department to which the employee belongs.
primary_flag is an ENUM (category) of type ('Y', 'N'). If the flag is 'Y', the department is the primary department for the employee. 
If the flag is 'N', the department is not the primary.
 

Employees can belong to multiple departments. When the employee joins other departments, they need to decide which department is
 their primary department. Note that when an employee belongs to only one department, their primary column is 'N'.

Write a solution to report all the employees with their primary department. For employees who belong to one department, 
report their only department.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Employee table:
+-------------+---------------+--------------+
| employee_id | department_id | primary_flag |
+-------------+---------------+--------------+
| 1           | 1             | N            |
| 2           | 1             | Y            |
| 2           | 2             | N            |
| 3           | 3             | N            |
| 4           | 2             | N            |
| 4           | 3             | Y            |
| 4           | 4             | N            |
+-------------+---------------+--------------+
Output: 
+-------------+---------------+
| employee_id | department_id |
+-------------+---------------+
| 1           | 1             |
| 2           | 1             |
| 3           | 3             |
| 4           | 3             |
+-------------+---------------+
Explanation: 
- The Primary department for employee 1 is 1.
- The Primary department for employee 2 is 1.
- The Primary department for employee 3 is 3.
- The Primary department for employee 4 is 3.


1. Solution with GROUP BY & LEFT JOIN that Runtime 473ms (Beats 79.83%)

SELECT 
    e1.employee_id,
    (
        CASE
            WHEN e2.primary_flag IS NULL THEN e1.department_id
            WHEN e2.primary_flag IS NOT NULL AND e2.primary_flag = 'Y' THEN e2.department_id
        END
    ) AS department_id
FROM employee e1
LEFT JOIN (
    SELECT 
        * 
    FROM employee
    WHERE primary_flag = 'Y'
) AS e2 
ON e1.employee_id = e2.employee_id
GROUP BY e1.employee_id;

Time Complexity: O(n log n)
Space Complexity: O(n)
Both time and space complexity are efficient, with the bottleneck being the GROUP BY operation which incurs an O(n log n) time complexity.


2. Solution with WINDOW FUNCTION that Runtime 503ms (Beats 63.54%)

SELECT 
    a.employee_id,
    a.department_id
FROM (
    SELECT 
        e.employee_id,
        e.department_id,
        ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY primary_flag) AS rn
    FROM employee e
) a 
WHERE a.rn = 1;

Time Complexity: O(n log n)
Space Complexity: O(n)
The partitioning and sorting (in the ROW_NUMBER() function) dominates the time complexity: O(n log n)

3. Solution with Correlated SubQuery that Runtime 569ms (Beats 32.63%)

SELECT 
    e1.employee_id,
    e1.department_id
FROM employee e1
WHERE e1.primary_flag = 'Y'
OR 
    e1.primary_flag = 'N' AND NOT EXISTS (
        SELECT 
			1 
        FROM employee e2
        WHERE e2.employee_id = e1.employee_id AND e2.primary_flag = 'Y'
);

Time Complexity: O(n²) (due to the correlated subquery for each row).
Space Complexity: O(n) (due to handling the rows in memory).