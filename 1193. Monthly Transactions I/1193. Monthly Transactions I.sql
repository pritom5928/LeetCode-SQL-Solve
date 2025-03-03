1193. Monthly Transactions I
Solved
Medium
Topics
Companies
SQL Schema
Pandas Schema
Table: Transactions

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| country       | varchar |
| state         | enum    |
| amount        | int     |
| trans_date    | date    |
+---------------+---------+
id is the primary key of this table.
The table has information about incoming transactions.
The state column is an enum of type ["approved", "declined"].
 

Write an SQL query to find for each month and country, the number of transactions and their total amount, the number of approved transactions and their total amount.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Transactions table:
+------+---------+----------+--------+------------+
| id   | country | state    | amount | trans_date |
+------+---------+----------+--------+------------+
| 121  | US      | approved | 1000   | 2018-12-18 |
| 122  | US      | declined | 2000   | 2018-12-19 |
| 123  | US      | approved | 2000   | 2019-01-01 |
| 124  | DE      | approved | 2000   | 2019-01-07 |
+------+---------+----------+--------+------------+
Output: 
+----------+---------+-------------+----------------+--------------------+-----------------------+
| month    | country | trans_count | approved_count | trans_total_amount | approved_total_amount |
+----------+---------+-------------+----------------+--------------------+-----------------------+
| 2018-12  | US      | 2           | 1              | 3000               | 1000                  |
| 2019-01  | US      | 1           | 1              | 2000               | 2000                  |
| 2019-01  | DE      | 1           | 1              | 2000               | 2000                  |
+----------+---------+-------------+----------------+--------------------+-----------------------+


1. solution with GROUP BY Runtime 578ms Beats 86.16% in MySQL:

SELECT 
    DATE_FORMAT(trans_date, '%Y-%m') AS month,
    country,
    Count(*) AS trans_count,
    SUM(IF(state = 'approved', 1, 0)) AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(IF(state = 'approved', amount, 0)) AS approved_total_amount
FROM transactions
GROUP BY DATE_FORMAT(trans_date, '%Y-%m'), country



2. solution with Window function Runtime 602ms Beats 77.62% in MySQL:

WITH cte AS (
    SELECT
        DATE_FORMAT(t.trans_date, '%Y-%m') AS month,
        t.country,
        COUNT(1) OVER w AS trans_count,
        SUM(IF(t.state = 'approved', 1, 0)) OVER w AS approved_count,
        SUM(t.amount) OVER w AS trans_total_amount,
        SUM(IF(t.state = 'approved', t.amount, 0)) OVER w AS approved_total_amount,
        LEAD(t.country) OVER w AS lead_rnk
    FROM 
        transactions t
    WINDOW w AS (PARTITION BY DATE_FORMAT(t.trans_date, '%Y-%m'), t.country)
)

SELECT 
    c.month,
    c.country,
    c.trans_count,
    c.approved_count,
    c.trans_total_amount,
    c.approved_total_amount
FROM 
    cte c
WHERE 
    c.lead_rnk IS NULL;
