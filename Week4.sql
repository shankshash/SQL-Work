
 /* IS6030 Week 4 Querying Multiple Tables 
   PART I. JOINs
 */

RETURN;

CREATE DATABASE WeekFourDemo; -- Or use an existing database you created.
USE WeekFourDemo;

/*1. Run the following code to create the Employee table and the Department table.*/

IF OBJECT_ID('dbo.Employee', 'U') IS NOT NULL DROP TABLE dbo.Employee; 
IF OBJECT_ID('dbo.Department', 'U') IS NOT NULL DROP TABLE dbo.Department;

Create Table Employee
	(EmployeeID VARCHAR (5) PRIMARY KEY NOT NULL,
	NAME VARCHAR (30) NOT NULL,
	DeptID INT NULL
	);

Insert INTO Employee Values ('AA', 'Lucy', 1);
Insert INTO Employee Values ('BB', 'Luke', 2);
Insert INTO Employee Values ('CC', 'Jessica', 4);
Insert INTO Employee Values ('DD', 'Daisy', 5);
Insert INTO Employee Values ('EE', 'Brain', NULL);

Create Table Department
	(DeptID INT Primary Key NOT NULL,
	Department VARCHAR (30) NOT NULL,
	);

Insert INTO Department Values (1, 'Clothing');
Insert INTO Department Values (2, 'Electronics');
Insert INTO Department Values (3, 'Furniture');
Insert INTO Department Values (6, 'Cosmetics');

SELECT * FROM Employee;
Select * from Department;

/* 2. Why do we need a join?*/
--By table Employee: we can only see deptID for each employee
SELECT * FROM Employee;

--How to get the name of the department for Employees?

SELECT * FROM Department WHERE DeptID=1;

--By joining two tables, we can get the information all together

SELECT *
FROM Employee EMP
INNER JOIN 
Department DEPT
ON DEPT.DeptID=EMP.DeptID;


/* 3. In order for SQL to know which fields you are talking about from which table, you often "alias" the table. 
You do this by putting a shorten name after the name of the table. */

SELECT * FROM dbo.Employee EMP; 
SELECT * FROM dbo.Department DEPT;

-- If you don't use alias, you can join tables like this: 

SELECT * 
 FROM Employee 
INNER JOIN Department 
 ON Employee.DeptID = Department.DeptID;

--But that is a lot more typing and not recommended.

/* 4. CROSS JOIN */

SELECT * FROM dbo.Employee EMP; -- how many rows and columns?
SELECT * FROM dbo.Department DEPT; -- how many rows and columns?

SELECT * 
FROM Employee
CROSS JOIN Department; -- how many rows and columns?



/* 5. INNER JOIN */
SELECT * 
FROM Employee EMP
INNER JOIN Department DEPT
ON EMP.DeptID = DEPT.DeptID;

--Equivalent to 
SELECT * 
FROM Employee EMP
CROSS JOIN Department DEPT
WHERE EMP.DeptID=DEPT.DeptID;

--Equivalent to
SELECT * 
FROM Employee EMP, Department DEPT
WHERE EMP.DeptID = DEPT.DeptID;

/* 6. LEFT OUTER JOIN */
SELECT * 
 FROM Employee EMP
LEFT OUTER JOIN Department DEPT
 ON EMP.DeptID = DEPT.DeptID;

 
 --There is NO LEFT INNER JOINs so you can actually use the syntax LEFT JOIN
 --For this class you are suggested to write OUTER explicitly

/* 7. LEFT OUTER JOIN IS NULL*/
 SELECT * 
 FROM Employee EMP
LEFT OUTER JOIN Department DEPT
 ON EMP.DeptID = DEPT.DeptID
WHERE DEPT.DeptID IS NULL;


/* 8. RIGHT OUTER JOIN */
SELECT * 
 FROM Employee EMP
RIGHT OUTER JOIN Department DEPT
 ON EMP.DeptID = DEPT.DeptID;

--Most people don't write RIGHT OUTERs as you can just put the table you are concerned with as the first table and write a LEFT OUTER.

