1965. Employees With Missing Information

Table: Employees

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| employee_id | int     |
| name        | varchar |
+-------------+---------+
employee_id is the column with unique values for this table.
Each row of this table indicates the name of the employee whose ID is employee_id.
 

Table: Salaries

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| employee_id | int     |
| salary      | int     |
+-------------+---------+
employee_id is the column with unique values for this table.
Each row of this table indicates the salary of the employee whose ID is employee_id.
 

Write a solution to report the IDs of all the employees with missing information. The information of an employee is missing if:

The employee's name is missing, or
The employee's salary is missing.
Return the result table ordered by employee_id in ascending order.

The result format is in the following example.

 

Example 1:

Input: 
Employees table:
+-------------+----------+
| employee_id | name     |
+-------------+----------+
| 2           | Crew     |
| 4           | Haven    |
| 5           | Kristian |
+-------------+----------+
Salaries table:
+-------------+--------+
| employee_id | salary |
+-------------+--------+
| 5           | 76071  |
| 1           | 22517  |
| 4           | 63539  |
+-------------+--------+
Output: 
+-------------+
| employee_id |
+-------------+
| 1           |
| 2           |
+-------------+
Explanation: 
Employees 1, 2, 4, and 5 are working at this company.
The name of employee 1 is missing.
The salary of employee 2 is missing.


1. Brute force solution with sub-query with runtime 1071ms beats 40.57%:

 - Time complexity:  O(N * M)
 - Space complexity:  O(N + M + R) => N = total rows from first sub-query, M= Total rows from second sub-query, R = total rows after UNION
 
 
SELECT 
    employee_id
FROM employees
WHERE employee_id NOT IN (	
		SELECT 
            employee_id
        FROM salaries
) 
UNION 
SELECT 
    employee_id
FROM salaries
WHERE employee_id NOT IN 
		(SELECT 
            employee_id
        FROM employees
)
ORDER BY employee_id;


2. Solution with Join with runtime 1184ms beats 29.10%:

 - Time complexity: O(m × n) + O(n × m) + O(k log k) => union & order by costs O(k log k)
 - Space complexity: O(m × n)
 
SELECT 
    e.employee_id
FROM employees e
LEFT JOIN salaries s ON e.employee_id = s.employee_id
WHERE s.employee_id IS NULL 
UNION 
SELECT 
    s.employee_id
FROM salaries s
LEFT JOIN employees e ON e.employee_id = s.employee_id
WHERE e.employee_id IS NULL
ORDER BY employee_id;


3. Solution with Correlated sub-query with runtime 556ms beats 95.47%:

 - Time complexity: O(m × n)
 - Space complexity: O(k) => k is the number of rows of unmatched employees in both table 
 
SELECT 
    e.employee_id
FROM employees e
WHERE NOT EXISTS(
		SELECT 
            1
        FROM salaries s
        WHERE e.employee_id = s.employee_id
) 
UNION 
SELECT 
    s.employee_id
FROM salaries s
WHERE NOT EXISTS(
		SELECT 
            1
        FROM
            employees e
        WHERE
            e.employee_id = s.employee_id
)
ORDER BY employee_id;