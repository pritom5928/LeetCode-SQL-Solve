1729. Find Followers Count
Easy

SQL Schema
Table: Followers

+-------------+------+
| Column Name | Type |
+-------------+------+
| user_id     | int  |
| follower_id | int  |
+-------------+------+
(user_id, follower_id) is the primary key for this table.
This table contains the IDs of a user and a follower in a social media app where the follower follows the user.
 

Write an SQL query that will, for each user, return the number of followers.

Return the result table ordered by user_id in ascending order.

The query result format is in the following example.

 

Example 1:

Input: 
Followers table:
+---------+-------------+
| user_id | follower_id |
+---------+-------------+
| 0       | 1           |
| 1       | 0           |
| 2       | 0           |
| 2       | 1           |
+---------+-------------+
Output: 
+---------+----------------+
| user_id | followers_count|
+---------+----------------+
| 0       | 1              |
| 1       | 1              |
| 2       | 2              |
+---------+----------------+
Explanation: 
The followers of 0 are {1}
The followers of 1 are {0}
The followers of 2 are {0,1}


Solution Runtime 1202 ms beats 24.41% MySQL Submisison:

SELECT 
  user_id,
  count(*) as followers_count
FROM Followers
GROUP BY User_id
ORDER BY User_id;

Solution Runtime 992 ms beats 76.11% MySQL Submission:

SELECT 
  DISTINCT user_id,
  COUNT(*) OVER(PARTITION BY  User_id) AS followers_count
FROM Followers
ORDER BY User_id;
