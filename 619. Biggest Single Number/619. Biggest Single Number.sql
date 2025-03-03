619. Biggest Single Number
Easy

SQL Schema
Table: MyNumbers

+-------------+------+
| Column Name | Type |
+-------------+------+
| num         | int  |
+-------------+------+
There is no primary key for this table. It may contain duplicates.
Each row of this table contains an integer.
 

A single number is a number that appeared only once in the MyNumbers table.

Write an SQL query to report the largest single number. If there is no single number, report null.

The query result format is in the following example.

 

Example 1:

Input: 
MyNumbers table:
+-----+
| num |
+-----+
| 8   |
| 8   |
| 3   |
| 3   |
| 1   |
| 4   |
| 5   |
| 6   |
+-----+
Output: 
+-----+
| num |
+-----+
| 6   |
+-----+
Explanation: The single numbers are 1, 4, 5, and 6.
Since 6 is the largest single number, we return it.
Example 2:

Input: 
MyNumbers table:
+-----+
| num |
+-----+
| 8   |
| 8   |
| 7   |
| 7   |
| 3   |
| 3   |
| 3   |
+-----+
Output: 
+------+
| num  |
+------+
| null |
+------+
Explanation: There are no single numbers in the input table so we return null.



1. Solution with Runtime 663 ms Beats 83.98% MySQL Submissions:

select 
	ifnull(max(t.num), null) as num
from 
(    
	select 
	  num 
	from mynumbers
	group by num 
	having count(*)=1
) as t;

- Time complexity: O(NlogN)
- Space complexity: O(G) where G is the number of unique values in mynumbers table (likely less than N). where N=number of rows.

2. Solution with CTE Runtime 458ms Beats 48.39% MySQL Submissions:

WITH UniqueNums AS (
    SELECT 
        num
    FROM mynumbers
    GROUP BY num
    HAVING COUNT(*) = 1
)
SELECT 
    MAX(num) AS num
FROM UniqueNums;

- Time complexity: O(NlogN)
- Space complexity: O(G) where G is the number of unique values in mynumbers table (likely less than N). where N=number of rows.

3. Solution by Correlated subquery Runtime 432 ms Beats 63.80% MySQL Submissions:

SELECT 
    m.*
FROM mynumbers m
WHERE 
    1 = (SELECT COUNT(*) FROM mynumbers p WHERE m.num = p.num)
    AND 
    m.num = (
        SELECT 
			MAX(p.num) 
        FROM mynumbers p 
        WHERE (SELECT COUNT(1) FROM mynumbers q WHERE p.num = q.num) = 1
    )
UNION ALL
SELECT 
    NULL AS num  
LIMIT 1;

- Time Complexity: O(N ^2)
- Space Complexity: O(U) where U is the number of unique values in mynumbers.


