USE master
CREATE DATABASE InventoryDBFinal
Go

USE InventoryDBFinal
GO

CREATE TABLE Student
(
	StdID int primary key identity not null,
	Name varchar(20),
	MInBangla int,
	MInEnglish int,
	TotalMarks int
)
GO

--=======================
CREATE FUNCTION fn_Total
(
	@bangla int, 
	@english int
)

RETURNS int
AS
BEGIN
	DECLARE @total int
	SET @total = @bangla + @english
	RETURN @total
END
GO
--========================

------------------------
DECLARE @mehedi int
	SET @mehedi = 10 

DECLARE @mamun int
	SET @mamun = 20

DECLARE @nasir int = dbo.fn_Total(@mehedi,@mamun)

SELECT @nasir
GO
------------------------
SELECT * FROM Student
GO
--========================
CREATE PROCEDURE sp_InsertStudent
@name varchar(20),
@mib int,
@mie int
AS
DECLARE @tm int
SET @tm = dbo.fn_Total(@mib,@mie)
INSERT INTO Student(Name, MInBangla, MInEnglish, TotalMarks)
VALUES(@name, @mib, @mie, @tm)
GO


--==============================
CREATE PROCEDURE sp_InsertStudent2nd
@name varchar(20),
@mib int,
@mie int,
@tm int
AS
INSERT INTO Student(Name, MInBangla, MInEnglish, TotalMarks)
VALUES(@name, @mib, @mie, @tm)
GO


INSERT INTO Student VALUES('Asad', 60, 70 , 80)
GO

-- Execute Store Procedure --
EXEC sp_InsertStudent 'Asad', 60, 70 
GO

EXEC sp_InsertStudent2nd 'Monir', 60, 70 , 130
GO

SELECT * FROM Student

--===========================

--=====================================
Use InventoryDBFinal
CREATE TABLE Items
(
ItemID int identity primary key,
ItemNo Ntext,
ItemName nvarchar(20),
ColorName nvarchar(20)
)
Go


Use InventoryDBFinal
Create Table Lots
(
LotID int identity primary key,
LotNo char(20),
Quantity int
)
Go

Use InventoryDBFinal
Create Table Stock
(
StockID int identity,
ItemID int Foreign Key References Items(ItemID),
LotID int Foreign Key References Lots(LotID),
UnitPrice money,
Vat int
)
Go


Create Clustered Index CIndexAllInfo On Stock(StockID)				-- Clustered Index
Go

Create Index NCIndexAllInfo On Items(ItemName)						-- Non Clustered Index
GO

Insert Into Items Values	 ('Item 1', 'Camp Shirt', 'Red'),
							 ('Item 2', 'Camp Shirt', 'Blue'),
							 ('Item 3', 'Dress Shirt','Red'),
							 ('Item 4', 'Dress Shirt', 'Blue'),
							 ('Item 5', 'T-Shirt', 'Red'),
							 ('Item 6', 'T-Shirt', 'Blue'),
							 ('Item 7', 'Polo Shirt', 'Red'),
							 ('Item 8', 'Polo Shirt', 'Blue')
GO

Insert Into Lots Values ('Lot 1', 6),
			('Lot 2', 12)
GO

Insert Into Stock Values	(1, 1, 1500, 15),
							(2, 2, 1200, 15),
							(3, 1, 1500, 15),
							(4, 2, 1200, 15),
							(5, 1, 1500, 15),
							(6, 2, 1200, 15),
							(7, 1, 1500, 15),
							(8, 2, 1200, 15),
							(1, 2, 1200, 15),
							(2, 1, 1500, 15),
							(3, 2, 1200, 15),
							(4, 1, 1500, 15),
							(5, 2, 1200, 15),
							(6, 1, 1500, 15),
							(7, 2, 1200, 15),
							(8, 1, 1500, 15)
GO

Select * From Items
Go

Select * From Lots
Go

Select * From Stock
Go





EXEC sp_InsertTableValues 'Item 9', 'Shirt', 'Black', 'Items', 'INSERT'
GO


--========================================================================
--		Insert/Update/Delete into muliple tables by store procedure
--========================================================================
USE InventoryDBFinal
GO

CREATE PROC sp_InsertTableValues
(
	@itemid int,
	@itemno ntext,
	@itemname nvarchar(20),
	@colorname nvarchar(20),
	@lotid int,
	@lotno char(20),
	@quantity int,
	@stockid int,
	@unitprice money,
	@vat int,
	@tablename varchar(20),
	@operation nvarchar(max)
)
AS 
BEGIN
	-- Items
	IF(@tablename = 'Items' AND @operation = 'INSERT')
		INSERT INTO Items VALUES(@itemno,@itemname,@colorname)
	 IF(@tablename = 'Items' AND @operation = 'UPDATE')	
		UPDATE Items SET ItemNo = @itemno, ItemName = @itemname, ColorName = @colorname WHERE ItemID = @itemid
	 IF(@tablename = 'Items' AND @operation = 'DELETE')	
		DELETE FROM Items WHERE ItemID = @itemid

	-- Lots 
	 IF(@tablename = 'Lots' AND @operation = 'INSERT')
		INSERT INTO Lots VALUES(@lotno, @quantity)
	 IF(@tablename = 'Lots' AND @operation = 'UPDATE')	
		UPDATE Lots SET LotNo = @lotno, Quantity = @quantity WHERE LotID = @lotid
	 IF(@tablename = 'Lots' AND @operation = 'DELETE')	
		DELETE FROM Lots WHERE LotID = @lotid

	-- Stock 
	 IF(@tablename = 'Stock' AND @operation = 'INSERT')
		INSERT INTO Stock VALUES(@itemid, @lotid, @unitprice, @vat)
	 IF(@tablename = 'Stock' AND @operation = 'UPDATE')	
		UPDATE Stock SET LotID = @itemid,  UnitPrice = @unitprice, Vat = @vat WHERE StockID = @stockid
	 IF(@tablename = 'Stock' AND @operation = 'DELETE')	
		DELETE FROM Stock WHERE StockID = @stockid
	
END
GO


Select * From Items
Go

Select * From Lots
Go

Select * From Stock
Go


--@itemid, @itemno, @itemname, @colorname 
--@lotid, @lotno, @quantity 
--@stockid, @unitprice, @vat 
--================	@tablename @operation 

EXEC sp_InsertTableValues 9,'Item 9', 'Shirt', 'Black', 2, 'Lot 1', 6, 1, 1655, 39, 'Items', 'INSERT'
GO

