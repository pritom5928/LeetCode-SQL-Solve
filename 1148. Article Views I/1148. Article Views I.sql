1148. Article Views I
Easy
SQL Schema
Table: Views

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| article_id    | int     |
| author_id     | int     |
| viewer_id     | int     |
| view_date     | date    |
+---------------+---------+
There is no primary key for this table, it may have duplicate rows.
Each row of this table indicates that some viewer viewed an article (written by some author) on some date. 
Note that equal author_id and viewer_id indicate the same person.
 

Write an SQL query to find all the authors that viewed at least one of their own articles.

Return the result table sorted by id in ascending order.

The query result format is in the following example.

 

Example 1:

Input: 
Views table:
+------------+-----------+-----------+------------+
| article_id | author_id | viewer_id | view_date  |
+------------+-----------+-----------+------------+
| 1          | 3         | 5         | 2019-08-01 |
| 1          | 3         | 6         | 2019-08-02 |
| 2          | 7         | 7         | 2019-08-01 |
| 2          | 7         | 6         | 2019-08-02 |
| 4          | 7         | 1         | 2019-07-22 |
| 3          | 4         | 4         | 2019-07-21 |
| 3          | 4         | 4         | 2019-07-21 |
+------------+-----------+-----------+------------+
Output: 
+------+
| id   |
+------+
| 4    |
| 7    |
+------+

Naive solution by Corelated Subquery with 2025ms Runtime beats 5.3% MySQL submission:

SELECT
	DISTINCT(v1.author_id) AS id 
FROM views v1
WHERE 1<= (SELECT count(*) FROM views v2 
			WHERE v1.author_id = v2.viewer_id AND v1.viewer_id = v2.viewer_id)
ORDER BY id ASC;


quite optimal solution by normal clause with 719ms runtime beats 31.40% MySQL submission:

select 
	distinct(author_id) as id
from views
where author_id = viewer_id
order by id asc;


more optimal solution by group by & having with Runtime 470 ms beats 90.80% MySQL submission:

select 
	author_id as id
from views
group by author_id, viewer_id
having author_id = viewer_id
order by id asc;