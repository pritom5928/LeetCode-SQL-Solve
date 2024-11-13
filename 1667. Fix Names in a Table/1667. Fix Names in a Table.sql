1667. Fix Names in a Table
Easy

Table: Users

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| user_id        | int     |
| name           | varchar |
+----------------+---------+
user_id is the primary key for this table.
This table contains the ID and the name of the user. The name consists of only lowercase and uppercase characters.
 

Write an SQL query to fix the names so that only the first character is uppercase and the rest are lowercase.

Return the result table ordered by user_id.

The query result format is in the following example.

 

Example 1:

Input: 
Users table:
+---------+-------+
| user_id | name  |
+---------+-------+
| 1       | aLice |
| 2       | bOB   |
+---------+-------+
Output: 
+---------+-------+
| user_id | name  |
+---------+-------+
| 1       | Alice |
| 2       | Bob   |
+---------+-------+


1. Solution with LEFT() & SUBSTRING() with Runtime 547ms beats 99.02% submission:

SELECT 
    user_id,
    CONCAT(
        UPPER(LEFT(name, 1)), 
        LOWER(SUBSTRING(name, 2, CHAR_LENGTH(name)))
    ) AS name
FROM users
ORDER BY user_id;

	- Time complexity: O(n*m)
	- Space complexity: O(n*m)

2. Solution with LEFT()& RIGHT() with Runtime 553ms beats 98.59% submission:

SELECT 
    user_id,
    CONCAT(UPPER(LEFT(name, 1)),
            LOWER(RIGHT(name, CHAR_LENGTH(name) - 1))
	) AS name
FROM users
ORDER BY user_id;

	- Time complexity: O(n*m)
	- Space complexity: O(n*m)
