3220. Odd and Even Transactions
Medium

Table: transactions

+------------------+------+
| Column Name      | Type | 
+------------------+------+
| transaction_id   | int  |
| amount           | int  |
| transaction_date | date |
+------------------+------+
The transactions_id column uniquely identifies each row in this table.
Each row of this table contains the transaction id, amount and transaction date.
Write a solution to find the sum of amounts for odd and even transactions for each day. If there are no odd or even transactions for a specific date, display as 0.

Return the result table ordered by transaction_date in ascending order.

The result format is in the following example.

 

Example:

Input:

transactions table:

+----------------+--------+------------------+
| transaction_id | amount | transaction_date |
+----------------+--------+------------------+
| 1              | 150    | 2024-07-01       |
| 2              | 200    | 2024-07-01       |
| 3              | 75     | 2024-07-01       |
| 4              | 300    | 2024-07-02       |
| 5              | 50     | 2024-07-02       |
| 6              | 120    | 2024-07-03       |
+----------------+--------+------------------+
  
Output:

+------------------+---------+----------+
| transaction_date | odd_sum | even_sum |
+------------------+---------+----------+
| 2024-07-01       | 75      | 350      |
| 2024-07-02       | 0       | 350      |
| 2024-07-03       | 0       | 120      |
+------------------+---------+----------+
  
Explanation:

For transaction dates:
2024-07-01:
Sum of amounts for odd transactions: 75
Sum of amounts for even transactions: 150 + 200 = 350
2024-07-02:
Sum of amounts for odd transactions: 0
Sum of amounts for even transactions: 300 + 50 = 350
2024-07-03:
Sum of amounts for odd transactions: 0
Sum of amounts for even transactions: 120
Note: The output table is ordered by transaction_date in ascending order.


1. Solution with Group by with Runtime 430ms beats 75.69%:

  - Time Complexity: O(N log N)
  - Space Complexity: O(N)

SELECT 
    transaction_date,
    SUM(IF(amount % 2 = 1, amount, 0)) AS odd_sum,
    SUM(IF(amount % 2 = 0, amount, 0)) AS even_sum
FROM transactions
GROUP BY transaction_date
ORDER BY transaction_date;

2. Solution with CTE & Window function with Runtime 300ms beats 91.95%:

  - Time Complexity: O(N log G) => G is the numbers of unique transactions date
  - Space Complexity: O(N)

WITH cte AS (
    SELECT 
        t.transaction_date,
        SUM(IF(amount % 2 = 1, amount, 0)) OVER (PARTITION BY transaction_date) AS odd_sum,
        SUM(IF(amount % 2 = 0, amount, 0)) OVER (PARTITION BY transaction_date) AS even_sum,
        ROW_NUMBER() OVER (PARTITION BY transaction_date) AS rn
    FROM transactions t
    ORDER BY t.transaction_date
)
SELECT 
    c.transaction_date,
    c.odd_sum,
    c.even_sum
FROM cte c
WHERE c.rn = 1;
