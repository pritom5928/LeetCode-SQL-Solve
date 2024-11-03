1907. Count Salary Categories
Medium

Table: Accounts

+-------------+------+
| Column Name | Type |
+-------------+------+
| account_id  | int  |
| income      | int  |
+-------------+------+
account_id is the primary key (column with unique values) for this table.
Each row contains information about the monthly income for one bank account.
 

Write a solution to calculate the number of bank accounts for each salary category. The salary categories are:

"Low Salary": All the salaries strictly less than $20000.
"Average Salary": All the salaries in the inclusive range [$20000, $50000].
"High Salary": All the salaries strictly greater than $50000.
The result table must contain all three categories. If there are no accounts in a category, return 0.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Accounts table:
+------------+--------+
| account_id | income |
+------------+--------+
| 3          | 108939 |
| 2          | 12747  |
| 8          | 87709  |
| 6          | 91796  |
+------------+--------+
Output: 
+----------------+----------------+
| category       | accounts_count |
+----------------+----------------+
| Low Salary     | 1              |
| Average Salary | 0              |
| High Salary    | 3              |
+----------------+----------------+
Explanation: 
Low Salary: Account 2.
Average Salary: No accounts.
High Salary: Accounts 3, 6, and 8.


1. Naive solution with UNION with runtime 1476ms (Beats 93.43%):

SELECT 
    'Low Salary' AS category,
    COUNT(CASE WHEN a.income < 20000 THEN 1 END) AS accounts_count
FROM accounts a
UNION ALL
SELECT 
    'Average Salary' AS category,
    COUNT(CASE WHEN a.income BETWEEN 20000 AND 50000 THEN 1 END) AS accounts_count
FROM accounts a
UNION ALL
SELECT 
    'High Salary' AS category,
    COUNT(CASE WHEN a.income > 50000 THEN 1 END) AS accounts_count
FROM accounts a;

	- Time Complexity: O(n)
	- Space Complexity: O(1)
	
2. Solution with CTE & LEFT JOIN with runtime 1504ms (Beats 89.57%):

WITH categories_cte AS (
    SELECT 'Low Salary' AS category
    UNION 
    SELECT 'Average Salary'
    UNION 
    SELECT 'High Salary'
)
SELECT 
    c.category,
    COALESCE(COUNT(result.cat), 0) AS accounts_count
FROM categories_cte c
LEFT JOIN (
    SELECT 
        CASE 
            WHEN a.income < 20000 THEN 'Low Salary'
            WHEN a.income BETWEEN 20000 AND 50000 THEN 'Average Salary'
            WHEN a.income > 50000 THEN 'High Salary'
        END AS cat
    FROM accounts a
) result ON c.category = result.cat
GROUP BY c.category;


	- Time Complexity: O(n)
	- Space Complexity: O(n)
