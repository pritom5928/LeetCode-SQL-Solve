550. Game Play Analysis IV

Difficulty:
Medium

Table: Activity

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of some game.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on some day using some device.
 

Write an SQL query that reports the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places. In other words, you need to count the number of players that logged in for at least two consecutive days starting from their first login date, then divide that number by the total number of players.

The query result format is in the following example:

Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+

Result table:
+-----------+
| fraction  |
+-----------+
| 0.33      |
+-----------+
Only the player with id 1 logged back in after the first day he had logged in so the answer is 1/3 = 0.33



1. solution with Runtime 1061 ms Beats 35.78% : 

with Min_Date_CTE as
(
	SELECT 
		player_id,
        min(event_date) as event_date
	from activity
	group by player_id
)
SELECT 
	ROUND(COUNT(*) / (SELECT COUNT(*) FROM Min_Date_CTE), 2) AS fraction
FROM 
	Min_Date_CTE a JOIN Activity b 
ON a.player_id = b.player_id
WHERE DATEDIFF(b.event_date, a.event_date) = 1;

	- Time complexity: O(NlogN)+O(N)≈O(NlogN)
	- Space complexity: O(M)


2. Optimal solution with Runtime 532 ms Beats 94.21%:

WITH min_event_date_cte AS (
    SELECT 
        player_id,
        MIN(event_date) AS min_date
    FROM  activity
    GROUP BY player_id
)
SELECT 
    ROUND(
        COALESCE(COUNT(b.player_id), 0) / COUNT(DISTINCT a.player_id), 
        2
    ) AS fraction
FROM activity a
LEFT JOIN activity b 
	ON a.player_id = b.player_id 
		AND DATEDIFF(b.event_date, a.event_date) = 1
JOIN min_event_date_cte m 
	ON a.player_id = m.player_id 
		AND a.event_date = m.min_date;
		
	- Time complexity: O(NlogN)+O(N)≈O(NlogN),assuming indexing on player_id
	- Space complexity: O(M), where M is the number of unique player_ids, for the CTE storage.