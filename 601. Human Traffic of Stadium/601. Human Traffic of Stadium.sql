601. Human Traffic of Stadium
Hard
476
528
Companies
SQL Schema
Table: Stadium

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| visit_date    | date    |
| people        | int     |
+---------------+---------+
visit_date is the primary key for this table.
Each row of this table contains the visit date and visit id to the stadium with the number of people during the visit.
No two rows will have the same visit_date, and as the id increases, the dates increase as well.
 

Write an SQL query to display the records with three or more rows with consecutive id's, and the number of people is greater than or equal to 100 for each.

Return the result table ordered by visit_date in ascending order.

The query result format is in the following example.

 

Example 1:

Input: 
Stadium table:
+------+------------+-----------+
| id   | visit_date | people    |
+------+------------+-----------+
| 1    | 2017-01-01 | 10        |
| 2    | 2017-01-02 | 109       |
| 3    | 2017-01-03 | 150       |
| 4    | 2017-01-04 | 99        |
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-09 | 188       |
+------+------------+-----------+
Output: 
+------+------------+-----------+
| id   | visit_date | people    |
+------+------------+-----------+
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-09 | 188       |
+------+------------+-----------+
Explanation: 
The four rows with ids 5, 6, 7, and 8 have consecutive ids and each of them has >= 100 people attended. Note that row 8 was included even though the visit_date was not the next day after row 7.
The rows with ids 2 and 3 are not included because we need at least three consecutive ids.


Solution with 659 ms runtime that beats 32.37% MySQL submission:

with cte as (
 select * , id - rank() over(order by visit_date) as grp from stadium where people > 99
),
valuecount as (
  select *, count(*) over(partition by grp) as consecutiveValueCount from cte 
)
select id, visit_date, people from valuecount where consecutiveValueCount >=3;


Solution with 642 ms runtime that beats 35.34% MySQL submission:

with temp_stadium_100 as (
    select * from Stadium where people >= 100
)

select *
from temp_stadium_100 as S
where
    (S.id + 1 in (select id from temp_stadium_100) and S.id + 2 in (select id from temp_stadium_100))
    or
    (S.id - 1 in (select id from temp_stadium_100) and S.id - 2 in (select id from temp_stadium_100))
    or
    (S.id + 1 in (select id from temp_stadium_100) and S.id - 1 in (select id from temp_stadium_100))
order by visit_date asc;
