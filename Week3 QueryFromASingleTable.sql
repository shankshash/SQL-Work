RETURN;


CREATE DATABASE WeekThreeDemo;
USE WeekThreeDemo;

/* IS6030 Week 3 SQL 
    Querying from A Single Table 
 
*/

/*1. Import ClassRegistration into your database.
	 Rename the table as 'Import_ClassRegistration' to run the following code. */

/*2. Insert all data from the imported table into a new table.*/
IF OBJECT_ID('dbo.ClassRegistration', 'U') IS NOT NULL DROP TABLE dbo.ClassRegistration;


CREATE TABLE dbo.ClassRegistration(
	ClassID INT 
	,ClassTime DATETIME NULL
	,Room VARCHAR (10) NULL
	,StuID VARCHAR (10) NULL
	,StuName VARCHAR (10) NULL
	,StuAge INT NULL
	,SAddress VARCHAR (50) NULL
	,GPA DECIMAL (2,1) NULL
	,EmpID VARCHAR (10)  NULL
	,EmpName VARCHAR (10) NULL
	,Rank VARCHAR (50) NULL
	,Dept VARCHAR (10) NULL
	,CourseID VARCHAR (10) NULL
	,Credits INT NULL
	,Title VARCHAR (50) NULL
)


INSERT INTO dbo.ClassRegistration
SELECT *
FROM Import_ClassRegistration;



/*3. SELECT all columns. */
SELECT *
FROM dbo.ClassRegistration;


/*4. SELECT certain columns. */
SELECT SAddress, StuName
FROM dbo.ClassRegistration;


/*5. SELECT certain records.*/
SELECT *
FROM dbo.ClassRegistration
WHERE StuName='Jose';



--you may select certain fields, or change the the order of fields
SELECT StuName
		,CourseID
		, Title
		, EmpName
		, Dept AS Department
		, ClassTime
		, Room 
FROM dbo.ClassRegistration
WHERE StuName='Jose';


SELECT StuName,CourseID, Title, EmpName, Dept, ClassTime, Room 
FROM dbo.ClassRegistration
WHERE StuName<>'Jose';

--wildcard
SELECT StuName,CourseID, Title, EmpName, Dept, ClassTime, Room 
FROM dbo.ClassRegistration
WHERE StuName Like'A%e';

SELECT StuName,CourseID, Title, EmpName, Dept, ClassTime, Room 
FROM dbo.ClassRegistration
WHERE SAddress LIKE 'Buck%'

SELECT StuName,CourseID, Title, EmpName, Dept, ClassTime, Room 
FROM dbo.ClassRegistration
WHERE StuName NOT LIKE '%m';

SELECT StuName,CourseID, Title, EmpName, Dept, ClassTime, Room 
FROM dbo.ClassRegistration
WHERE CourseID LIKE 'CIS[1-2][0-4]%'; --CISe3070; CIS4080; CISg010

SELECT StuName,CourseID, Title, EmpName, Dept, ClassTime, Room 
FROM dbo.ClassRegistration
WHERE CourseID LIKE 'CIS__30'; --CIS1070, CIS2080, CIS5920

--any issue you observe from the following query?
SELECT StuName,StuAge, SAddress, GPA
FROM dbo.ClassRegistration
WHERE StuAge>19;



/*6. SELECT unique records (remove duplicate records).*/
SELECT DISTINCT StuName,StuAge, SAddress, GPA
FROM dbo.ClassRegistration
WHERE StuAge>19;


/*7. Order by one column.*/
SELECT DISTINCT StuName,StuAge, SAddress, GPA
FROM dbo.ClassRegistration
WHERE StuAge>19
ORDER BY StuAge DESC;

-- Ascending (ASC) or Descending (DESC). ASC is the default.
SELECT DISTINCT StuName,StuAge, SAddress, GPA
FROM dbo.ClassRegistration
WHERE StuAge>19
ORDER BY StuAge ASC;

SELECT DISTINCT StuName,StuAge, SAddress, GPA
FROM dbo.ClassRegistration
WHERE StuAge>19
ORDER BY StuAge DESC;

