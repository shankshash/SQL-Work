RETURN;
--Homework #3b Querying Multiple Tables
--Your Name:

/*--------------------------------------------------------------------------------------
Instructions:

You will be using the Chicago Salary table but you will following the questions 
to normalize the data in order to provide a table structure to test your JOIN abilities. 

You can use the original summary table to double check any answers.

Answer each question as best as possible.  
Show your work if you need to take multiple steps to answer a problem. 
Partial answers will count.
--------------------------------------------------------------------------------------*/


/* 
Q1. (0.5 point)
	Write the syntax to drop and build a table called dbo.Employee. 
	Create an EmployeeID field (IDENTITY PK), a Name field and a Salary field for the Employee table.
	Populate the Employee table with unique Name and Salary information from the dbo.ChicagoSalary table.
*/


/* Q1. Syntax*/


IF OBJECT_ID('dbo.Employee', 'U') IS NOT NULL DROP TABLE dbo.Employee;

Create table dbo.Employee(
EmployeeID INT Identity Primary Key,
Name nVarchar(255),
Salary money,
);

Insert into dbo.Employee(Name, Salary) 
Select distinct Name , Salary from dbo.ChicagoSalary;

/*Select * from Employee;*/

/*Select distinct Name , Salary from dbo.ChicagoSalary;*/


/* Q2. (0.5 point)
	Write the syntax to drop and build a table called dbo.Department.
	Create an DepartmentID field (IDENTITY PK), and a Name field for the Department Table.
	Populate the Department table with unique Department Names.
*/

/* Q2. Syntax */
 
 IF OBJECT_ID('dbo.Department', 'U') IS NOT NULL DROP TABLE dbo.Department;

 Create table dbo.Department(
DepartmentID INT Identity Primary Key,
Name nVarchar(255),
);

Insert into dbo.Department(Name) 
Select distinct Department from dbo.ChicagoSalary;

/* Select * from Department;*/

/* Q3. (0.5 point)
	Write the syntax to drop and build a table called dbo.Position.
	Create an PositionID field (IDENTITY PK), and a Name field for the Position table.
	Populate the Position table with unique PositionTitles (call the field Title).
*/

/* Q3. Syntax */

 IF OBJECT_ID('dbo.Position', 'U') IS NOT NULL DROP TABLE dbo.Position;

 Create table dbo.Position(
PositionID INT Identity Primary Key,
Title nVarchar(255),
);

Insert into dbo.Position(Title) 
Select distinct PositionTitle  from dbo.ChicagoSalary;





/* Run the following query to populate a Employment table to help build the relationship between the above three tables. */

/*
IF OBJECT_ID('dbo.Employment','U') IS NOT NULL DROP TABLE dbo.Employment;

SELECT DISTINCT IDENTITY(INT,1,1)  EmploymentID
		, EmployeeID
		, PositionID
		, DepartmentID
 INTO dbo.Employment
FROM dbo.ChicagoSalary CS
INNER JOIN dbo.Employee E on CS.Name = E.Name and CS.Salary = E.Salary 
INNER JOIN dbo.Position P on P.Title = CS.PositionTitle  
INNER JOIN dbo.Department D on D.Name = CS.Department;


Select * from dbo.Employment;
*/

/* Q4. (0.5 point)
	Display the same output as the dbo.ChicagoSalary table but use the new 4 tables you created.
*/

/* Q4. Syntax*/

/*Select * from dbo.ChicagoSalary;*/

Select EE.Name as Name, Title,d.Name as Department, Salary 
from dbo.Employee as EE
cross join  dbo.Employment as CS
cross join dbo.Department as D
cross join  dbo.Position as P
where 
 CS.EmployeeID = EE.EmployeeID
AND CS.DepartmentID = D.DepartmentID
AND CS.PositionID = P.PositionID;



/* Q5. (1 point)
	Using the new tables and JOINs to display Number of Employees and Average Salary in the Police department.
*/

/*Q5. Syntax*/

Select count(E.EmployeeID) as NumberOfEmployees, Avg(Salary) as AverageSalary
from dbo.Employment as CS 
inner join dbo.Employee as E on CS.EmploymentID = E.EmployeeID
inner join dbo.Department as D on CS.DepartmentID = D.DepartmentID
where D.name ='Police'
group by D.name;




/* Q6. (1 point)
	Using the new tables and JOINs to provide the Number of Employees and Total Salary of Each Department.
	Sort the output by Department A->Z.
*/

/*Q6. Syntax*/

Select count(E.EmployeeID) as NumberOfEmployees, sum(Salary) as TotalSalary, D.name as Department
from dbo.Employment as CS 
inner join dbo.Employee as E on CS.EmploymentID = E.EmployeeID
inner join dbo.Department as D on CS.DepartmentID = D.DepartmentID
group by D.name
order by D.name;





/* Q7. (1 point)
	Using the new table(s) and subqueries to list the name(s) and salary of employee(s) whose last name is Aaron and work for the POLICE department. 
*/ 

/*Q7. Syntax*/


Select Name, Salary From dbo.Employee
where Name Like 'Aaron%'
      AND EmployeeID in 
	  (Select EmployeeID FROM dbo.Employment
	  where DepartmentID = 
	  (Select DepartmentID FROM dbo.Department
	  where Name ='Police'
	  ));

/*Q7. Answer:
Name= AARON,  JEFFERY M  
Salary= 75372.00
*/

 

/* Q8. (1 point)
	Display the name(s) of the people who have the longest name(s) 
*/

/* Q8. Syntax */

Select Top 1 with Ties  Name  from dbo.Employee order by len(name) desc;



/* Q8.Answer: 'CLEMONS SAMS,  MICHAEL ANTHONY C' and 'WRZESNIEWSKA KOZAK,  ANNABELLA M'

*/


					 
/*Q9. (Bonus: 0.1 point)
	You may share any challenge(s) you face while finishing the assignment and how you overcome the challenge.
*/

 /* Q9.Answer: 

 I found question 3 in 3a  difficult one. By refering class practices and slides I was able to solve it.
 Also, it is not easy to join multiple tables and visualize data. I used pen and paper so that i understand the scenarios.

*/
