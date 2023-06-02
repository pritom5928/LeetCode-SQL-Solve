618. Students Report By Geography
A U.S graduate school has students from Asia, Europe and America. The students' location information are stored in table student as below.
 

| name   | continent |
|--------|-----------|
| Jack   | America   |
| Pascal | Europe    |
| Xi     | Asia      |
| Jane   | America   |
 

Pivot the continent column in this table so that each name is sorted alphabetically and displayed underneath its corresponding continent. The output headers should be America, Asia and Europe respectively. It is guaranteed that the student number from America is no less than either Asia or Europe.
 

For the sample input, the output is:
 

| America | Asia | Europe |
|---------|------|--------|
| Jack    | Xi   | Pascal |
| Jane    |      |        |
 

Follow-up: If it is unknown which continent has the most students, can you write a query to generate the student report?


Solution with window function:

SELECT 
     MAX(
		CASE 
			WHEN continent = 'America' THEN name 
		END
	 ) AS America,
     MAX(
		CASE 
			WHEN continent = 'Asia' THEN name 
		END
	 ) AS Asia,
     MAX(
		CASE 
			WHEN continent = 'Europe' THEN name 
		END
	 ) AS Europe
FROM (
	SELECT  
		*, ROW_NUMBER() OVER(PARTITION BY continent) AS grp
	FROM student
) AS t
GROUP BY grp
ORDER BY grp;