-- Order by more than one columns
SELECT DISTINCT StuName,StuAge, SAddress, GPA
FROM dbo.ClassRegistration
WHERE StuAge>19
ORDER BY StuAge DESC, GPA;

/*8. SELECT with multiple conditions.*/

--AND
SELECT DISTINCT StuName, SAddress
FROM dbo.ClassRegistration
WHERE	GPA > 3.0 AND 
		StuAge > 19
ORDER BY StuName DESC;

--OR
SELECT DISTINCT StuName, StuAge, GPA
FROM dbo.ClassRegistration
WHERE	(GPA > 3.0 OR
		StuAge > 19)
ORDER BY StuName ;

/*Since the above is a basic query, you don't have to format the query that much,

  but when some clauses get really big, you should move each check to a new line.

  When using ORs, always use parenthesis around the OR criteria.

*/

--Bad Example
SELECT * 
 FROM dbo.ClassRegistration
WHERE (Dept = 'MATH' 
 OR GPA >=3.0)
 AND StuName <> 'Alice'

/*	The precedence of AND is higher than OR: 
	X and Y or Z is basically (X and Y) or Z;
	X or Y and Z is basically X or (Y and Z).
*/

-- If you want to express (X or Y) and Z...  

SELECT * 
 FROM dbo.ClassRegistration
WHERE (Dept ='MATH' 
 OR GPA >=3.0)
 AND StuName <> 'Alice';

--Just like in mathematics, statements can be wrapped in ()s to create an order of operations. 
--Two examples: 
SELECT * 
 FROM dbo.ClassRegistration
WHERE (StuName = 'Jose' 
	OR StuName = 'Tom' 
	OR StuName = 'Alice')
	AND Dept = 'CIS';


SELECT * 
 FROM dbo.ClassRegistration
WHERE (
		(
		StuName = 'Jose' 
		OR CourseID LIKE 'CIS[3-4]%'
		)
	 OR 
		(
		StuName NOT LIKE '%m' 
		AND SAddress LIKE 'Buck%' 
		)
	)
	AND GPA > 3.7;


/*9. GROUP BY: 
		List the CourseID and the total number of students in each course. */

SELECT * 
FROM Demo.dbo.ClassRegistration;


SELECT CourseID, Count (StuID) AS NumStu
FROM dbo.ClassRegistration
GROUP BY CourseID;


/*10. GROUP BY: 
	List the DeptID and the number of faculty for each department.*/
	
SELECT * 
FROM dbo.ClassRegistration;

SELECT Dept, COUNT (EmpID) AS NumFaculty
FROM dbo.ClassRegistration
GROUP BY Dept
ORDER BY Dept;

-- Do you see any problems with the above query?

SELECT Dept, COUNT (DISTINCT EmpID) AS NumFaculty
FROM dbo.ClassRegistration
GROUP BY Dept
ORDER BY Dept;


/*11. GROUP BY: 
	List the CourseID and the average GPA for each course.*/

SELECT CourseID, Avg(GPA) AS AvgGPA
FROM dbo.ClassRegistration
GROUP BY CourseID;


--how to show two decimal places in the average number?
SELECT CourseID, CAST (Avg(GPA) AS DECIMAL (3,2)) AS AvgGPA
FROM dbo.ClassRegistration
GROUP BY CourseID;

--Built in functions
--These functions can be applied on entire tables, but usually used with GROUP BYs.

SELECT AVG (GPA) AS GrandAvgGPA, Count (*) AS NumRows, max(GPA) as maximum
FROM dbo.classRegistration;

/*12. For each course, list the average, standard deviation, minimum and maximum of GPA, and the number of students.
	Order the results by CourseID.*/

SELECT CourseID
		, Avg(GPA) AS AvgGPA
		, STDEV(GPA) AS StdGPA
		, MIN (GPA) AS MinGPA
		, MAX (GPA) AS MaxGPA
		, Count (StuID) AS NumStu
FROM dbo.ClassRegistration
GROUP BY CourseID
ORDER BY CourseID;

