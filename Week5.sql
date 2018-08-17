
 /* IS6030 Week 5 Advanced Query 

	Demo Part I.
  
 */

 USE Movies

/*----------1. CASE----------*/

--CASE is used for categorization
SELECT
	FilmName	
	,FilmRunTimeMinutes
FROM
	tblFilm;

/*a. Using CASE with numbers: categorize films by running time.*/

SELECT
	FilmName	
	,FilmRunTimeMinutes
	, CASE 
		WHEN FilmRunTimeMinutes<=90 THEN 'Short'
		WHEN FilmRunTimeMinutes<=150 THEN 'Medium'
		WHEN FilmRunTimeMinutes<=180 THEN 'Long'	
		ELSE 'Super Long'
	  END AS FilmDuration
FROM
	tblFilm
WHERE CASE 
		WHEN FilmRunTimeMinutes<=90 THEN 'Short'
		WHEN FilmRunTimeMinutes<=150 THEN 'Medium'
		WHEN FilmRunTimeMinutes<=180 THEN 'Long'	
		ELSE 'Super Long'
	  END  ='Short';

-- Cannot put alias in WHERE clauses
SELECT
	FilmName	
	,FilmRunTimeMinutes
	, CASE 
		WHEN FilmRunTimeMinutes<=90 THEN 'Short'
		WHEN FilmRunTimeMinutes<=150 THEN 'Medium'
		WHEN FilmRunTimeMinutes<=180 THEN 'Long'	
		ELSE 'Super Long'
	  END AS FilmDuration
FROM
	tblFilm 
WHERE 
	CASE 
		WHEN FilmRunTimeMinutes<=90 THEN 'Short'
		WHEN FilmRunTimeMinutes<=150 THEN 'Medium'
		WHEN FilmRunTimeMinutes<=180 THEN 'Long'	
		ELSE 'Super Long'
	END = 'Medium';



/*b. Using CASE with text:categorize films by FilmName.*/
SELECT
	FilmName	
	, CASE 
		WHEN FilmName LIKE '%Harry Potter%' THEN 'Great'
		ELSE 'Unknown'
	  END AS FilmReview
FROM
	tblFilm;


/*c. Using CASE with dates:categorize films by FilmReleaseDate.*/

SELECT
	FilmName
	,FilmReleaseDate	
	, CASE 
		WHEN FilmReleaseDate <'1927-10-01' THEN 'Silent Era'
		ELSE 'Talkie Era'
	  END AS FilmEra
FROM
	tblFilm;


/*----------2. OVER----------*/

-- OVER () is used to perform aggregate queries.
-- OVER(PARTITION BY) is used to break up data into partitions.
-- Partition the data by CountryID, and then Count() is applied over each partition.

/*a. OVER () and OVER (PARTITION BY) */

--OVER()
SELECT
	DISTINCT FilmCountryID
	, COUNT (FilmCountryID) OVER () AS NumFilmCtry
FROM tblFilm
ORDER BY FilmCountryID;

SELECT
	DISTINCT FilmCountryID
	, COUNT (FilmCountryID) OVER (PARTITION BY FilmCountryID) AS NumFilmCtry
FROM tblFilm
ORDER BY FilmCountryID;


--OVER (PARTITION BY)
SELECT
	 FilmCountryID
	, COUNT (FilmCountryID) OVER (PARTITION BY FilmCountryID) AS NumFilmCtry
FROM tblFilm
ORDER BY FilmCountryID;

/*a. OVER and GROUP BY */
SELECT 
	   FilmCountryID
	, COUNT (FilmCountryID) OVER (PARTITION BY FilmCountryID) AS NumFilmCtry
FROM tblFilm
ORDER BY FilmCountryID;

--GROUP BY
SELECT
	FilmCountryID
	, COUNT (FilmCountryID) AS NumFilmCtry 
FROM tblFilm
GROUP BY FilmCountryID
ORDER BY FilmCountryID;

/*b. When GROUP BY does not work */

--Aggregated columns and non-aggregated columns together
SELECT
	FilmName
	, FilmCountryID
	, COUNT(FilmCountryID) AS NumFilmCtry
	, MIN(FilmBudgetDollars) AS MinBudget
	, MAX(FilmRunTimeMinutes) AS MaxRunTime
FROM tblFilm
GROUP BY FilmCountryID
ORDER BY FilmCountryID; --Error Message?

--Solution:

SELECT
	FilmName
	, FilmCountryID
	, COUNT(FilmCountryID) OVER (PARTITION BY FilmCountryID) AS NumFilmCtry
	, MIN(FilmBudgetDollars) OVER (PARTITION BY FilmCountryID) AS MinBudget
	, MAX(FilmRunTimeMinutes) OVER (PARTITION BY FilmCountryID) AS MaxRunTime
FROM tblFilm
ORDER BY FilmCountryID;

--Avaiable: COUNT(), AVG(), SUM(), MIN(), MAX()


/*c. Other functions before OVER (): Row_Number*/

--Returns the sequential number of a row starting at 1; 
--ORDER BY clause is required; PARTITION BY clause is optional
--When the data is partitioned, row number is reset to 1 when the partition changes

SELECT FilmName
		, FilmReleaseDate
		, FilmCountryID
		, ROW_NUMBER () OVER (ORDER BY FilmCountryID) AS RowNumber
FROM tblFilm;

--compare the following code with the above code
SELECT FilmName
		, FilmReleaseDate
		, FilmCountryID
		, ROW_NUMBER () OVER (PARTITION BY FilmCountryID ORDER BY FilmCountryID) AS RowNumber
FROM tblFilm
--ORDER BY FilmReleaseDate;

-- Application: Use ROW_NUMBER to identify duplicated rows

SELECT *
FROM (  SELECT FilmID
		,FilmName
		, ROW_NUMBER () OVER (PARTITION BY FilmID ORDER BY FilmID) AS RowNumber
	FROM tblFilm) AS DupRow
WHERE DupRow.RowNumber > 1;
--
SELECT *
FROM (  SELECT DirectorName
				, ROW_NUMBER () OVER (PARTITION BY DirectorName ORDER BY DirectorName) AS RowNumber
	FROM tblDirector) AS DupRow
WHERE DupRow.RowNumber > 1;



/*d. Other functions before OVER (): Rank() */

--returns a rank starting at 1 based on the ordering or rows imposed by the ORDER BY clause
--ORDER BY clause is required; partition by clause is optional
--When the data is partitioned, rank is reset to 1 when the partition changes



SELECT FilmID
		,FilmName
		,FilmRunTimeMinutes
		,RANK () OVER (ORDER BY FilmRunTimeMinutes) AS Rank
FROM tblFilm
ORDER BY FilmRunTimeMinutes;

--OR
SELECT FilmID
		,FilmName
		,FilmRunTimeMinutes
		,FilmCountryID
		, RANK () OVER (PARTITION BY FilmCountryID ORDER BY FilmRunTimeMinutes) AS Rank
FROM tblFilm
ORDER BY FilmCountryID;

SELECT FilmID
		,FilmName
		,FilmRunTimeMinutes
		,FilmCountryID
		, RANK () OVER (PARTITION BY FilmCountryID ORDER BY FilmCountryID) AS Rank
FROM tblFilm
ORDER BY FilmCountryID;