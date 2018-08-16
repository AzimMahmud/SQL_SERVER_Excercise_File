use master
CREATE DATABASE NvitDB
Go

CREATE TABLE Student
(
ID int primary key identity(15,2),
"First Name" varchar(20) not null,
"Last Name" varchar(20) not null,
[Address] nvarchar(50) null,
Cell_Phone varchar(15) null
)

Go

INSERT INTO Student ("First Name","Last Name",[Address],Cell_Phone)
VALUES('Asif','Ahmed','Dhaka','+8801122155')

Go

SELECT * FROM Student

Go

DROP TABLE Student

Go

DROP DATABASE NvitDB