610. Triangle Judgement
Easy

SQL Schema
Table: Triangle

+-------------+------+
| Column Name | Type |
+-------------+------+
| x           | int  |
| y           | int  |
| z           | int  |
+-------------+------+
(x, y, z) is the primary key column for this table.
Each row of this table contains the lengths of three line segments.
 

Write an SQL query to report for every three line segments whether they can form a triangle.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Triangle table:
+----+----+----+
| x  | y  | z  |
+----+----+----+
| 13 | 15 | 30 |
| 10 | 20 | 15 |
+----+----+----+
Output: 
+----+----+----+----------+
| x  | y  | z  | triangle |
+----+----+----+----------+
| 13 | 15 | 30 | No       |
| 10 | 20 | 15 | Yes      |
+----+----+----+----------+



1. solution with Runtime 304 ms Beats 45.31% MySQL submission:

SELECT x,y,z,
    CASE
        WHEN (x+y > z AND y+z > x AND z+x > y) THEN 'Yes'
        ELSE 'No'
    END AS triangle
FROM Triangle

 - Time Complexity: O(n)
 - Space Complexity: O(n)

2. Optimal solution with runtime 284ms beats 64.74% MySQL Submission:

SELECT 
    t.*,
    CASE 
        WHEN (t.x + t.y <= t.z AND t.x + t.y > 0) 
             OR (t.x + t.z <= t.y AND t.x + t.z > 0) 
             OR (t.y + t.z <= t.x AND t.y + t.z > 0)
            THEN "No"
        WHEN t.x < 0 OR t.y < 0 OR t.z < 0
            THEN "No"
        ELSE "Yes"
    END AS triangle
FROM  Triangle t;

 - Time Complexity: O(n)
 - Space Complexity: O(n)