--COUNT (*) also works
SELECT CourseID
		, Avg(GPA) AS AvgGPA
		, STDEV(GPA) AS StdGPA
		, MIN (GPA) AS MinGPA
		, MAX (GPA) AS MaxGPA
		, Count (*) AS NumStu
FROM dbo.ClassRegistration
GROUP BY CourseID
ORDER BY CourseID;

--Why do we have nulls for StdGPA?

/*13. GROUP BY multiple columns: 
	Show the number of faculty with different ranks in each department.*/

SELECT * 
FROM dbo.ClassRegistration

SELECT Dept
		, Rank
		, COUNT (*) AS NumFaculty
FROM dbo.ClassRegistration
GROUP BY Dept, Rank
ORDER BY NumFaculty;


/* Optional Question regarding GROUP BY:
Come back to #9: 
List the CourseID and the total number of students in each course.
Let's make slight changes in the question: 
How to include the Course Title column into the above query?
*/

SELECT CourseID, Title, Count (StuID) AS NumStu
FROM dbo.ClassRegistration
GROUP BY CourseID;

--What's the problem of the above code?

--solution 1:
SELECT DISTINCT 
		CourseID
		,Title
		,Count (StuID) AS NumStu
FROM dbo.ClassRegistration 
GROUP BY CourseID, Title;

--solution 2:
SELECT DISTINCT 
        CourseID
		,Title
		,Count (StuID) OVER (PARTITION BY CourseID) AS NumStu
FROM dbo.Import_ClassRegistration

--solution 3 (JOIN + SUBQUERY: will explain in more detail next week):

SELECT	DISTINCT Aggr.CourseID
		, Title
		, NumStu
FROM	dbo.Import_ClassRegistration
INNER JOIN
		(SELECT DISTINCT CourseID
				,Count (StuID) AS NumStu
		FROM dbo.Import_ClassRegistration
		GROUP BY CourseID) AS Aggr
ON Aggr.CourseID= dbo.Import_ClassRegistration.CourseID


/* 14. HAVING:
	List the CourseID, and the total number of students for each course that has less than 3 students. */

SELECT CourseID, Count (StuID) AS NumStu
FROM dbo.ClassRegistration
GROUP BY CourseID --run up to here first
HAVING COUNT (StuID)<3
ORDER BY COUNT (StuID);


--Compare the results with the original table.
SELECT * 
FROM dbo.ClassRegistration


/*15. WHERE and HAVING:
List courses that are offered by the MATH department
 and have less than 3 students.*/

SELECT Title, Count (StuID) AS NumStu
FROM dbo.ClassRegistration
WHERE Dept= 'Math'
GROUP BY Title
HAVING COUNT (StuID)<3
ORDER BY NumStu;

--the following code will not work...
SELECT Title, Count (StuID) AS NumStu
FROM dbo.ClassRegistration
WHERE Dept='Math'
GROUP BY Title
HAVING COUNT (StuID)<3;

/*16. SELECT the student with the highest GPA. */
SELECT *
FROM dbo.ClassRegistration;

--approach 1: step 1
SELECT MAX(GPA) AS MAXGPA
FROM dbo.ClassRegistration;

--approach 1: step 2
SELECT DISTINCT StuID, StuName
FROM dbo.ClassRegistration
WHERE GPA=4.0

--approach 2:
SELECT DISTINCT TOP 1 StuID, StuName, GPA 
FROM dbo.ClassRegistration
ORDER BY GPA DESC;


/*17. SELECT top 3 students with highest GPA. */
SELECT DISTINCT TOP 3 StuID, StuName, GPA 
FROM dbo.ClassRegistration
ORDER BY GPA DESC;

--How to show results with ties?
SELECT DISTINCT TOP 3  WITH TIES StuID, StuName, GPA 
FROM dbo.ClassRegistration
ORDER BY GPA DESC;



/*18. CAST and CONVERT*/

--CAST a decimal to a string
SELECT CAST(GPA as VARCHAR(3)) FROM dbo.ClassRegistration;
SELECT CAST(GPA as INT) FROM dbo.ClassRegistration;
SELECT CAST(ClassTime as DATE) FROM dbo.ClassRegistration;

