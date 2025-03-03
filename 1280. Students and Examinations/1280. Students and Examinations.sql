1280. Students and Examinations
Easy

SQL Schema
Table: Students

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| student_id    | int     |
| student_name  | varchar |
+---------------+---------+
student_id is the primary key for this table.
Each row of this table contains the ID and the name of one student in the school.
 

Table: Subjects

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| subject_name | varchar |
+--------------+---------+
subject_name is the primary key for this table.
Each row of this table contains the name of one subject in the school.
 

Table: Examinations

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| student_id   | int     |
| subject_name | varchar |
+--------------+---------+
There is no primary key for this table. It may contain duplicates.
Each student from the Students table takes every course from the Subjects table.
Each row of this table indicates that a student with ID student_id attended the exam of subject_name.
 

Write an SQL query to find the number of times each student attended each exam.

Return the result table ordered by student_id and subject_name.

The query result format is in the following example.

 

Example 1:

Input: 
Students table:
+------------+--------------+
| student_id | student_name |
+------------+--------------+
| 1          | Alice        |
| 2          | Bob          |
| 13         | John         |
| 6          | Alex         |
+------------+--------------+
Subjects table:
+--------------+
| subject_name |
+--------------+
| Math         |
| Physics      |
| Programming  |
+--------------+
Examinations table:
+------------+--------------+
| student_id | subject_name |
+------------+--------------+
| 1          | Math         |
| 1          | Physics      |
| 1          | Programming  |
| 2          | Programming  |
| 1          | Physics      |
| 1          | Math         |
| 13         | Math         |
| 13         | Programming  |
| 13         | Physics      |
| 2          | Math         |
| 1          | Math         |
+------------+--------------+
Output: 
+------------+--------------+--------------+----------------+
| student_id | student_name | subject_name | attended_exams |
+------------+--------------+--------------+----------------+
| 1          | Alice        | Math         | 3              |
| 1          | Alice        | Physics      | 2              |
| 1          | Alice        | Programming  | 1              |
| 2          | Bob          | Math         | 1              |
| 2          | Bob          | Physics      | 0              |
| 2          | Bob          | Programming  | 1              |
| 6          | Alex         | Math         | 0              |
| 6          | Alex         | Physics      | 0              |
| 6          | Alex         | Programming  | 0              |
| 13         | John         | Math         | 1              |
| 13         | John         | Physics      | 1              |
| 13         | John         | Programming  | 1              |
+------------+--------------+--------------+----------------+
Explanation: 
The result table should contain all students and all subjects.
Alice attended the Math exam 3 times, the Physics exam 2 times, and the Programming exam 1 time.
Bob attended the Math exam 1 time, the Programming exam 1 time, and did not attend the Physics exam.
Alex did not attend any exams.
John attended the Math exam 1 time, the Physics exam 1 time, and the Programming exam 1 time.



1. Solution with Cross Join in MySQL with 1625 ms runtime beats 62.45% MySQL Submisisons:

SELECT 
	s.student_id,
    s.student_name,
    sub.subject_name,
    SUM(IF(e.subject_name is null, 0, 1)) AS attended_exams
FROM Students s CROSS JOIN Subjects sub
LEFT JOIN Examinations e ON s.student_id = e.student_id AND sub.subject_name = e.subject_name
GROUP BY s.student_id, s.student_name, sub.subject_name
ORDER BY s.student_id, sub.subject_name;


2. Solution by Correlated Subquery with 999 ms runtime beats 27.01% MySQL Submisisons:

SELECT 
    s.student_id, 
    s.student_name, 
    sub.subject_name, 
    (
        SELECT COUNT(1) 
        FROM examinations e 
        WHERE e.student_id = s.student_id 
          AND e.subject_name = sub.subject_name
    ) AS attended_exams
FROM students s, subjects sub
ORDER BY s.student_id, sub.subject_name;

3. Solution by Window function with 873 ms Runtime beats 51.87% MySQL Submisisons:

SELECT 
    * 
FROM (
    SELECT 
        s.student_id,
        s.student_name,
        sub.subject_name,
        SUM(IF(e.subject_name IS NULL, 0, 1)) OVER w AS attended_exams
    FROM Students s 
    CROSS JOIN Subjects sub
    LEFT JOIN Examinations e 
        ON s.student_id = e.student_id 
        AND sub.subject_name = e.subject_name
    WINDOW w AS (PARTITION BY s.student_id, sub.subject_name ORDER BY s.student_id, sub.subject_name)
) res
GROUP BY res.student_id, res.subject_name;

