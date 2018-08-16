--==============================
--		
--==============================
USE master
CREATE DATABASE MyTestDB

USE MyTestDB
CREATE TABLE Student
(
	StudentID int primary key identity,
	FisrtName varchar(20),
	MiddleName varchar(20),
	LastName varchar(20),
	DateOfBirth date,
	MarksInBangla1st decimal,
	MarksInBangla2nd decimal,
	MarksInEnglish1st decimal,
	MarksInEnglish2nd decimal,
	TotalMarks AS (MarksInBangla1st+MarksInBangla2nd+MarksInEnglish1st+MarksInEnglish2nd)
)


SELECT FisrtName, MiddleName, LastName, DateOfBirth, MarksInBangla1st, MarksInBangla2nd, MarksInEnglish1st, MarksInEnglish2nd, TotalMarks 
FROM Student

SELECT FisrtName + ' ' + MiddleName + ' '+ LastName AS [Full Name], DateOfBirth, MarksInBangla1st, MarksInBangla2nd, MarksInEnglish1st, MarksInEnglish2nd, TotalMarks 
FROM Student

SELECT (FisrtName + ' ' + MiddleName + ' '+ LastName) AS [Full Name], DateOfBirth, (MarksInBangla1st + MarksInBangla2nd) / 2 AS [Marks In Bangla], (MarksInEnglish1st + MarksInEnglish2nd) /2  AS [Marks In English], TotalMarks 
FROM Student

SELECT (FisrtName + ' ' + MiddleName + ' '+ LastName) AS [Full Name], DateOfBirth, (MarksInBangla1st + MarksInBangla2nd) / 2 AS [Marks In Bangla], (MarksInEnglish1st + MarksInEnglish2nd) /2  AS [Marks In English], TotalMarks 
FROM Student

-------------------------
-- BETWEEN ... AND ...
-------------------------
SELECT (FisrtName + ' ' + MiddleName + ' '+ LastName) AS [Full Name], DateOfBirth, (MarksInBangla1st + MarksInBangla2nd) / 2 AS [Marks In Bangla], (MarksInEnglish1st + MarksInEnglish2nd) /2  AS [Marks In English], TotalMarks 
FROM Student
WHERE DateOfBirth BETWEEN '01-01-2000' AND '01-01-2010' 
