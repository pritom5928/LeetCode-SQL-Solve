612. Shortest Distance in a Plane

Table point_2d holds the coordinates (x,y) of some unique points (more than two) in a plane.
Difficulty: Medium

Write a query to find the shortest distance between these points rounded to 2 decimals.
 
Schema : point_2d
| x  | y  |
|----|----|
| -1 | -1 |
| 0  | 0  |
| -1 | -2 |
 

The shortest distance is 1.00 from point (-1,-1) to (-1,2). So the output should be:

| shortest |
|----------|
| 1.00     |

The formula to find distance is  : SQRT((x2-x1)^2 + (y2-y1)^2)

Solution: 

solve in MySQL with sub-query:

select min(distance) from (
	select 
		cast(round(sqrt(power((p2.x-p1.x),2)  + power((p2.y-p1.y),2)),0) as decimal(5,2)) as distance
	from point2d p1 join point2d p2 
	on p1.x<>p2.x and p1.y<>p2.y
) as DistanceList;

solve in MySQL with Common Table Expression: 

with DistanceList_CTE as (
select 
		cast(round(sqrt(power((p2.x-p1.x),2)  + power((p2.y-p1.y),2)),0) as decimal(5,2)) as distance
	from point2d p1 join point2d p2 
	on p1.x<>p2.x and p1.y<>p2.y
)
select min(distance) from DistanceList_CTE;