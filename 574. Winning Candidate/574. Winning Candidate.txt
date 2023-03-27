574. Winning Candidate
Table: Candidate

+-----+---------+
| id  | Name    |
+-----+---------+
| 1   | A       |
| 2   | B       |
| 3   | C       |
| 4   | D       |
| 5   | E       |
+-----+---------+
Table: Vote

+-----+--------------+
| id  | CandidateId  |
+-----+--------------+
| 1   |     2        |
| 2   |     4        |
| 3   |     3        |
| 4   |     2        |
| 5   |     5        |
+-----+--------------+
id is the auto-increment primary key,
CandidateId is the id appeared in Candidate table.
Write a sql to find the name of the winning candidate, the above example will return the winner B.

+------+
| Name |
+------+
| B    |
+------+
Notes:

You may assume there is no tie, in other words there will be at most one winning candidate.


Solution with Corelated subquery:

select 
   c1.name 
from candidate c1 
where 1<(select count(v1.CandidateId) from vote v1 where v1.CandidateId  = c1.id);


Solution with join:

select 
   c.name
from candidate c join vote v on c.id = v.candidateid
group by v.CandidateId
having count(v.candidateid) >1;