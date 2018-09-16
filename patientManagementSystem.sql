--========================================
--		CREATE DATABASE
--========================================
USE master
CREATE DATABASE PatientManagementSys
GO

ALTER DATABASE PatientManagementSys
MODIFY FILE(NAME='PatientManagementSys', SIZE=25MB, MAXSIZE=100MB, FILEGROWTH=5%)
GO

ALTER DATABASE PatientManagementSys
MODIFY FILE(NAME='PatientManagementSys_log', SIZE=10MB, MAXSIZE=75MB, FILEGROWTH=1MB)
GO

--========================================
--		CREATE TABLES
--========================================
USE PatientManagementSys
CREATE TABLE Employees
(
	empID int primary key identity(101,1),
	empName varchar(30) NOT NULL,
	empAddress varchar(150) NOT NULL,
	empEmail varchar(50),
	joinDate AS GETDATE(),
	cellNo varchar(18) NOT NULL CHECK (cellNo like '[(][+][8][8][)][ ][0][1][5-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]'),
	empRole varchar(50) NOT NULL
)
GO

USE PatientManagementSys
CREATE TABLE Patients
(
	patID int primary key identity(201,1),
	patName varchar(30) NOT NULL,
	patAddress varchar(150),
	dateOfBirth date NOT NULL,
	age AS DATEDIFF(YEAR, dateOfBirth, GETDATE()),
	bloodGroup varchar(20) NOT NULL,
	patCellNo varchar(18) NOT NULL CHECK (patCellNo like '[(][+][8][8][)][ ][0][1][5-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]'),
	empID int foreign key references Employee(empID)
)
GO

USE PatientManagementSys
CREATE TABLE Doctors
(
	docID int primary key identity(301,1),
	empID int foreign key references Employee(empID) ON DELETE CASCADE,
	bmdcNo varchar(20),
	docDesignation varchar(50) NOT NULL,
	workingField varchar(50) NOT NULL DEFAULT('Medicine'),
	maxPatientLimit int,
)
GO

USE PatientManagementSys
CREATE TABLE Appointments
(
	appointID int primary key identity,
	appointDate date NOT NULL,
	appointTime time NOT NULL,
	notesForDoctor varchar(150),
	empID int foreign key references Employee(empID),
	docID int foreign key references Doctor(docID),
	patID int foreign key references Patient(patID)
)
GO

USE PatientManagementSys
CREATE TABLE Prescriptions
(
	prescripId int identity(501,1),
	prescripDate AS GETDATE(),
	dieasesHistory varchar(max) NOT NULL,
	medication varchar(max),
	docID int foreign key references Doctor(docID),
	patID int foreign key references Patient(patID)
)
GO


--========================================
--		REGISTER EMPLOYEE
--========================================

--------------------------------
-- Create function for cell no
--------------------------------
CREATE FUNCTION fn_cellNo
(
	@cellNo varchar(17)
)
RETURNS varchar(18)
AS
BEGIN

	IF (LEN(@cellNo) = 11 )
		begin
			DECLARE @phoneNo varchar(17)
			SET @phoneNo = '(+88)'+ ' ' +substring(@cellNo, 1,5) + '-' + substring(@cellNo, 6,6);
		end
	ELSE 
		BEGIN 
			SET @phoneNo = 'Invalid Number';
		END
	RETURN @phoneNo;
END
GO
--------------------------------

CREATE PROC RegEmpDocPat
(
	@empid int,
	@empName varchar(30),
	@empAddress varchar(150),
	@empEmail varchar(50),
	@cellNo varchar(18),
	@empRole varchar(50),
	@docid int,
	@bmdcno varchar(20),
	@docdesignation varchar(50),
	@workingfield varchar(50),
	@maxpatlimit int,
	@patid int,
	@patname varchar(30),
	@pataddress varchar(150),
	@dateofbirth date,
	@bloodgroup varchar(20),
	@patcellno varchar(18),
	@tablename varchar(20),
	@operation varchar(20)
)
AS
BEGIN
	-- FOR EMPLOYEE TABLE 
	IF (@tablename = 'Employees')
		BEGIN
			IF (@operation = 'INSERT')
				BEGIN
					INSERT INTO Employee(empName,empAddress,empEmail,cellNo,empRole)
								VALUES(@empName,@empAddress,@empEmail,dbo.fn_cellNo(@cellNo),@empRole);
					PRINT 'A New Employee is Registered!!!';
				END
			IF (@operation = 'UPDATE')
				BEGIN
					UPDATE Employee
					SET empName = @empName, empAddress = @empAddress, empEmail = @empEmail, cellNo = dbo.fn_cellNo(@cellNo), empRole = @empRole WHERE empID=@empid;
					PRINT @empName + ' info is updated!!!';
				END
			IF (@operation = 'DELETE' AND @empRole = 'Manager')
				BEGIN
					DELETE FROM Employee WHERE empID=@empid;
					PRINT 'Employee is deleted successfully!!';
				END
		END
		-- FOR DOCTOR TABLE 
	IF (@tablename = 'Doctors')
		BEGIN
			IF (@operation = 'INSERT' AND @empRole = 'Manager')
				BEGIN
					INSERT INTO Doctors(bmdcNo,docDesignation,workingField,maxPatientLimit)
								VALUES(@bmdcno,@docdesignation,@workingfield,@maxpatlimit);
					PRINT 'A New Doctor is Registered!!!';
				END
			IF (@operation = 'UPDATE' AND @empRole = 'Manager')
				BEGIN
					UPDATE Doctors
					SET bmdcNo = @bmdcno, docDesignation = @docdesignation, workingField = @workingfield, maxPatientLimit = @maxpatlimit WHERE docID=@docid;

					SET @empName = (SELECT empName FROM Employees WHERE empID=@empid);
				PRINT @empName + ' info is updated!!';
				END
		END
		-- FOR EMPLOYEE TABLE 
	IF (@tablename = 'Patients' AND @empRole = 'Reciptionist')
		BEGIN
			IF (@operation = 'INSERT')
				BEGIN
					INSERT INTO Patients(patName,patAddress,dateOfBirth,bloodGroup,patCellNo)
								VALUES(@patname,@pataddress,@dateofbirth,@bloodgroup,dbo.fn_cellNo(@patcellno));
					PRINT 'A New Patient is Registered!!!';
				END
			IF (@operation = 'UPDATE')
				BEGIN
					UPDATE Patients
					SET patName = @patname, patAddress = @pataddress, dateOfBirth = @dateofbirth, patCellNo = dbo.fn_cellNo(@patcellno), bloodGroup = @bloodgroup WHERE patID=@patid;
					PRINT @patname + ' info is Updated!!!';
				END
			IF (@operation = 'DELETE')
				BEGIN
					DELETE FROM Patients WHERE patID=@patid;

					SET @patname = (SELECT patName FROM Patients WHERE patID=@patid);
				PRINT @patname + ' is Deleted!!';
				END
		END
	ELSE 
		PRINT 'Sorry You are not authorized Person !!!'
END
GO




































