use master
CREATE DATABASE InventoryDB_20180813
GO

use InventoryDB_20180813
CREATE TABLE Items
(
ItemsID int primary key identity not null,
ItemNo nvarchar(max) not null,
ItemName nvarchar(max) not null,
Color nvarchar(max) not null
)
GO

CREATE TABLE Lot
(
LotID int primary key identity not null,
LotNo nvarchar(max) not null,
ItemNo nvarchar(max) not null,
)
GO

CREATE TABLE Quantity
(
QuantityID int primary key identity not null,
LotNo nvarchar(max) not null,
Quantity int not null,
UnitPrice money not null,
Vat decimal(10,2) not null,
Total as ((Quantity*UnitPrice)+(Quantity*UnitPrice)*Vat)
)
GO

INSERT INTO Items VALUES('Item 1','Camp Shirt','Red'),
						('Item 2','Camp Shirt','Blue'),
						('Item 3','Dress Shirt','Red'),
						('Item 4','Dress Shirt','Blue'),
						('Item 5','T-Shirt','Red'),
						('Item 6','T-Shirt','Blue'),
						('Item 7','Polo Shirt','Red'),
						('Item 8','Polo Shirt','Blue')
GO

INSERT INTO Lot VALUES('Lot 1', 'Item 1'),
					  ('Lot 1', 'Item 3'),
					  ('Lot 1', 'Item 5'),
					  ('Lot 1', 'Item 7'),
					  ('Lot 2', 'Item 2'),
					  ('Lot 2', 'Item 4'),
					  ('Lot 2', 'Item 6'),
					  ('Lot 2', 'Item 8')
GO

INSERT INTO Quantity VALUES('Lot 1',6,1500,.15),
			    ('Lot 2',12,1200,.15)
GO

SELECT * FROM Items
SELECT * FROM Lot
SELECT * FROM Quantity

SELECT DISTINCT ItemName
FROM Items

SELECT TOP 5 LOT.ItemNo, Quantity.Quantity
FROM Lot
JOIN Quantity
ON Lot.LotNo=Quantity.LotNo

SELECT TOP 3 ItemNo, ItemName
FROM Items
GO

SELECT TOP 3 PERCENT ItemNo, ItemName
FROM Items
GO

SELECT TOP 3 WITH TIES Color, ItemName
FROM Items
ORDER BY Color asc
go

SELECT * 
FROM Items 
WHERE ItemName < 'D'

SELECT l.LotNo, i.ItemNo, i.ItemName, i.Color, q.Quantity,q.UnitPrice,q.Vat, q.Total
FROM Lot l
JOIN Items i
ON l.ItemNo=i.ItemNo
JOIN Quantity q
ON l.LotNo=q.LotNo
GO 


SELECT l.LotNo, i.ItemNo, i.ItemName, i.Color, q.Quantity,q.UnitPrice,q.Vat, q.Total
FROM Lot l
JOIN Items i
ON l.ItemNo=i.ItemNo
JOIN Quantity q
ON l.LotNo=q.LotNo
WHERE Color='Red'
GO 

SELECT l.LotNo, i.ItemNo, i.ItemName, i.Color, q.Quantity,q.UnitPrice,q.Vat, q.Total
FROM Lot l
JOIN Items i
ON l.ItemNo=i.ItemNo
JOIN Quantity q
ON l.LotNo=q.LotNo
WHERE Color IN(SELECT Color FROM Items WHERE Color='Red')
GO 

SELECT l.LotNo, i.ItemNo, i.ItemName, i.Color, q.Quantity,q.UnitPrice,q.Vat, q.Total
FROM Lot l
JOIN Items i
ON l.ItemNo=i.ItemNo
JOIN Quantity q
ON l.LotNo=q.LotNo
WHERE Color IN(SELECT Color FROM Items WHERE Color='Red' OR Color='Blue')
GO 

--===============
-- SELECT, FROM, WHERE
SELECT * 
FROM Items
WHERE ItemsID > 5 
GO

-- GROUP BY

SELECT Color
FROM Items
WHERE ItemsID > 5
GROUP BY Color
GO

SELECT Color, COUNT(ItemsID) AS [Total Items For This Color]
FROM Items
GROUP BY Color
GO

-- Having
SELECT COUNT(ItemsID) Color 
FROM Items
GROUP BY Color
HAVING COUNT(ItemsID)<4
GO


-- ALL
--SELECT COUNT(ItemsID), Color
--FROM Items
--WHERE ItemsID < 7
--GROUP BY Color
--HAVING COUNT(ItemsID) < 8
--ORDER BY COUNT(ItemsID) ASC
--GO



--=================================
-- CAST AND CONVERT
--=================================

-- The CAST function is used to convert from a value from one data type to another.
-- The main difference between CAST and CONVERT is that CONVERT also allows you to define a format for the converted value.

SELECT GETDATE()
SELECT 'Now Time IS: ' + CAST(GETDATE() as varchar)


SELECT 'Now Time IS: ' + CONVERT(varchar, GETDATE())

-- CONVERT 
SELECT 'Now Time IS: ' + CONVERT(varchar, GETDATE(), 101)
SELECT 'Now Time IS: ' + CONVERT(varchar, GETDATE(), 102)
SELECT 'Now Time IS: ' + CONVERT(varchar, GETDATE(), 103)
SELECT 'Now Time IS: ' + CONVERT(varchar, GETDATE(), 104)
SELECT 'Now Time IS: ' + CONVERT(varchar, GETDATE(), 105)


SELECT 'Now Time IS: ' + CONVERT(varchar, GETDATE(), 1) -- American Syle
SELECT 'Now Time IS: ' + CONVERT(varchar, GETDATE(), 2) -- ANSI Style
SELECT 'Now Time IS: ' + CONVERT(varchar, GETDATE(), 3) -- British or French
SELECT 'Now Time IS: ' + CONVERT(varchar, GETDATE(), 4) -- German
SELECT 'Now Time IS: ' + CONVERT(varchar, GETDATE(), 5) -- Italian

-- FLOOR Function
DECLARE @x money = 12.99999
SELECT FLOOR(@x) AS [Floor Value]
GO

--DECLARE @x money = 12.50
--SELECT FLOOR(@x) AS [Floor Value]
--GO

-- Round Function
--DECLARE @x money = 12.69
--SELECT ROUND(@x,0) AS [Floor Value]
--GO

-- CEILING Function  
DECLARE @x money = 12.00
SELECT CEILING(@x) AS [Floor Value]
GO

-- DATEDIFF Function
SELECT DATEDIFF(YY, CAST('11/30/1992' AS datetime), GETDATE()) AS Years,
	   DATEDIFF(MM, CAST('11/30/1992' AS datetime), GETDATE())%12 AS Months,
	   DATEDIFF(DD, CAST('11/30/1992' AS datetime), GETDATE())%30 AS Days
GO

--=============================
--		Logical
--=============================

if(null = null)
	print 'It Does'
else
	print 'It Does not'
GO

--======================
--		While Loop
--======================
DECLARE @i int = 0;
WHILE @i<=10
	BEGIN
		print 'The value is : ' + CAST(@i as varchar);	
		SET @i = @i+1;
	END
GO


SELECT DATEDIFF(DD, '11/30/1992' , GETDATE()) AS Days
SELECT DATEDIFF(DAY, '11/30/1992' , GETDATE()) AS Days





