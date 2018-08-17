RETURN;

--Homework #3a Querying Multiple Tables
--Your Name:

/*--------------------------------------------------------------------------------------
Instructions:

If you haven't done so in class, please download and run the entire syntax in the MovieDatabase.sql file to establish a Movies database.
Answer the following questions as best as possible.
Show your work if you need to take multiple steps to answer a problem. 
Partial answers will count.
--------------------------------------------------------------------------------------*/



/*Q1. (0.5 point)
List Film Name, Director Name, Studio Name, and Country Name of all films.*/

/*Q1. Syntax*/

Select FilmName, DirectorName, StudioName, CountryName from dbo.tblFilm as F
full outer join dbo.tblDirector as D 
on F.FilmDirectorID = D.DirectorID
full outer join dbo.tblStudio as S
on F.FilmStudioID = S.StudioID
full outer join dbo.tblCountry as C
on F.FilmCOuntryID = C.CountryID
where F.FilmName is not null;

	

/*Q2. (0.5 point)
List people who have been actors but not directors.*/

/*Q2. Syntax*/
 Select ActorName from dbo.tblActor as A left outer join 
 dbo.tblDirector as D on A.ActorName = D.DirectorName where D.DirectorName is NULL;

 /*Select count(*) from dbo.tblActor;*/




/*Q3. (1 point)
List actors that have never been directors and directors that have never been actors.*/

/*Q3. Syntax*/

 Select Only_Actor, Only_Director from 
 (Select ActorName as Only_actor from dbo.tblActor as A left outer join 
 dbo.tblDirector as D on A.ActorName = D.DirectorName where D.DirectorName is NULL) as OA
 full outer join
  ( Select DirectorName as Only_Director from dbo.tblDirector as td left outer join 
 dbo.tblActor as ta on  td.DirectorName = ta.ActorName where ta.ActorName is NULL) as OD
 on OA.Only_Actor = OD.Only_Director;

 



/*Q4. (1 point)
List all films that are released in the same year when the film Casino is released.*/

/*Q4. Syntax*/

Select FilmName from dbo.tblFilm where DATEPART(Year, FilmReleaseDate) =  (
Select DATEPART(Year, FilmReleaseDate) from dbo.tblFilm where FilmName = 'Casino');



/*Q5. (0.5 point)
Using JOIN to list films whose directors were born between '1946-01-01' AND '1946-12-31'. */

/*Q5. Syntax*/

Select FilmName from dbo.tblFilm as F inner join dbo.tblDirector as D 
on F.FilmDirectorID = D.DirectorID
where cast(D.DirectorDOB as Date) between '1946-01-01' AND '1946-12-31';



/*Q6. (0.5 point)
Using subquery to list films whose directors were born between '1946-01-01' AND '1946-12-31'. */

/*Q6. Syntax*/


Select FilmName from dbo.tblFilm where FilmDirectorID IN (Select DirectorID from dbo.tblDirector 
where cast(DirectorDOB as Date) between '1946-01-01' AND '1946-12-31');

