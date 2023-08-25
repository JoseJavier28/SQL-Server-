
CREATE DATABASE SpaceFlights
DROP DATABASE SpaceFlights

USE SpaceFlights

CREATE TABLE Company (
	Company_ID INT,
	Company_Space_Agency NVARCHAR(50),
	Country NVARCHAR(50)
	CONSTRAINT Prim_COMP PRIMARY KEY (Company_ID)
)

INSERT INTO Company VALUES (100, 'Blue Origin', 'United States'),
	(106, 'Space Adventures, Inc.', 'Japan'),
	(108, 'NASA', 'United States'),
	(109, 'ESA', 'Germany'),
	(111, 'CMS', 'China'),
	(112, 'Space X', 'United States'); 

	SELECT * FROM Company;

CREATE TABLE Astronaut (
	Astronaut_ID int ,
	Astronaut_Name NVARCHAR(50),
	Missions int,
	Days_In_Space int,
	Still_In_Space NVARCHAR(50),
	Company_ID int,
	CONSTRAINT Prim_AUST PRIMARY KEY (Astronaut_ID),
	CONSTRAINT foreign_Aust FOREIGN KEY (Company_ID) REFERENCES COMPANY (Company_ID) )

INSERT INTO Astronaut VALUES (612, 'Cameron', 1, 3, NULL, 100),
	(611,'Lane', 1, 5, NULL, 100),
	(610, 'Evan', 1, 8, NULL, 100),
	(609, 'Dylan', 1, 20, NULL, 100),
	(608, 'Michael', 1, 12, NULL, 100),
	(607, 'Laura', 1, 45, NULL, 112),
	(606, 'Yozo', 1, 11, NULL, 106),
	(605, 'Yusaku', 2, 11, NULL, 106),
	(604, 'Kayla', 1, 119, 'Yes', 108),
	(603, 'Matthias', 1, 119, 'Yes', 109),
	(602, 'Raja', 1, 119, 'Yes', 108),
	(601, 'Ye', 3, 146, 'Yes', 111),
	(600, 'Audrey', 1, 34, NULL, 100);

	SELECT * FROM Astronaut

CREATE TABLE Aircraft (
	Rocket_ID INT,
	Aircraft_Name NVARCHAR(50),
	Rocket_Model INT,
	Company_ID INT
	CONSTRAINT Prim_Aircra PRIMARY KEY (Rocket_ID),
	CONSTRAINT ForeigN_Airc FOREIGN KEY (Company_ID) 
	REFERENCES Company(Company_ID));

INSERT INTO Aircraft VALUES (200, 'Ares V', 5, 100),
	(201, 'Falcon Heavy', 3, 112),
	(202, 'Atlas Agena', 1, 106),
	(203, 'Falcon I', 1, 108),
	(204, 'Titan II', 2, 109),
	(205, 'Saturn I', 1, 111),
	(206, 'SS Loki', 2, 100);

-- 1- Add a constraint to a column in any of the tables. 
-- Foreign key constraints are added to table aircraft and astronaut.

-- 1.1- Test the constraint by inserting a new record that violates it
-- The value for company id is invalid given that there is no primary key for it in the parent table.

INSERT INTO Aircraft Values(207, 'New Space Rocket', 3, 300)

-- 2- Run at least three queries:

-- Query joins the three tables to display the austranauts that have been deployed on missions 
-- as well as their aircraft assigned.
SELECT a.Astronaut_Name 'Astronaut Name', a.Days_In_Space 'Days Deployed', ar.Aircraft_Name 'Aircraft Name',
ar.Rocket_Model Model, c.Company_Space_Agency Agency
FROM Astronaut a JOIN Company c on a.Company_ID = c.Company_ID 
JOIN Aircraft ar on c.Company_ID = ar.Company_ID

-- joins company and austronaut table to Count the number of austronauts associated with an agency that have more than one employee.
SELECT c.Company_Space_Agency, COUNT(a.Astronaut_Name) Employed
FROM Astronaut a JOIN Company c 
ON a.Company_ID = c.Company_ID
GROUP  BY c.Company_Space_Agency
HAVING  COUNT(a.Astronaut_Name) > 1

-- Retrieves the top 5 astronauts with the greatest number of days in space
SELECT TOP 5 Astronaut_Name, Days_In_Space
FROM Astronaut
ORDER BY Days_In_Space DESC

--3- Update a column based on a condition that needs to be met using the where clause

UPDATE Astronaut 
Set Still_In_Space = 'Unknown' WHERE Still_In_Space IS NULL;

--4 Retrieve data with a query directly into a variable. The variables must be initially declared. 
--the final query must return the minimum and maximum values through the variables previously declared. 

-- Counts the number of astronauts employed in the table per agency and stores the min and max numbers in the variables declared.

DECLARE @maxCount INT, @minCount INT
WITH CTE AS (
SELECT COUNT(a.Astronaut_Name) AS Amount
FROM Astronaut a JOIN Company c 
ON a.Company_ID = c.Company_ID
GROUP  BY c.Company_Space_Agency ) 

SELECT  @maxCount = MAX(Amount) , @minCount = MIN(Amount) 
FROM CTE 
SELECT @maxCount AS 'Most Austronauts Employed', @minCount AS 'Least Employed'

--5 You must create a procedure that returns full details of one of the tables of your choosing based on a given condition
--using the where clause
-- Store procedure stores astronaut time away in a variable and compares it in the query to ouput the number of days 
-- greater than what was sent to the variable.

DROP PROCEDURE dbo.AstronautInfo 

CREATE PROCEDURE dbo.AstronautInfo 
	 @timeAway INT
	AS
	SELECT Astronaut_ID, Astronaut_Name, Days_In_Space
	FROM Astronaut
	WHERE @timeAway <= Days_In_Space

	EXEC dbo.AstronautInfo 100;
	
SELECT * FROM Company
SELECT * FROM Astronaut
SELECT * FROM Aircraft