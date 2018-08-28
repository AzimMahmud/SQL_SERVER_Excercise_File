--=============================
--		CREATE DATABASE
--=============================
USE master
CREATE DATABASE PatientManagementSystem
GO

ALTER DATABASE PatientManagementSystem
MODIFY FILE (Name='PatientManagementSystem', SIZE=10MB, MAXSIZE=100MB, FILEGROWTH=5%)
GO

ALTER DATABASE PatientManagementSystem
MODIFY FILE (Name='PatientManagementSystem_log', SIZE=9MB, MAXSIZE=100MB, FILEGROWTH=5%)
GO


--=============================
--	Create on Custom Location
--=============================
--USE master
--CREATE DATABASE PatientManagementSystem2
--ON PRIMARY (Name='PatientManagementSystem_Data', FILENAME='D:\IDB_C#38\Project Script\PatientManagementSystem_Data.mdf', SIZE=10MB, MAXSIZE=100MB, FILEGROWTH=5%) 
--LOG ON (Name='PatientManagementSystem_Log', FILENAME='D:\IDB_C#38\Project Script\PatientManagementSystem_Log.ldf', SIZE=10MB, MAXSIZE=100MB, FILEGROWTH=5%) 




--=============================
--		CREATE TABLES
--=============================
USE PatientManagementSystem
CREATE TABLE registration
(
	regID int primary key identity,
	fullName varchar(20),
	email nvarchar(30) UNIQUE,
	password nvarchar(10)
)
GO

USE PatientManagementSystem
CREATE TABLE patient
(
	patientID int primary key identity(101, 1),
	address varchar(50),
	cellNo nvarchar(15),
	patientAge int,
	patientWeight varchar(10),
	patientHeight varchar(10),
	patientBldGroup varchar(3),
	regID int UNIQUE FOREIGN KEY REFERENCES registration(regID) ON DELETE CASCADE
)
GO

USE PatientManagementSystem
CREATE TABLE appointment
(
	appointID int primary key identity(201,1),
	appointDate date,
	appointTime time,
	noteForDoctor varchar(50),
	patientID int FOREIGN KEY REFERENCES patient(patientID)
)
GO

USE PatientManagementSystem
CREATE TABLE prescription
(
	prescriptionID int primary key identity(301, 1),
	prescriptionDate datetime,
	dieasesHistory text,
	medication text,
	appointID int FOREIGN KEY REFERENCES appointment(appointID)
)
GO

USE PatientManagementSystem
CREATE TABLE medicalTest
(
	mediTestID int primary key identity,
	testName varchar(50),
	cost int,
	discount int,
	totalCost int,
	prescriptionID int FOREIGN KEY REFERENCES prescription(prescriptionID)
)
GO

USE PatientManagementSystem
CREATE TABLE billing
(
	billingID int identity,
	consultantFee int,
	medicalTestCost int,
	paymentMode varchar(10),
	paymentStatus varchar(10),
	paymentDate date,
	totalCost int,
	mediTestID int FOREIGN KEY REFERENCES medicalTest(mediTestID),
	prescriptionID int FOREIGN KEY REFERENCES prescription(prescriptionID)
)
GO


--=================================
--			ALTER TABLE
--=================================
USE PatientManagementSystem
ALTER TABLE prescription
ADD
	notes varchar(50)
GO


--=================================================
--		CREATE CLUSTERED AND NON CLUSTERED INDEX
--=================================================
CREATE CLUSTERED INDEX BillingInfo ON billing(billingID)
GO

CREATE NONCLUSTERED INDEX PrescriptionDate ON prescription(prescriptionDate)
GO


--=================================================
--		VIEW THE DATABASE & TABLE STRUCTURE 
--=================================================
USE master
EXEC sp_helpdb PatientManagementSystem
GO

USE PatientManagementSystem
EXEC sp_help registration
EXEC sp_help patient
EXEC sp_help appointment
EXEC sp_help prescription
EXEC sp_help medicalTest
EXEC sp_help billing
GO

USE PatientManagementSystem
DELETE registration
DELETE patient
DELETE appointment
DELETE prescription
DELETE billing
GO

USE PatientManagementSystem
DROP TABLE registration 
GO
DROP TABLE  patient 
GO
DROP TABLE  appointment 
GO
DROP TABLE  prescription 
GO
DROP TABLE medicalTest 
GO
DROP TABLE  billing
GO
--=====================================
--	INSERT VALUE WITH STORE PROCEDURE
--=====================================

