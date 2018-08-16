USE master
CREATE DATABASE Practice_20180812
GO

ALTER DATABASE Practice_20180812
MODIFY FILE(NAME='Practice_20180812',SIZE=10MB, MAXSIZE=100MB, FILEGROWTH=5%)
GO

ALTER DATABASE Practice_20180812
MODIFY FILE(NAME='Practice_20180812_log',SIZE=9MB, MAXSIZE=100MB, FILEGROWTH=1024KB)
GO


USE Practice_20180812
CREATE TABLE Student
(
	StudentID int primary key identity,
	Name varchar(20),
	DOB date,
	MInBangla decimal,
	MInEnglish decimal,
	TotalMarks AS (MInBangla + MInEnglish)
)
GO

USE Practice_20180812
ALTER TABLE Student
ADD
	Sex varchar(10)
GO	

USE Practice_20180812
INSERT INTO Student VALUES('Azim Mahmud', '08/02/1994', 45, 55,'Male'),
							('Nasir Uddin', '08/02/2000', 75, 55, 'Male'),
							('Ridwan Islam', '08/08/2007', 35, 65, 'Female'),
							('Kazi Nurul Islam', '08/05/2011', 95, 85, 'Male')
GO

USE Practice_20180812
SELECT (Name + ', ' + Sex) AS [Student], DOB,(MInBangla + MInEnglish)/2  AS TotalAvg , TotalMarks
FROM Student
WHERE DOB BETWEEN '01/01/2000' AND '01/01/2010'
ORDER BY Name DESC



