614. Second Degree Follower

Level
Medium

Description
In facebook, there is a follow table with two columns: followee, follower.

Please write a sql query to get the amount of each follower’s follower if he/she has one.

For example:

+-------------+------------+
| followee    | follower   |
+-------------+------------+
|     A       |     B      |
|     B       |     C      |
|     B       |     D      |
|     D       |     E      |
+-------------+------------+
should output:

+-------------+------------+
| follower    | num        |
+-------------+------------+
|     B       |  2         |
|     D       |  1         |
+-------------+------------+
Explaination:

Both B and D exist in the follower list, when as a followee, B’s follower is C and D, and D’s follower is E. A does not exist in follower list.

Note:

Followee would not follow himself/herself in all cases.

Please display the result in follower’s alphabet order.


Solution with CTE:

WITH follower_CTE AS(
	SELECT 
		follower 
	FROM follow
)
SELECT 
    b.follower,
    COUNT(*) AS num
FROM follow a JOIN follower_CTE b ON a.followee = b.follower
GROUP BY b.follower
ORDER BY b.follower;


Naive Solution with LEFT Join:

SELECT 
	follower, 
	num 
FROM (
	    SELECT 
			f1.follower AS follower, 
            COUNT(DISTINCT f2.follower) AS num
        FROM follow f1 LEFT JOIN follow f2
        ON f1.follower = f2.followee
        GROUP BY f1.follower
) AS nums
WHERE num > 0
ORDER BY follower;

