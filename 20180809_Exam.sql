--=============================
-- Create Database With Properties
--=============================

USE master
CREATE DATABASE Exam_20180809

ALTER DATABASE Exam_20180809
MODIFY FILE(NAME='Exam_20180809', SIZE=10MB, MAXSIZE=100MB,FILEGROWTH=1024KB)

ALTER DATABASE Exam_20180809
MODIFY FILE(NAME='Exam_20180809_log', SIZE=9MB, MAXSIZE=100MB,FILEGROWTH=5%)

GO

--=============================
-- Create Table
--=============================

USE Exam_20180809
CREATE TABLE Course
(
	CourseID int primary key identity,
	CourseName varchar(30)
)

GO

USE Exam_20180809
CREATE TABLE Student
(
	StudentID int identity,
	StudentName varchar(20),
	CellPhoneNo varchar(20),
	DOB datetime,
	CourseID int foreign key references Course(CourseID)
)

GO

--=============================
-- Create Clustered and Non Clustered Index
--=============================

CREATE CLUSTERED INDEX StudentCluster ON Student(StudentID)
GO

CREATE NONCLUSTERED INDEX StudNameCluster ON Student(StudentName)
GO

--=============================
-- View DB and Table Structure
--=============================

EXEC sp_helpdb Exam_20180809

EXEC sp_help Student



--=============================
-- INSERT, UPDATE, DELETE AND SELECT Quries
--=============================

INSERT INTO Course VALUES('Bangla'),
						('English'),
						('Math'),
						('Economics'),
						('Accounting')

GO


INSERT INTO Student VALUES('AZIM', '5456456454', '08-02-2018', 11),
							('RASHED', '56456464', '06-01-2016', 15),
							('KAIUM', '78896465456', '08-02-2010', 14),
							('NASIR', '01315454', '05-06-2016', 12)

GO

-- SELECT							
SELECT * FROM Course

SELECT * FROM Student 
WHERE StudentID=2
ORDER BY StudentName
GO

-- UPDATE	
UPDATE Student 
SET StudentName = 'Mahmud'
WHERE StudentID = 1

-- DELETE
DELETE Student WHERE StudentID=4



--=============================
-- DROP, TRUNCATE AND DROP
--=============================
TRUNCATE TABLE Student
GO

DELETE Course
GO

DROP TABLE Student
GO