SELECT * 
FROM Department DEPT 
LEFT OUTER JOIN Employee EMP
ON DEPT.DeptID = EMP.DeptID;


/* 9. FULL OUTER JOIN */
SELECT * 
 FROM Employee EMP
FULL OUTER JOIN Department DEPT
 ON EMP.DeptID = DEPT.DeptID;

 
/* 10. FULL OUTER JOIN IS NULL */
SELECT * 
 FROM Employee EMP
FULL OUTER JOIN Department DEPT
 ON EMP.DeptID = DEPT.DeptID
WHERE EMP.DeptID IS NULL 
OR DEPT.DeptID IS NULL;


/* 11. INNER JOIN WITH WHERE */
SELECT * 
FROM Employee EMP
INNER JOIN Department DEPT
ON EMP.DeptID = DEPT.DeptID;


--You can add other keywords we learned to pull more useful data
SELECT	EMP.EmployeeID
		, EMP.Name
		, EMP.DeptID
		, DEPT.Department
FROM Employee EMP
INNER JOIN Department DEPT
ON EMP.DeptID = DEPT.DeptID
WHERE EMP.Name = 'Lucy';

/* IS6030 Week 4 Querying Multiple Tables
   PART II. Subqueries
*/

/*Run the following code to re-populate the Employee table and the Department tabel.*/

IF OBJECT_ID('dbo.Employee', 'U') IS NOT NULL DROP TABLE dbo.Employee; 
IF OBJECT_ID('dbo.Department', 'U') IS NOT NULL DROP TABLE dbo.Department;

Create Table dbo.Employee
(EmployeeID VARCHAR (5) PRIMARY KEY NOT NULL,
Name VARCHAR (30) NOT NULL,
Salary DECIMAL (19,2) NULL,
DeptID INT NULL
);

Insert INTO Employee Values ('AA', 'Lucy', 5000.00,1);
Insert INTO Employee Values ('BB', 'Luke', 6500.00,2);
Insert INTO Employee Values ('CC', 'Jessica', 4400.50,4);
Insert INTO Employee Values ('DD', 'Daisy', 5200.35,5);
Insert INTO Employee Values ('EE', 'Brain', 4000.10, 7);
Insert INTO Employee Values ('FF', 'Emily', 5500.00,1);
Insert INTO Employee Values ('GG', 'Clara', 7500.00,1);
Insert INTO Employee Values ('HH', 'William', 6400.50,4);
Insert INTO Employee Values ('II', 'Erin', 5200.35,5);
Insert INTO Employee Values ('JJ', 'Joshua', 6890.10, 2);
Insert INTO Employee Values ('KK', 'Alex', 4280.50,1);
Insert INTO Employee Values ('LL', 'Hanna', 3500.00,2);
Insert INTO Employee Values ('MM', 'Ethan', 6400.50,5);
Insert INTO Employee Values ('NN', 'Evan', 5350.45,4);
Insert INTO Employee Values ('OO', 'Nancy', 6740.10, 2);


Create Table dbo.Department
(DeptID INT Primary Key NOT NULL,
Department VARCHAR (30) NOT NULL,
);

Insert INTO Department Values (1, 'Clothing');
Insert INTO Department Values (2, 'Electronics');
Insert INTO Department Values (3, 'Furniture');
Insert INTO Department Values (4, 'Appliances');
Insert INTO Department Values (5, 'Outdoor');
Insert INTO Department Values (6, 'Cosmetics');



SELECT * FROM Employee;
SELECT * FROM Department;

 
--Subquery Returning A Single Value:
 
 /* 12. List names of employees who work in the Clothing department (WHERE Subquery).*/
-- Using two queries
SELECT	 DeptID
	FROM	 Department
	WHERE 	 Department='Clothing'; -- output is 1

SELECT 	Name 
FROM 	Employee
WHERE 	DeptID 	=1;
	
