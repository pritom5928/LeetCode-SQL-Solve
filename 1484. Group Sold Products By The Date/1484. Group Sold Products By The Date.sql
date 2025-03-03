1484. Group Sold Products By The Date
Easy
SQL Schema
Table Activities:

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| sell_date   | date    |
| product     | varchar |
+-------------+---------+
There is no primary key for this table, it may contain duplicates.
Each row of this table contains the product name and the date it was sold in a market.
 

Write an SQL query to find for each date the number of different products sold and their names.

The sold products names for each date should be sorted lexicographically.

Return the result table ordered by sell_date.

The query result format is in the following example.

 

Example 1:

Input: 
Activities table:
+------------+------------+
| sell_date  | product     |
+------------+------------+
| 2020-05-30 | Headphone  |
| 2020-06-01 | Pencil     |
| 2020-06-02 | Mask       |
| 2020-05-30 | Basketball |
| 2020-06-01 | Bible      |
| 2020-06-02 | Mask       |
| 2020-05-30 | T-Shirt    |
+------------+------------+
Output: 
+------------+----------+------------------------------+
| sell_date  | num_sold | products                     |
+------------+----------+------------------------------+
| 2020-05-30 | 3        | Basketball,Headphone,T-shirt |
| 2020-06-01 | 2        | Bible,Pencil                 |
| 2020-06-02 | 1        | Mask                         |
+------------+----------+------------------------------+
Explanation: 
For 2020-05-30, Sold items were (Headphone, Basketball, T-shirt), we sort them lexicographically and separate them by a comma.
For 2020-06-01, Sold items were (Pencil, Bible), we sort them lexicographically and separate them by a comma.
For 2020-06-02, the Sold item is (Mask), we just return it.



1. Optimal Solution with GROUP BY & GROUP_CONCAT() function with Runtime 409 ms (beats 95.68%):

SELECT 
    sell_date,
    COUNT(DISTINCT product) AS num_sold,
    GROUP_CONCAT(DISTINCT product ORDER BY product ASC) AS products
FROM activities
GROUP BY sell_date
ORDER BY sell_date ASC;

	- Time Complexity: O(N + G log G + K log K), here G = number of unique sell dates, K = number of unique products on that date, N = total number of rows
	- Space Complexity: O(G + K)

2. Solution with CTE, Window function, Join & GROUP BY with Runtime 516 ms (beats 42.06%):


WITH DistinctProducts AS (
    SELECT 
        sell_date,
        product
    FROM activities
    GROUP BY sell_date, product
),
AggregatedData AS (
    SELECT 
        sell_date,
        COUNT(product) OVER (PARTITION BY sell_date) AS num_sold
    FROM DistinctProducts
)
SELECT 
    dp.sell_date,
    ad.num_sold,
    (SELECT 
         GROUP_CONCAT(dp2.product ORDER BY dp2.product ASC) 
     FROM DistinctProducts dp2 
     WHERE dp2.sell_date = dp.sell_date
    ) AS products
FROM DistinctProducts dp
JOIN AggregatedData ad ON dp.sell_date = ad.sell_date
GROUP BY dp.sell_date, ad.num_sold
ORDER BY dp.sell_date ASC;

	- Time complexity: O(N log N + K * M log M), here K = number of unique sell dates, M = number of unique products on that date, N = total number of rows
	- Space complexity: O(N)