--Make sure you understand what kind of data each different data type stores
SELECT CAST(GPA as VARCHAR(2)) FROM dbo.ClassRegistration;--see the error message
SELECT CAST(StuName as INT) FROM dbo.ClassRegistration; -- see the error message

--CONVERT
SELECT CONVERT(INT, GPA) FROM dbo.ClassRegistration;
SELECT CONVERT (VARCHAR (3), GPA) FROM dbo.ClassRegistration;


/*19. Functions for Numeric Data*/
--a.
SELECT ABS(-100)
SELECT ROUND(12.55, 1)
SELECT ROUND(12.55, 0)
SELECT FLOOR(12.55)
SELECT CEILING(12.01)

--(Optional)
SELECT SQUARE(2)
SELECT SQRT(36)
SELECT SQRT(7)
SELECT EXP(20)
SELECT LOG(485165195.40979)
SELECT EXP( LOG(20)), LOG( EXP(20))
SELECT PI()

--b.
SELECT 10 % 2
SELECT 11 % 2
SELECT 9 % 3
SELECT 10 % 3


/*20. Functions for Strings*/
--a.
SELECT StuName
		, UPPER(StuName) AS UpperName
		, LOWER(StuName) AS LowerName 
		, SUBSTRING(StuName, 1, 2) AS FirstTwoChar--String, Starting Position, Length
		, LEN(StuName) AS NameLen
FROM dbo.ClassRegistration;

--b.
SELECT StuName, CHARINDEX('e',StuName,1) AS Position FROM dbo.ClassRegistration; --Character to find, String to search, Starting Position
SELECT StuName, CHARINDEX('e',StuName,5) AS Position FROM dbo.ClassRegistration; 
--The CHARINDEX and PATINDEX functions return the starting position of a pattern you specify. 
--PATINDEX can use wildcard characters, but CHARINDEX cannot.

SELECT Title, CHARINDEX('program',Title) FROM dbo.ClassRegistration; 
SELECT Title, PATINDEX('%program%',Title) FROM dbo.ClassRegistration; 

SELECT	Room
		, SUBSTRING(Room, 1, CHARINDEX('-', Room, 1) - 1) AS RoomNum 
FROM dbo.ClassRegistration;

SELECT *
FROM  dbo.ClassRegistration;

--c.
SELECT	CourseID
		, LEFT(CourseID,3) AS LeftThree
		, LEFT(CourseID,10) AS LeftTen 
		, RIGHT(CourseID,3) AS RightThree 
		, RIGHT(CourseID,10) AS RightTen 
		, REVERSE(CourseID) AS ReverseString
FROM dbo.ClassRegistration;

--d.
SELECT	CourseID
		, REPLACE(CourseID, 'CIS', 'IS') AS ReplacedCourse
FROM dbo.ClassRegistration;

Select *
FROM dbo.ClassRegistration;

--Does not change the table unless you run an update

--e.

SELECT	ISNUMERIC(StuAge) AS NAge
		, ISNUMERIC(StuName) AS NStuName 
		, ISDATE(ClassTime) AS TClassTime
		, ISDATE(SAddress) AS TAddress
FROM dbo.ClassRegistration;

--f (Opational).  LTRIM(), RTRIM(), will remove spaces on the left or right of a string.
SELECT LTRIM('  TEST'), '   TEST';
SELECT RTRIM('TEST   '), 'TEST   ';

SELECT RTRIM(LTRIM(' TEST '));

--g (Optional). 
SELECT STUFF('I like Data Management', 8, 0, 'to learn '); -- STUFF(source_string, start to delete, length to delete, add_string)
SELECT STUFF('I like Data Management', 8, 5, 'to learn ');

--h.
SELECT CONCAT('Test', 'Test1', 'Test2');
SELECT 'Test' + 'Test1' + 'Test2';
SELECT 'Test' + ' ' + CAST(5.0 as varchar(5)) AS Output;
SELECT CONCAT('Test', ' ', 5.0);



/*21. Functions for DATE and DATETIME*/
--We'll use getdate() to practice with, this can be applied to any date columns