--Using a subquery
SELECT 	Name 
FROM 	Employee
WHERE 	DeptID 	=
	(
	SELECT	 DeptID
	FROM	 Department
	WHERE 	 Department='Clothing'
	);


-- Equivalent to
SELECT 	Name 
FROM 	Employee
WHERE 	DeptID 	IN
	(
	SELECT	 DeptID
	FROM	 Department
	WHERE 	 Department='Clothing'
	);


/* 13. List all employees whose salary is below the average salary in the company (WHERE Subquery).*/
SELECT 	EmployeeID, Name, Salary
FROM 	Employee
WHERE 	Salary 	< 
	(
	SELECT AVG (Salary)
	FROM 	Employee
	);



-- (Optional) How about: List all employees whose salary is below the average salary in their department? (See #17 & #19 for answers)

/* 14. Display all the departments that have a minimum salary greater than that of department 1 (HAVING Subquery). */
SELECT	DeptID, MIN (Salary)as MinSalary
FROM	Employee
GROUP BY DeptID
HAVING	MIN (Salary) >
	(
	SELECT MIN (Salary)
	FROM Employee
	WHERE DeptID=1
	);


-- Subquery returning a list of values:

/* 15. List names of employees whose department is listed in the department table (WHERE Subquery). */

SELECT 	Name 
FROM 	Employee
WHERE 	DeptID IN
	(
	SELECT	 DeptID
	FROM	 Department
	);

-- IN is used when subquery returned list of values; = is used when subquery returned one single value


/* 16. List names of employees whose department is not listed in the department table (WHERE Subquery).*/
SELECT 	Name
FROM 	Employee
WHERE 	DeptID  NOT IN 
	(
	SELECT 	DeptID
	FROM	Department
	 );

/* 17. Display the department with the lowest average salary (ALL in HAVING Subquery). */
SELECT		DeptID, AVG (Salary) AS AvgSalary
FROM		Employee
GROUP BY 	DeptID
HAVING		AVG (Salary) <= ALL
			(
			SELECT AVG(Salary)
			FROM Employee
			GROUP BY DeptID
			);

-- All (Optional)
-- List employees whose salary is lower than the average salary of each department. */
SELECT 	EmployeeID, Name, Salary
FROM 	Employee
WHERE 	Salary 	< ALL
	(
	SELECT AVG (Salary)
	FROM 	Employee
	GROUP BY DeptID
	);

-- Any (Optional)
-- List employees whose salary is lower than the average salary of at least one department. */
SELECT 	EmployeeID, Name, Salary
FROM 	Employee
WHERE 	Salary 	< ANY
	(
	SELECT AVG (Salary)
	FROM 	Employee
	GROUP BY DeptID
	);

--Subquery Returning A Table

/* 18. What is the average of the total salary paid to employees in each department (FROM Subquery). */


/* 19. List all employees whose salary is below the average salary in their department (FROM Subquery).*/
SELECT EmployeeID, Name, Employee.DeptID, Salary, DeptAvgSal
FROM Employee
INNER JOIN 
	 ( SELECT DeptID, Avg (Salary) DeptAvgSal
		FROM Employee
		Group by DeptID 
	  ) DeptSalary
ON Employee.DeptID=DeptSalary.DeptID
WHERE Employee.Salary < DeptSalary.DeptAvgSal;



/* 20. Subquery compare SUM Salary with AVG Salary MAX Salary across departments (Combine Subqueries and JOIN).*/

SELECT *
FROM
 (
	SELECT AVG(Salary) as AvgSalary, DeptID
	 FROM dbo.Employee
	GROUP BY DeptID
) AvgSal

INNER JOIN
(
	SELECT SUM(Salary) as SumSalary, DeptID
	 FROM dbo.Employee
	GROUP BY DeptID
) SumSal

 ON AvgSal.DeptID = SumSal.DeptID 

INNER JOIN 
(
	SELECT MAX(Salary) as MaxSalary, DeptID 
	 FROM dbo.Employee
	GROUP BY DeptID
) MaxSal
 ON AvgSal.DeptID = MaxSal.DeptID;