------------------------
--	 FOR Patient TABLE
------------------------
CREATE PROCEDURE sp_patient
(
	@patiendid int,
	@regid int,
	@fullname varchar(20),
	@email nvarchar(30),
	@password nvarchar(10),
	@address varchar(50),
	@cellno nvarchar(15),
	@patientage int,
	@patientweitht varchar(10),
	@patientheitht varchar(10),
	@patientbldgroup varchar(3),
	@tablename varchar(20),
	@operation nvarchar(20)
)
AS
BEGIN
	IF(@tablename = 'registration' AND @operation = 'INSERT')
		INSERT INTO registration VALUES(@fullname,@email,@password)

	ELSE IF (@tablename = 'registration' AND @operation = 'UPDATE')
		UPDATE registration SET fullName = @fullname, email = @email, password = @password WHERE regID = @regid
	
	ELSE IF(@tablename = 'registration' AND @operation = 'delete')
		delete FROM registration WHERE regID = @regid
	---------
	ELSE IF(@tablename = 'patient' AND @operation = 'INSERT')
		INSERT INTO patient VALUES(@address, @cellno,@patientage,@patientweitht,@patientheitht,@patientbldgroup,@regid)
		
	ELSE IF(@tablename = 'patient' AND @operation = 'UPDATE')
		UPDATE patient SET address = @address, cellNo = @cellno, patientAge = @patientage, patientWeight = @patientweitht, patientHeight = @patientheitht, patientBldGroup = @patientbldgroup WHERE patientID = @patiendid

END
GO

---- Start Execute sp_patient
EXEC sp_patient 1, 1, 'Abul Kalam','abulkalam@gmail.com','123456','99/58 Hill view, 2 No Gate, Pachlish, Ctg','018688899', 18, '55', '5.2', 'A-', 'registration','INSERT'
GO

EXEC sp_patient 1, 1, 'Abul Kalam','abulkalam@gmail.com','123456','99/58 Hill view, 2 No Gate, Pachlish, Ctg','018688899', 18, '55', '5.2', 'A-', 'patient','INSERT'
GO
---- End 

------------------------------
--	 FOR Appointment TABLE
------------------------------
USE PatientManagementSystem
GO
CREATE PROC sp_appointment
(
	@appointid int,
	@appointdate date,
	@appointtime time,
	@notefordoctor varchar(50),
	@patientid int,
	@tablename varchar(20),
	@operation varchar(20)
)
AS
BEGIN
	IF(@tablename = 'appointment' AND @operation = 'INSERT')
		INSERT INTO appointment VALUES(@appointdate,@appointtime,@notefordoctor,@patientid)
	ELSE IF(@tablename = 'appointment' AND @operation = 'UPDATE')
		UPDATE appointment 
		SET appointDate = @appointdate, appointTime = @appointtime, noteForDoctor = @notefordoctor, patientID = @patientid
	ELSE IF(@tablename = 'appointment' AND @operation = 'DELETE')
		DELETE appointment WHERE appointID = @appointid
END
GO

---- Start Execute sp_appointment
EXEC sp_appointment 1, '08-15-2018', '09:00' , '', 101, 'appointment','INSERT'
GO
---- End 

-------------------------------
--	 FOR Prescription TABLE
-------------------------------

CREATE PROC sp_prescription
(
	@prescriptionid int,
	@prescriptiondate date,
	@dieaseshistory varchar(254),
	@medication varchar(254),
	@appointid int,
	@notes varchar(50),
	@tablename varchar(20),
	@operation varchar(20)
)
AS
BEGIN
	IF(@tablename = 'prescription' AND @operation = 'INSERT')
		INSERT INTO prescription VALUES(@prescriptiondate,@dieaseshistory,@medication,@appointid,@notes)
	ELSE IF(@tablename = 'prescription' AND @operation = 'UPDATE')
		UPDATE prescription 
		SET prescriptionDate = @prescriptiondate, dieasesHistory = @dieaseshistory, medication = @medication, appointID = @appointid, notes = @notes
	ELSE IF(@tablename = 'prescription' AND @operation = 'DELETE')
		DELETE prescription WHERE prescriptionID = @prescriptionid
END
GO

---- Start Execute sp_prescription
EXEC sp_prescription 1, '08-07-2018', 'He has a major head problem' , 'Tab: Seclo 20 mg 1-0-1 perday', 201, 'Need operation', 'prescription','INSERT'
GO
---- End

------------------------------
--	 FOR MedicalTest TABLE
------------------------------

--------------------------------------
-- function for calculating total cost
--------------------------------------
create function fn_totalcost
(
@cost int,
@discount decimal
)
Returns decimal
AS
Begin
	declare @totalcost int
	set @totalcost= @cost - (@cost*(@discount/100))
	return @totalcost
End
GO

CREATE PROCEDURE sp_medicaltest
(
	@meditestid int,
	@testname varchar(50),
	@cost int,
	@discount int,
	@prescriptionid int,
	@tablename varchar(20),
	@operation varchar(20)
)
AS
BEGIN
	declare @totalcost int
	set @totalcost=dbo.fn_totalcost(@cost,@discount)

	IF(@tablename = 'medicalTest' AND @operation = 'INSERT')
		INSERT INTO medicalTest VALUES(@testname, @cost , @discount,@totalcost, @prescriptionid)
	ELSE IF(@tablename = 'billing' AND @operation = 'UPDATE')
		UPDATE medicalTest 
		SET testName = @testname, cost = @cost, discount = @discount, totalCost = @totalcost, prescriptionID = @prescriptionid
	ELSE IF(@tablename = 'billing' AND @operation = 'DELETE')
		DELETE medicalTest WHERE mediTestID = @meditestid
