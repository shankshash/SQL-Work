/*	
	IS6030 Homework 4a 
*/


/*--------------------------------------------------------------------------------------
Instructions:

You will be using the StudentDinner database we created in class to answer the following questions.

Please download the StudentDinner.sql and execute the file to create the StudentDinner database
if you have not done so in class.

Answer each question as best as possible.  
Show your work if you need to take multiple steps to answer a problem. 
Partial answers will count.
--------------------------------------------------------------------------------------*/


/*Q1. (0.5 point)
	List the restaurant according to their average ratings, from the highest to the lowest.*/
/* Q1. Query */

/*select * from Dinner;
select RID, Avg(Rating) from Dinner group by RID;*/


Select R.Rname as Restaurant, Avg(temp.Rating_1) as AvgRating from Restaurant as R
inner join 
(Select RID, cast(Rating as Decimal (3,2)) as Rating_1
from Dinner) temp 
on R.RID = temp.RID
group by R.Rname
order by Avg(temp.Rating_1) desc;



/*Q2. (0.5 point)
	List the names of student who eat out every single day of the week.*/
/* Q2. Query */



Select SName from Student where SID IN 
(Select SID from Dinner group by SID having count(distinct DinnerDay) =7);



/*Q3. (1 point)
	List the restaurant whose total earning is greater than $100 and does not have a phone number, with the highest earning restaurant at the top.*/
/* Q3. Query */

/*Select * from dinner*/
/*Select * from restaurant*/
/*Select * from Student*/

Select R.Rname, sum(D.Cost) as Earning from dbo.Restaurant as R inner join dbo.Dinner as D 
on R.RID = D.RID
where R.Phone is Null group by R.Rname having sum(D.cost) > 100
order by sum(D.cost) desc;


/*Q4. (1 point)
	List the student according to the total distance they travel for dinner.*/
/* Q4. Query */

Select S.Sname, sum(R.LCBDistance) as DistanceTravelled from dbo.Student as S
left outer join dbo.Dinner as D
on S.SID = D.SID
left outer join dbo.Restaurant as R
on R.RID = D.RID
group by S.Sname
order by sum(R.LCBDistance) desc;



/*Q5. (1 point)
	List the names of student who do not like to eat out on Thursdays.*/
/* Q5. Query */

Select Sname from Student where Sname not in (
Select distinct S.Sname from Student as S left outer join Dinner as D
on S.SID = D.SID
where D.DinnerDay = 'Thursday');



/* Select * from dbo.Dinner   */

/*Q6. (1 point)
	For each major, list the total amount of money students spent on dinner, 
	and their number of visits to restaurants during the weekends (Saturdays and Sundays).*/	
/* Q6. Query */

Select M.Major, sum(D.Cost) as MoneySpent, count(D.DinnerDay) as Visits  
from Major as M left outer join Student as S
On M.MID = S.MID
left outer join Dinner as D on
S.SID = D.SID
where D.DinnerDay in ('Saturday','Sunday')
group by M.Major


