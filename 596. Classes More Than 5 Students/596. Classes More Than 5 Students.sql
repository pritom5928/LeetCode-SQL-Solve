596. Classes More Than 5 Students
Easy

SQL Schema
Table: Courses

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| student     | varchar |
| class       | varchar |
+-------------+---------+
(student, class) is the primary key column for this table.
Each row of this table indicates the name of a student and the class in which they are enrolled.
 

Write an SQL query to report all the classes that have at least five students.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Courses table:
+---------+----------+
| student | class    |
+---------+----------+
| A       | Math     |
| B       | English  |
| C       | Math     |
| D       | Biology  |
| E       | Math     |
| F       | Computer |
| G       | Math     |
| H       | Math     |
| I       | Math     |
+---------+----------+
Output: 
+---------+
| class   |
+---------+
| Math    |
+---------+
Explanation: 
- Math has 6 students, so we include it.
- English has 1 student, so we do not include it.
- Biology has 1 student, so we do not include it.
- Computer has 1 student, so we do not include it.


1. Solution with GROUP BY & HAVING clause with Runtime 306 ms that beats 63.93% of MySQL submission:

SELECT 
    class
FROM  Courses
GROUP BY class
HAVING COUNT(1) >= 5;

2. Solution with Window function with Runtime 314 ms that beats 56.77% of MySQL submission:

SELECT 
    DISTINCT class
FROM (
    SELECT 
        class, 
        COUNT(1) OVER (PARTITION BY class) AS frequency
    FROM Courses
) res
WHERE res.frequency >= 5;