END
GO

---- Start Execute sp_medicaltest
EXEC sp_medicaltest 1, 'ECG', 120, 15, 301, 'medicalTest','INSERT'
GO
---- End

---------------------------
--	FOR BILLING TABLE
---------------------------
CREATE PROC sp_billing
(
	@billingid int,
	@consultantfee int,
	@paymentmode varchar(10),
	@paymentstatus varchar(10),
	@paymentdate date,
	@meditestid int,
	@prescriptionid int,
	@tablename varchar(20),
	@operation varchar(20)
)
AS
BEGIN
	declare @medicalcost int
	set @medicalcost = (SELECT totalCost FROM medicalTest  Where mediTestID = @meditestid)

	declare @totalcost int
	set @totalcost = @consultantfee + @medicalcost

	IF(@tablename = 'billing' AND @operation = 'INSERT')
		INSERT INTO billing VALUES(@consultantfee, @medicalcost, @paymentmode, @paymentstatus, @paymentdate, @totalcost, @meditestid,@prescriptionid)
	ELSE IF(@tablename = 'billing' AND @operation = 'UPDATE')
		UPDATE billing 
		SET consultantFee = @consultantfee, medicalTestCost = @medicalcost, paymentMode = @paymentmode, @paymentstatus = @paymentstatus, paymentDate = @paymentdate, totalCost =  @totalcost, mediTestID = @meditestid, prescriptionID = @prescriptionid
	ELSE IF(@tablename = 'billing' AND @operation = 'DELETE')
		DELETE billing WHERE billingID = @billingid
END
GO

---- Start Execute sp_billing
EXEC sp_billing 1, 300, 'NON', 'UnPaid', '08-07-2018', 1, 301, 'billing','INSERT'
GO
---- End























--============================
--		CREATE VIEW
--============================

USE PatientManagementSystem
GO
CREATE VIEW vw_patientinfo
AS 
SELECT reg.regID,reg.fullName, reg.email, reg.password, pat.patientID, pat.address, pat.cellNo, pat.patientAge, pat.patientWeight,pat.patientHeight, pat.patientBldGroup
FROM registration reg
JOIN patient pat
ON reg.regID = pat.regID
GO

------ 

USE PatientManagementSystem
GO
CREATE VIEW vw_patientappointinfo
AS 
SELECT  reg.regID, reg.fullName, reg.email, reg.password,
		pat.patientID, pat.address, pat.cellNo, pat.patientAge, pat.patientWeight, pat.patientHeight, pat.patientBldGroup, 
		pres.prescriptionID, pres.prescriptionDate, pres.dieasesHistory, pres.medication, pres.notes
FROM registration reg
JOIN patient pat
ON reg.regID = pat.regID
JOIN prescription prescrip
ON pat.patientID = prescrip.patientID
JOIN appointment app
ON pat.patientID = app.patientID
JOIN prescription pres
ON pat.patientID =  pres.patientID
GO

---- 
USE PatientManagementSystem
GO
CREATE VIEW vw_patientbillinfo
AS 
SELECT	reg.regID,reg.fullName, reg.email, pat.patientID, pat.address, pat.cellNo, 
		bill.billingID, bill.consultantFee, bill.paymentDate, bill.paymentMode, bill.paymentStatus 
FROM registration reg
JOIN patient pat
ON reg.regID = pat.regID
JOIN billing bill
ON pat.patientID = bill.patientID
GO

--============================
--		Retrieve Data 
--============================
SELECT COUNT(vw_patientinfo.patientID) AS [Total Patient]
FROM vw_patientinfo
GO

SELECT COUNT(vw_patientappointinfo.prescriptionID) AS [Total Prescription]
FROM vw_patientappointinfo
GO

SELECT COUNT(vw_patientbillinfo.billingID) AS [Total Invoice]
FROM vw_patientbillinfo
GO

SELECT SUM(vw_patientbillinfo.consultantFee) AS [Total Earnings]
FROM vw_patientbillinfo

--- View Only those who make payment
SELECT billinfo.fullName, billinfo.cellNo, billinfo.email,billinfo.paymentDate, billinfo.paymentMode, billinfo.paymentStatus
FROM vw_patientbillinfo billinfo
WHERE billinfo.paymentStatus IN('Paid')
GO

--===========================================
--		SEARCH PATIENT BY NAME OR CELL NO
--===========================================
CREATE PROC sp_searchpatient
(
	@name varchar(20),
	@cell varchar(15)
)
AS

BEGIN
	SELECT fullName, cellNo, email, address
	FROM vw_patientinfo 
	WHERE vw_patientinfo.fullName LIKE '%'+@name+'%' OR vw_patientinfo.cellNo LIKE @cell+'%' 
END
GO

EXEC sp_searchpatient 'KALAM', '0180'













































































































































