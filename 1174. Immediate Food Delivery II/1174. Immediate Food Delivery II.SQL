1174. Immediate Food Delivery II
Medium

Companies
SQL Schema
Table: Delivery

+-----------------------------+---------+
| Column Name                 | Type    |
+-----------------------------+---------+
| delivery_id                 | int     |
| customer_id                 | int     |
| order_date                  | date    |
| customer_pref_delivery_date | date    |
+-----------------------------+---------+
delivery_id is the primary key of this table.
The table holds information about food delivery to customers that make orders at some date and specify a preferred delivery date (on the same order date or after it).
 

If the customer's preferred delivery date is the same as the order date, then the order is called immediate; otherwise, it is called scheduled.

The first order of a customer is the order with the earliest order date that the customer made. It is guaranteed that a customer has precisely one first order.

Write an SQL query to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.

The query result format is in the following example.

 

Example 1:

Input: 
Delivery table:
+-------------+-------------+------------+-----------------------------+
| delivery_id | customer_id | order_date | customer_pref_delivery_date |
+-------------+-------------+------------+-----------------------------+
| 1           | 1           | 2019-08-01 | 2019-08-02                  |
| 2           | 2           | 2019-08-02 | 2019-08-02                  |
| 3           | 1           | 2019-08-11 | 2019-08-12                  |
| 4           | 3           | 2019-08-24 | 2019-08-24                  |
| 5           | 3           | 2019-08-21 | 2019-08-22                  |
| 6           | 2           | 2019-08-11 | 2019-08-13                  |
| 7           | 4           | 2019-08-09 | 2019-08-09                  |
+-------------+-------------+------------+-----------------------------+
Output: 
+----------------------+
| immediate_percentage |
+----------------------+
| 50.00                |
+----------------------+
Explanation: 
The customer id 1 has a first order with delivery id 1 and it is scheduled.
The customer id 2 has a first order with delivery id 2 and it is immediate.
The customer id 3 has a first order with delivery id 5 and it is scheduled.
The customer id 4 has a first order with delivery id 7 and it is immediate.
Hence, half the customers have immediate first orders.



1. Solution with Rank() window function Runtime 637 ms Beats 81.70% in MySQL:

SELECT 
    ROUND(
        SUM(IF
			(DATEDIFF(p.order_date, p.customer_pref_delivery_date) = 0 AND rnk = 1, 
            1, 0)
		) / 
        (COUNT(DISTINCT customer_id) * 100), 
    2) AS immediate_percentage 
FROM (
    SELECT 
        d.*,
        RANK() OVER w AS rnk
    FROM delivery d
    WINDOW w AS (PARTITION BY customer_id ORDER BY order_date)
) p;

 - Time Complexity: O(nlogn)
 - Space Complexity: O(n)

2. Solution with Subquery & AGG() function Runtime 678 ms Beats 67.02% in MySQL:

SELECT 
    ROUND(
        AVG(order_date = customer_pref_delivery_date) * 100, 
        2
    ) AS immediate_percentage
FROM 
    Delivery
WHERE (customer_id, order_date) IN (
        SELECT 
            customer_id, 
            MIN(order_date) 
        FROM Delivery
        GROUP BY customer_id
    );
	

 - Time Complexity: O(nlogn+n⋅m). If customer_id values are unique or nearly unique, 𝑚≈n  so the time complexity could approach O(n^2) for large datasets
 - Space Complexity: O(m), due to the storage required for the subquery result.

