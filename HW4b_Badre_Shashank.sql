/*	
	IS6030 Homework 4b 
*/


/*--------------------------------------------------------------------------------------
Instructions:

You will be using the Baltimore Parking Citations data set (14,705 rows)
(this is only a snapshot of all citations for Baltimore).

The name of your table should be called dbo.ParkingCitations.

Answer each question as best as possible.  
Show your work if you need to take multiple steps to answer a problem. 
Partial answers will count.
--------------------------------------------------------------------------------------*/

/* 
	You can run this query to check your table, if it does not run or you do not get 14,705 rows,
    you should revisit your import/table.  Before you do anything, make sure your data/table is correct!
	
	Reminder: Please check which database you imported data into and which database you are working with.
*/
/*
SELECT *
FROM (  SELECT ParkingCitationID
		, ROW_NUMBER () OVER (PARTITION BY ParkingCitationID ORDER BY ParkingCitationID) AS RowNumber
	FROM ParkingCitations) AS DupRow
WHERE DupRow.RowNumber > 1;*/

	SELECT *
	FROM dbo.ParkingCitations; 

/* Q1. (1 point)
		Show the number of Citations, Total Fine amount, by Make and Violation Date. 
        Sort your results in a descending order of Violation Date and in an ascending order of Make.
		Hint: Check the data type for ViolDate and see whether any transformation is needed.
*/

/* Q1. Query */
		
------Result as per Datetime format of Violation Date is below
Select Make, ViolDate, count(citation) as NumberCitations, sum(ViolFine) as TotalFine  from dbo.ParkingCitations
group by Make, ViolDate order by  ViolDate DESC, Make ASC;

-------------Result as per Date format of Violation Date is below
SELECT Make, CONVERT(date, ViolDate) as Viol_Date,
 COUNT (citation) as NumberCitations, Sum(ViolFine) as TotalFine
FROM dbo.ParkingCitations
GROUP BY Make,CONVERT(date, ViolDate)
ORDER BY CONVERT(date, ViolDate) desc, Make asc;

/* Q2. (0.5 point)
	Display just the State (2 character abbreviation) that has the most number of violations.

*/

/* Q2. Query */

Select State from (
Select State,
       TotalViolation,
       Rank() over (order by TotalViolation desc) as Ranking from 
	   (
Select distinct State, 
       Count(State) OVER(Partition by State)  as TotalViolation
	   from dbo.ParkingCitations) as t) as F
	   where F.Ranking = 1

-----or

Select Top 1 State from dbo.ParkingCitations 
group by State 
order by count(state) desc;

	   

/* Q3. (1 point)
	   Display the number of violations and the tag, for any tag that is registered at Maryland (MD) and has 6 or more violations. 
	   Order your results in a descending order of number of violations.
*/

/* Q3. Query */
-- SELECT distinct(Tag) FROM dbo.ParkingCitations where state = 'MD'		
-- SELECT * FROM dbo.ParkingCitations 


Select  Tag, count(tag) as NumberofViolations from dbo.ParkingCitations 
where State = 'MD'
group by State, tag
having count(tag) >= 6
order by count(tag)

/* Q4. (0.5 point)
	Use functions and generate a one column output by formatting the data into this format 
	(I'll use the first record as an example of the format, you'll need to apply this to all records with State of MD):	
			15TLR401 - Citation: 98348840 - OTH - Violation Fine: $502.00 
*/
--SELECT * FROM dbo.ParkingCitations; 
/* Q4. Query */
		
GO

Create PROC newformat ( @State_1 AS VARCHAR (MAX)) 
 AS
BEGIN 
		SELECT
			Tag + ' - Citation: ' + Citation + ' - ' + Make + ' - Violation Fine: $' + cast(ViolFine as varchar(10)) as FormatColumn
			from 
			dbo.ParkingCitations
		WHERE 
			State Like @State_1
END

EXEC newformat @State_1='MD'


/* Q5. (0.5 point)
	   Write a query to calculate which states MAX ViolFine differ more than 200 from MIN VioFine 
	   Display the State Name and the Difference.  Sort your output by State A->Z.
*/

/* Q5. Query */

Select State, Maximum - Minimum as Difference from
(Select state, max(ViolFine) as Maximum, min(ViolFine) as Minimum from dbo.ParkingCitations 
group by State
having (max(Violfine)-min(ViolFine)) > 200) as temp
order by State;



/* Q6. (1 point)
	   You will need to bucket the entire ParkingCitations database into three segments by ViolFine. 
	   Your first segment will include records with ViolFine between $0.00 and $50.00 and will be labled as "01. $0.00 - $50.00".
	   The second segment will include records with ViolFine between $50.01 and $100.00 and will be labled as "02. $50.01 - $100.00".
	   The final segment will include records with ViolFine larger than $100.00 and will be labled as"03. larger than $100.00". 

	   Display Citation, Make, VioCode, VioDate, VioFine, and the Segment information in an descending order of ViolDate. 	    
*/ 
-- SELECT * FROM dbo.ParkingCitations 
/* Q6. Query */

Select Citation, Make, ViolCode, ViolDate,
       ViolFine,
	   CASE 
		WHEN ViolFine between 0.00 and 50.00 THEN '01. $0.00 - $50.00'
		WHEN ViolFine between 50.01 and 100.00 THEN '02. $50.01 - $100.00'
		WHEN ViolFine > 100.00 THEN '03. larger than $100.00'	
		ELSE 'Invalid'
	  END AS FineSegment
FROM dbo.ParkingCitations   
order by ViolDate desc



/* Q7. (0.5 point)
	   Based on the three segments you created in Q6, display the AVG ViolFine and number of records for each segment. 
	   Order your output by the lowest -> highest segments.   
*/ 

/* Q7. Query */

Select FineSegment, Avg(ViolFine) as AverageFine, Count(ViolFine) CountRecords from
(Select Citation, Make, ViolCode, ViolDate,
       ViolFine,
	   CASE 
		WHEN ViolFine between 0.00 and 50.00 THEN '01. $0.00 - $50.00'
		WHEN ViolFine between 50.01 and 100.00 THEN '02. $50.01 - $100.00'
		WHEN ViolFine > 100.00 THEN '03. larger than $100.00'	
		ELSE 'Invalid'
	  END AS FineSegment
FROM dbo.ParkingCitations   
) as temp
group by FineSegment
order by FineSegment






/* Q8. Bonus Question (0.1 point):
	   You may share any challenge(s) you face while finishing the assignment and how you overcome the challenge.
*/
I found question 4 in 4b  a difficult one. By refering class practices and slides I was able to solve it.
 Also, it is not easy to join multiple tables when multiple conditions in the form of aggregation is given.
 I used pen and paper so that i understand the scenarios and it helped me in visualizing the data.

/* Q8. Answer */