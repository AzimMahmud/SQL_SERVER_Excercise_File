Use master
Create database Exam_20180805
Go

Create table Employee
(
EmployeeID Int Primary key identity(1,1),
EmployeeName varchar(30),
JoiningDate varchar(15),
BOD varchar(15)
)
Go

Create table Trainee
(
TraineeID Int Primary key identity(1,2),
TraineeName varchar(30),
DOB varchar(15),
CellPhoneNo varchar(11)
)
Go


insert into Eployee(Employee ID, Employee Name,Joining
