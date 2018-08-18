
--===================================
--        Create Database
--===================================

USE master
CREATE DATABASE BloodBankManagement
ON PRIMARY
(Name=N'BloodBankManagement_Data', Filename=N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\BloodBankManagement_Data.mdf', Size=10MB, MaxSize=unlimited, FileGrowth=1024KB)
LOG ON
(Name=N'BloodBankManagement_Log', Filename=N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\BloodBankManagement_Log.ldf', Size=3MB, MaxSize=10MB, FileGrowth=10%)
GO


--===================================
--        Alter Database
--===================================

--USE master
--Drop Database BloodBankManagement
--GO

USE master
CREATE DATABASE BloodBankManagement
GO

ALTER DATABASE BloodBankManagement
MODIFY FILE(Name=N'BloodBankManagement', Size=10MB, MaxSize=unlimited, FileGrowth=1024KB)
GO

ALTER Database BloodBankManagement
MODIFY FILE(Name=N'BloodBankManagement_log', Size=9MB, MaxSize=100MB, FileGrowth=10%)
GO

--===================================
--        Drop Database
--===================================

--USE master
--DROP DATABASE BloodBankManagement
--GO
-----------------------

EXEC sp_helpdb BloodBankManagement
GO

--===================================
--        Create Table
--===================================

USE BloodBankManagement
CREATE TABLE BloodManager
(
BldMngrID int primary key identity
)
GO
--------------

USE BloodBankManagement
CREATE TABLE District
(
DistID int primary key identity,
DistName varchar(25)
)
GO
--------------

USE BloodBankManagement
CREATE TABLE Registration
(
RegID int primary key identity,
FirstName varchar(20) not null,
MiddleName varchar(20) null,
LastName varchar(20) not null,
Age int null,
Sex nvarchar(10),
ContactNumber varchar(15),
Date DateTime,
DistID int Foreign key References District(DistID)
)
GO
----------------------

USE BloodBankManagement
CREATE TABLE DiseaseRecognization
(
DisRecogID int primary key identity,
DisRecogName varchar(30),
DiseaseStatus varchar(30),
ScreeningTests varchar(50),
BeforeTransfusion varchar(50),
AfterTransfusion varchar(50)
)
GO
--------------

USE BloodBankManagement
CREATE TABLE BloodGroup
(
GrpID int primary key identity,
GrpName varchar(10)
)
GO
----------------------

USE BloodBankManagement
CREATE TABLE BloodSample
(
BldSampID int primary key identity,
GrpID int foreign key references BloodGroup(GrpID),
StateOfBldGrp varchar(40),
DisRecogID int foreign key references DiseaseRecognization(DisRecogID)
)
GO
----------------------

USE BloodBankManagement
CREATE TABLE Donor
(
DnrID int primary key identity,
RegID int foreign key references Registration(RegID),
BldSampID int foreign key references BloodSample(BldSampID),
GivnBloodQtyInLiter Decimal(5,2),
BldMngrID int foreign key references BloodManager(BldMngrID)
)
Go
------------------------

USE BloodBankManagement
CREATE TABLE Recipient
(
RecipID int primary key identity,
RegID int foreign key references Registration(RegID),
BldSampID int foreign key references BloodSample(BldSampID),
RecvdBloodQtyInLiter decimal(5,2),
BldMngrID int foreign key references BloodManager(BldMngrID)
)
GO
----------------------------

USE BloodBankManagement
CREATE TABLE Hospital
(
HospitalID int primary key identity,
HospitalName varchar(30),
NeededQtyOfBldInLtr decimal(5,2),
NeededBldGrp varchar(15),
DistID int Foreign key References District(DistID),
BldMngrID int foreign key references BloodManager(BldMngrID)
)
GO
--------------------------

USE BloodBankManagement
CREATE TABLE BloodBalanceInfo
(
BBInfoID int identity,
RecipID int foreign key references Recipient(RecipID),
HospitalID int foreign key references Hospital(HospitalID),
TotalRecivdBld decimal(5,2),
TotalGivnBld decimal(5,2),
TotalAvailableBld AS TotalRecivdBld-TotalGivnBld
)
GO
-----------------


EXEC sp_help District


--===================================
--        Alter Table
--===================================

USE BloodBankManagement
ALTER TABLE BloodManager
ADD
BldMngrFstName varchar(30),
BldMngrLstName varchar(30)
GO
---------------


--===================================
--        Create Indexes
--===================================

USE BloodBankManagement
CREATE CLUSTERED INDEX MyClustered ON BloodBalanceInfo(BBInfoID)
Go
---------

Use BloodBankManagement
CREATE NONCLUSTERED INDEX MyNonClustered ON BloodBalanceInfo(HospitalID)
GO


--===================================
--        Insert Table Values
--===================================

INSERT INTO BloodManager VALUES('Mehedi','Hasan')
INSERT INTO BloodManager VALUES('Abdus','Salam')
INSERT INTO BloodManager VALUES('Mamun','Bhuiyan')
INSERT INTO BloodManager VALUES('Naznin','Akter')
GO

SELECT * FROM BloodManager
GO

INSERT INTO BloodManager VALUES('Monju','Alam'),
								('Jamal','Chy'),
								('Nasir','Ahmed'),
								('Md.','Azim')
GO
----------------------

USE BloodBankManagement
INSERT INTO District VALUES('Chattogram'),
							('Mymensingh'),
							('Dhaka'),
							('Noakhali'),
							('Netrokona')
GO

SELECT * FROM District


USE BloodBankManagement
INSERT INTO Registration VALUES('Md.','Abdul','Kaium',25,'Male','+8801854759685','08-08-2018',4),
								('Md.','','Hossain',26,'Male','545454444','08-08-2018',3)
GO

-----------------------
INSERT INTO BloodManager VALUES ('MD','Asif'),('MD','Atik'),('MD','Saif'),('RA','Ayush'),('SA','Sayid')
GO


INSERT INTO District VALUES ('Dhaka'),('Chittagong'),('Noakhali'),('B.Baria'),('Mymensingh')
GO

INSERT INTO Registration VALUES ('MD', 'Abu', 'Sayid',35,'Male','01825252526',08/02/2016,4),
								('Mrs','Niha','Islam',25,'Female','01636252528',12/02/2016,5),
								('Sayid','Al','Naser',26,'Male','01525252536',08/11/2017,3),
								('Miss','Lima','Khan',23,'Female','01827636326',05/12/2017,1),
								('MD','Roni','Sarker',28,'Male','01725252526',03/10/2017,2)
GO

INSERT INTO DiseaseRecognization VALUES 
    ('Dr Abdullah','Ok for transfusion','ABO grouping','Hypersensitivity reaction','Febrile reaction'),
    ('Dr Abdullah','Not ok for transfusion','Rh Typing','CCF','Alergic reaction'),
    ('Dr Sufi','Ok for transfusion','HBs Ag','Hypertension','Hemolytic reaction'),
    ('Dr Sufi','Not ok for transfusion','Antibodies to HIV','Polycythaemia','Air Embolism'),
    ('Dr Sufi','Ok for transfusion','CytomegaloVirus','Embolism','Bacteremia')
GO

INSERT INTO BloodGroup VALUES ('A+'), ('A-'), ('B+'), ('B-'), ('AB+'), ('AB-'), ('O+'), ('O-')
GO

INSERT INTO BloodSample VALUES (2,'Available',2),
					(4,'Available',1),
					(3,'Available',3),
					(8,'Available',1),
					(7,'Not Available',2),
					(1,'Not Available',4),
					(5,'Not Available',5),
					(6,'Not Available',2)
GO

INSERT INTO Donor VALUES (5,2,2,5),
				(6,2,2.5,3),
				(2,5,1.5,2),
				(4,5,3,1),
				(3,4,1,3)
GO


INSERT INTO Recipient VALUES (2,2.50,3,5),
					(6,3.00,2,2),
					(5,1.00,1,2),
					(4,2.00,5,1),
					(7,2.50,4,5)
GO


INSERT INTO Hospital VALUES ('BIRDM', 8.50, 'A+, B+, AB+', 3, 1),
					('MMS',10.25,'O+, B+, A+', 4, 5),
					('DMC',16.50,'AB+, B+, AB-', 4, 3),
					('CMC',22.75,'A+, B+, O+, A-', 1, 2),
					('CSCR',12.10,'O+, B+, O-', 1, 4)
Go

INSERT INTO BloodBalanceInfo VALUES (2,4,5,5),
						(3,3,12,2),
						(5,1,7,7),
						(4,5,5,13),
						(1,2,10,5)
go

-----

--=========================================
-- Delete Table Data by Truncate & Delete
--=========================================

--TRUNCATE table Registration
--GO

--DELETE Registration
--GO


--===================================
--        Queries
--===================================
-- Select Data
SELECT BldMngrID, BldMngrFstName
FROM BloodManager
GO

SELECT BldMngrID, BldMngrFstName
FROM BloodManager
WHERE BldMngrID >= 2
GO

SELECT BldMngrID, BldMngrFstName
FROM BloodManager
WHERE BldMngrID >= 2
ORDER BY BldMngrFstName
GO

SELECT BldMngrID, BldMngrFstName
FROM BloodManager
WHERE BldMngrID >= 2
ORDER BY BldMngrFstName DESC
GO

SELECT * FROM District

SELECT * FROM Registration


-- Delete Data

DELETE District
WHERE DistID = 4

DELETE Registration
WHERE RegID = 1


-- Update Data

UPDATE Registration
SET FirstName = 'Nasir', MiddleName='Hossain', LastName='Molla'
WHERE RegID=2







------ TEST SCRIPT

CREATE TABLE Student
(
	StudID int primary key identity,
	Name varchar(20),
	CellPhone varchar(30) 
)


INSERT INTO Student VALUES('AZIM', '58967757'),
							('ASIF', '3366363'),
							('KALAM', '1555655'),
							('MAMUN', '93544'),
							('RAJU', '877887')


GO

SELECT * FROM Student
GO

SELECT  District.DistName, Registration.FirstName, Registration.LastName, Registration.Age, District.DistID, Registration.ContactNumber
FROM    District INNER JOIN
        Registration ON District.DistID = Registration.DistID


--TRUNCATE TABLE BloodManager
--GO

--TRUNCATE TABLE BloodGroup
--GO

--TRUNCATE TABLE BloodSample
--GO

--TRUNCATE TABLE DiseaseRecognization
--GO

--TRUNCATE TABLE District
--GO

--TRUNCATE TABLE Hospital
--GO

--TRUNCATE TABLE Recipient
--GO

--TRUNCATE TABLE Registration
--GO

--TRUNCATE TABLE BloodBalanceInfo
--GO

--TRUNCATE TABLE Donor
--GO

--TRUNCATE TABLE Student
--GO

--DELETE Student
--GO


--=============================
--Join 
--=============================

-- Inner Join
SELECT * 
	FROM Registration
	JOIN Donor
	ON Registration.RegID=Donor.RegID
GO 

----

SELECT Registration.RegID, Registration.FirstName, Registration.LastName, Registration.ContactNumber, Donor.GivnBloodQtyInLiter
	FROM Registration
	JOIN Donor
	ON Registration.RegID=Donor.RegID
GO 

----
-- Use Alias Name

SELECT Reg.RegID, Reg.FirstName, Reg.LastName, Reg.ContactNumber, Dnr.GivnBloodQtyInLiter
	FROM Registration Reg -- (Reg) - Alias Name
	JOIN Donor Dnr -- (Dnr) - Alias Name
	ON Reg.RegID=Dnr.RegID
GO 

----

SELECT *
	FROM Registration Reg --(Reg) - Alias Name
	JOIN Donor Dnr --(Dnr) - Alias Name
	ON Reg.RegID=Dnr.RegID
	JOIN Recipient Recp --(Recp) - Alias Name
	ON Reg.RegID=Recp.RegID
	JOIN District Dist --(Dist) - Alias Name
	ON Reg.DistID=Dist.DistID
	JOIN Hospital Hosp --(Hosp) - Alias Name
	ON Dist.DistID=Hosp.DistID
	JOIN BloodManager BldMan --(BldMan) - Alias Name
	ON Hosp.BldMngrID=BldMan.BldMngrID
GO 


--------------
-- Left Join
SELECT *
	FROM Donor Dnr
	LEFT JOIN Recipient Recp
	ON Dnr.RegID=Recp.RegID
GO


--------------
-- Right Join
SELECT *
	FROM Donor Dnr
	RIGHT JOIN Recipient Recp
	ON Dnr.RegID=Recp.RegID
GO

--------------
-- Cross Join

SELECT * 
	FROM DiseaseRecognization DisRecog
	CROSS JOIN BloodSample
GO


SELECT * FROM DiseaseRecognization
SELECT * FROM BloodSample


--================================
--			VIEW
--================================
SELECT * FROM BloodManager
SELECT * FROM Hospital
GO


CREATE VIEW vw_BloodManager
AS 
SELECT bm.BldMngrID, bm.BldMngrFstName,bm.BldMngrLstName,h.HospitalName,h.DistID 
FROM BloodManager bm
JOIN Hospital h
ON bm.BldMngrID=h.BldMngrID
GO


SELECT * FROM vw_BloodManager
GO


CREATE VIEW vw_Bld
AS
SELECT bm.BldMngrID, bm.BldMngrFstName
FROM BloodManager bm
GO

SELECT * FROM vw_Bld
GO


--=============================
--		Store Proceddure
--=============================
SELECT * FROM Registration
GO


CREATE PROCEDURE sp_SearchByName
@name varchar(20)
AS
SELECT FirstName, MiddleName, LastName, Age
FROM Registration
WHERE FirstName LIKE @name+'%' OR MiddleName LIKE @name+'%' OR LastName LIKE @name+'%'
GO

EXEC sp_SearchByName 'Nasir'
GO