SELECT getdate();
SELECT CAST(getdate() as DATE);
SELECT DATEPART(Day, getdate());
SELECT DATEPART(Week, getdate());
SELECT DATEPART(Weekday, getdate()); --What number is Monday?
SELECT DATEPART(Month, getdate());
SELECT DATEPART(Quarter, getdate());
SELECT DATEPART(Year, getdate());

--Why are Day and Week (etc.) just numbers?
SELECT DATENAME(Day, getdate()); 
SELECT DATENAME(Week, getdate()); 
SELECT DATENAME(Weekday, getdate()); 
SELECT DATENAME(Month, getdate()); 
SELECT DATENAME(Quarter, getdate());
SELECT DATENAME(Year, getdate());

--(Optional)
SELECT CONVERT(VARCHAR(8), getdate(), 4) AS [DD.MM.YY];
SELECT CONVERT(VARCHAR(10), getdate(), 102) AS [YYYY.MM.DD];
SELECT CONVERT(VARCHAR(10), getdate(), 111) AS [YYYY/MM/DD];
SELECT CONVERT(VARCHAR(10), getdate(), 11) AS [YY/MM/DD];
SELECT CONVERT(VARCHAR(19), getdate(), 120) AS [YYYY-MM-DD hh:mm:ss];
SELECT CONVERT(VARCHAR(8), getdate(), 112) AS [YYYYMMDD];
SELECT CONVERT(VARCHAR(6), getdate(), 12) AS [YYMMDD]


--DATEDIFF 
SELECT DATEDIFF(day, '2016-08-15', getdate());
SELECT DATEDIFF(day, getdate(), '2016-08-15');

SELECT DATEDIFF(year, '2016-08-15', getdate());
SELECT DATEDIFF(month, '2016-08-15', getdate());

--Another example, could be the last day in a month vs. first day in a month
SELECT DATEDIFF(month, '2014-02-01', '2014-01-31');

--DATEADD
SELECT DATEADD(month, -1, getdate());
SELECT DATEADD(day, -1, getdate());
SELECT DATEADD(year, -1, getdate());
SELECT DATEADD(month, 1, getdate());
SELECT DATEADD(day, 1, getdate());
SELECT DATEADD(year, 1, getdate());

SELECT DATEADD(month, 1, '2015-01-31')
SELECT DATEADD(month, 1, '2015-02-28') --error message?

SELECT * 
 FROM dbo.ClassRegistration
WHERE ClassTime < DATEADD(year, -2, getdate())


/*22. Relational Operators*/

--IN (or NOT IN): look for multiple values 
SELECT * 
 FROM dbo.ClassRegistration
WHERE (Dept ='MATH' 
		OR Dept = 'CSC'); --This query is equivalent to:

SELECT * 
 FROM dbo.ClassRegistration
WHERE Dept IN ('MATH', 'CSC');

--IS NULL: 

SELECT 	CourseID,  STDEV (GPA) AS StdGPA 
FROM 	dbo.ClassRegistration 
GROUP BY CourseID
HAVING STDEV (GPA) IS NULL;


--You can use basic math within a SQL Query:
SELECT StuID, StuName, StuAge, StuAge+2 AS NewAge
 FROM dbo.ClassRegistration; 


SELECT StuID, StuName, StuAge, StuAge+2 AS NewAge
 FROM dbo.ClassRegistration 
WHERE (StuAge+2)  > 30;

--Run the following code. Any error message?
SELECT StuID, StuName, StuAge, StuAge+2 AS NewAge
 FROM dbo.ClassRegistration 
WHERE (StuAge+2)> 30;

--Cannot use Alias in WHERE clauses

SELECT StuID, StuName, StuAge, StuAge+1 AS PlusOneAge, StuAge-1 AS MinusOneAge
 FROM dbo.ClassRegistration; 

--Above query is difficult to read, so you should separate the SELECT portion of the query 

SELECT	StuID
		, StuName
		, StuAge
		, StuAge+1 AS PlusOneAge
		, StuAge-1 AS MinusOneAge
 FROM dbo.ClassRegistration; 


