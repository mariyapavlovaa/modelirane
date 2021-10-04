CREATE DATABASE VERSACE;
GO

USE VERSACE;
GO

CREATE TABLE Client (
	[ID] INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	[Username] VARCHAR(250) NOT NULL UNIQUE,
	[Password] VARCHAR(250) NOT NULL,
	[Name] NVARCHAR(250) NOT NULL,
	[Address] TEXT NOT NULL,
	[Phone] VARCHAR(250),
	[Email] VARCHAR(250),
	[BirthDay] DATE NOT NULL
);
GO

CREATE TABLE ProductType (
	[ID] INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	[Name] NVARCHAR(250) NOT NULL
);
GO

CREATE TABLE Product (
	[ID] INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	[Name] NVARCHAR(250) NOT NULL,
	[ProductTypeID] INT NOT NULL REFERENCES ProductType(ID) ON UPDATE NO ACTION ON DELETE NO ACTION,
	[Price] DECIMAL(19,4) NOT NULL,
	[Quantity] INT NOT NULL,
	[Origin] VARCHAR(500)
);
GO

CREATE TABLE Discount (
	[ID] INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	[Name] NVARCHAR(250) NOT NULL,
	[Percent] DECIMAL(19,4) NOT NULL,
);

CREATE TABLE [Order] (
	[ID] INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	[Date] DATE,
	[ClientID] INT NOT NULL FOREIGN KEY REFERENCES Client(ID) ON UPDATE NO ACTION ON DELETE NO ACTION,
	[DiscountID] INT NOT NULL FOREIGN KEY REFERENCES Discount(ID) ON UPDATE NO ACTION ON DELETE NO ACTION,
	[TotalPrice] DECIMAL(19,4) NOT NULL,
	[Address] TEXT NOT NULL,
	[Phone] VARCHAR(250),
	[Email] VARCHAR(250)
);
GO

CREATE TABLE [OrderDetail] (
	[ID] INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	[OrderID] INT NOT NULL FOREIGN KEY REFERENCES [Order](ID) ON UPDATE NO ACTION ON DELETE NO ACTION,
	[ProductID] INT NOT NULL FOREIGN KEY REFERENCES Product(ID) ON UPDATE NO ACTION ON DELETE NO ACTION,
	[Price] DECIMAL(19,4) NOT NULL,
	[Quantity] INT NOT NULL
);
GO

CREATE TRIGGER OrderDate ON [Order]
AFTER INSERT
AS
BEGIN
    UPDATE [Order]
    SET [Date] = GETDATE()
    FROM inserted
    WHERE [Order].id = inserted.id;
END
GO

CREATE PROCEDURE GetOrdersByPeriod(@FromDate DATE, @ToDate DATE)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT [Order].ID, [Order].Date, Client.Name, [Order].TotalPrice
	FROM [Order] INNER JOIN Client ON [Order].ClientID=Client.ID
	WHERE [Date] BETWEEN @FromDate AND @ToDate;
END;
GO


CREATE FUNCTION GetDateFormatted(@Date DATE) RETURNS VARCHAR(250)
AS
BEGIN
	RETURN DATENAME(YEAR, @Date) + '-' + DATENAME(MONTH, @Date) + '-' + DATENAME(DAY, @Date);
END;
GO

SET IDENTITY_INSERT Client ON;
GO

INSERT INTO Client (ID, Username, [Password], [Name], [Address], Phone, Email, BirthDay)
VALUES(1,'Maria','123','Maria Pavlova','Plovdiv, Center','0899123457','maria@gmail.com','1998-01-17');

SET IDENTITY_INSERT Client OFF;
GO

CREATE PROCEDURE CreateClient(
	@Username as VARCHAR(250),
	@Password as VARCHAR(250),
	@Name as NVARCHAR(250),
	@Address as TEXT,
	@Phone as VARCHAR(250),
	@Email as VARCHAR(250),
	@BirthDay as DATE)
AS
BEGIN
INSERT INTO Client(Username,[Password],[Name],[Address],Phone,Email,BirthDay)
VALUES(@Username,@Password,@Name,@Address,@Phone,@Email,@BirthDay);
END;
GO

EXEC CreateClient 'Veselin','vesko1','Veselin Pavlov','Plovdiv, Center','0895231276','vesko@gmail.com','1969/12/09';


SET IDENTITY_INSERT ProductType ON;
GO

INSERT INTO ProductType ([ID],[Name])
VALUES(8,'Home');

SET IDENTITY_INSERT ProductType OFF;
GO



SET IDENTITY_INSERT Product ON;
GO

INSERT INTO Product ([ID],[Name],[ProductTypeID],[Price],[Quantity],[Origin])
VALUES(9,'DYLAN BLUE POUR FEMME','1', 300,3,'Italian');

SET IDENTITY_INSERT Product OFF;
GO



INSERT INTO Discount ([Name],[Percent])
VALUES('Winter Discount',15);



SET IDENTITY_INSERT [Order] ON;
GO

INSERT INTO [Order] ([ID],[Date],[ClientID],[DiscountID],[TotalPrice],[Address],[Phone],[Email])
VALUES(4,'2020-12-10',4, 4,1800,'Plovdiv','0888485578','dimitur@abv.bg');

SET IDENTITY_INSERT [Order] OFF;
GO



SET IDENTITY_INSERT [OrderDetail]  ON;
GO

INSERT INTO [OrderDetail]  ([ID],[OrderID],[ProductID],[Price],[Quantity])
VALUES(3,3,3,3500,3);

SET IDENTITY_INSERT [OrderDetail]  OFF;
GO
