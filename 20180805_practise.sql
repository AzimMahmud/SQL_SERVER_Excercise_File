use master
create database InventoryDB
ON Primary(Name='InventoryDB_Data', FILENAME='D:\R38_AZIM\SQL Server\InventoryDB.mdf', SIZE=10MB, MAXSIZE=50MB, FILEGROWTH=5%)
LOG ON(Name='InventoryDB_Log', FILENAME='D:\R38_AZIM\SQL Server\InventoryDB.ldf',  SIZE=2MB, MAXSIZE=25MB, FILEGROWTH=1MB)

go

