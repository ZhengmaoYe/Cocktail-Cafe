IF NOT EXISTS(
	SELECT name FROM master.dbo.sysdatabases 
	WHERE name = N'CocktailCafe')
	
	CREATE DATABASE CocktailCafe

GO

USE CocktailCafe
GO


IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DrinkBase_Drink')
	DROP TABLE DrinkBase_Drink;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'Drink_Receipt')
	DROP TABLE Drink_Receipt;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'DrinkBase_Invoice')
	
	DROP TABLE DrinkBase_Invoice;
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'Location_Contact')
	
	DROP TABLE Location_Contact;
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'Contact')
	
	DROP TABLE Contact;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'Drink_Base')
	
	DROP TABLE Drink_Base;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'Supplier')
	
	DROP TABLE Supplier;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'Invoice')
	
	DROP TABLE Invoice;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'Drink')
	
	DROP TABLE Drink;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'Alcohol')
	
	DROP TABLE Alcohol;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'Coffee')
	
	DROP TABLE Coffee;
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'OrderAmount')
	
	DROP TABLE OrderAmount;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'Staff')
	
	DROP TABLE Staff;
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'Sale_Receipt')
	
	DROP TABLE Sale_Receipt;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'Customer')
	
	DROP TABLE Customer;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'CustomerLocation')
	
	DROP TABLE CustomerLocation;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'Store_Location')
	
	DROP TABLE Store_Location;

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE name = N'OrderAmount')
	
	DROP TABLE OrderAmount;


CREATE TABLE CustomerLocation
(
CustomerLocationID	INT NOT NULL PRIMARY KEY,
CustomerID	INT NOT NULL,
StreetAddress	VARCHAR(50) NOT NULL,
City		VARCHAR(20)  NOT NULL,
State		VARCHAR(20)  NOT NULL,
Zip			INT  NOT NULL
)

CREATE TABLE Customer
(
CustomerID INT NOT NULL PRIMARY KEY,
CustomerLocationID	INT NOT NULL CONSTRAINT fk_CustomerLocationID FOREIGN KEY (CustomerLocationID) REFERENCES CustomerLocation(CustomerLocationID),
Returning	VARCHAR(3) NOT NULL,
FirstName	VARCHAR(20) NOT NULL,
LastName	VARCHAR(20) NOT NULL,
Email		VARCHAR(50) NOT NULL,
Phone		VARCHAR(50) NOT NULL ,
)

CREATE TABLE OrderAmount
(
OrderAmountID   INT NOT NULL PRIMARY KEY,
DrinkID			VARCHAR(50) NOT NULL,
Amount			INT NOT NULL
)

CREATE TABLE Sale_Receipt
(
ReceiptID		INT NOT NULL PRIMARY KEY,
StaffID			INT NOT NULL,
CustomerID		INT NOT NULL CONSTRAINT fk_CustomerID FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
Amount_Tendered	DECIMAL(7,2) NOT NULL,
Date			DATE NOT NULL
)

CREATE TABLE Staff
(
StaffID		INT NOT NULL PRIMARY KEY,
LocationID	INT NOT NULL,
ReceiptID	INT NOT NULL CONSTRAINT fk_receiptID FOREIGN KEY(ReceiptID)REFERENCES Sale_Receipt (ReceiptID),
FirstName	VARCHAR(20) NOT NULL,
LastName	VARCHAR(20) NOT NULL,
Title		VARCHAR(50) NOT NULL,
PartTime	VARCHAR(3) NOT NULL,
Phone		VARCHAR(50) NOT NULL,
Email		VARCHAR(50) NOT NULL,
HireDate	DATE NOT NULL
)


CREATE TABLE Store_Location
(
LocationID INT NOT NULL PRIMARY KEY,
StaffID		INT NOT NULL,
StaffSize	INT NOT NULL,
StreetAddress	VARCHAR(50) NOT NULL,
City		VARCHAR(50) NOT NULL,
State		VARCHAR(50) NOT NULL,
Zip			INT NOT NULL,
DateOpened	DATE NOT NULL
)
--Connect Staff table and StoreLocation table via LocationID as a foreign key
ALTER TABLE Staff ADD CONSTRAINT fk_LocationID FOREIGN KEY(LocationID) REFERENCES Store_Location (LocationID);

CREATE TABLE Supplier
(
SupplierID	INT NOT NULL PRIMARY KEY,
InvoiceID	INT NOT NULL, 
FirstName	NVARCHAR(500) NOT NULL,
LastName	NVARCHAR(500) NOT NULL,
City		VARCHAR(50)	  NOT NULL
)

CREATE TABLE Contact
(
ContactID	INT NOT NULL PRIMARY KEY,
SupplierID INT NOT NULL CONSTRAINT fk_SupplierID FOREIGN KEY(SupplierID) REFERENCES Supplier(SupplierID),
Email		VARCHAR(500) NOT NULL,
Phone		INT NOT NULL,
City		VARCHAR(50) NOT NULL,
State		VARCHAR(50) NOT NULL
)

CREATE TABLE Drink
(
DrinkID		VARCHAR(50) NOT NULL PRIMARY KEY,
AlcoholID	INT NOT NULL,
CoffeeID	INT NOT NULL,
Price		DECIMAL(7,2) NOT NULL,
Cost		DECIMAL(7,2) NOT NULL,
Alcoholic	VARCHAR(3) NOT NULL
)
ALTER TABLE OrderAmount ADD CONSTRAINT fk_drinkID FOREIGN KEY (DrinkID) REFERENCES Drink(DrinkID)


CREATE TABLE Drink_Base
(
DrinkbaseID		VARCHAR(50) NOT NULL PRIMARY KEY,
CostPERg_oz		DECIMAL(7,2) NOT NULL
)


CREATE TABLE Coffee
(
CoffeeID	INT NOT NULL PRIMARY KEY,
DrinkID		VARCHAR(50) NOT NULL,
CountryOfOrigin	VARCHAR(20) NOT NULL,
AmountDBneed	INT NOT NULL,
RoastStrength	VARCHAR(50) NOT NULL
)

ALTER TABLE Drink ADD CONSTRAINT fk_CoffeeID FOREIGN KEY(CoffeeID)REFERENCES Coffee(CoffeeID)
--ALTER TABLE Drink_base ADD CONSTRAINT FK_Drink_base_CoffeeID FOREIGN KEY(DrinkbaseID) REFERENCES Drink_Base(DrinkbaseID)

--Gaby added values for Alcohol
CREATE TABLE Alcohol
(
AlcoholID	INT NOT NULL PRIMARY KEY,
DrinkID	VARCHAR(50) NOT NULL,
AmountDBneed	INT NOT NULL,
Brand		VARCHAR(25) NOT NULL
)
ALTER TABLE Drink ADD CONSTRAINT fk_AlcoholID FOREIGN KEY(AlcoholID)REFERENCES Alcohol(AlcoholID);
--ALTER TABLE Drink_base ADD CONSTRAINT FK_Drink_base_AlcoholID	FOREIGN KEY(DrinkbaseID) REFERENCES Drink_Base(DrinkbaseID);


CREATE TABLE Invoice
(
InvoiceID	INT NOT NULL PRIMARY KEY,
SupplierID	INT NOT NULL,
Date		DATE NOT NULL,
TotalCost	DECIMAL(7,2) NOT NULL
)
ALTER TABLE Supplier ADD CONSTRAINT fk_InvoiceID FOREIGN KEY(InvoiceID)REFERENCES Invoice(InvoiceID)


--location_contact, drinkbase_invoice, drink_receipt, drink_base_drink
CREATE TABLE Location_Contact
(	LocationID INT NOT NULL,
	ContactID INT NOT NULL,
	CONSTRAINT FK_Location_ContactID FOREIGN KEY (LocationID) REFERENCES Store_Location,
	CONSTRAINT FK_Contact_LocationID FOREIGN KEY (ContactID) REFERENCES Contact,
	CONSTRAINT PK_Location_Contact PRIMARY KEY (LocationID, ContactID)
)

CREATE TABLE DrinkBase_Invoice
(	DrinkBaseID VARCHAR(50) NOT NULL, 
	InvoiceID INT NOT NULL,
	CONSTRAINT FK_DrinkBase_InvoiceID FOREIGN KEY (DrinkBaseID) REFERENCES Drink_Base,
	CONSTRAINT FK_Invoice_DrinkBaseID FOREIGN KEY (InvoiceID) REFERENCES Invoice, 
	CONSTRAINT PK_DrinkBase_Invoice PRIMARY KEY (DrinkBaseID, InvoiceID)
)

CREATE TABLE Drink_Receipt
(	   Drink_ReceiptID INT NOT NULL PRIMARY KEY,
       DrinkID VARCHAR(50) NOT NULL,
       ReceiptID INT NOT NULL,
       CONSTRAINT FK_Drink_ReceiptID FOREIGN KEY (DrinkID) REFERENCES Drink,
       CONSTRAINT FK_Receipt_DrinkID FOREIGN KEY (ReceiptID) REFERENCES Sale_Receipt
)

CREATE TABLE DrinkBase_Drink
(	Drinkbase_DrinkID INT NOT NULL PRIMARY KEY,
	DrinkBaseID VARCHAR(50) NOT NULL, 
	DrinkID VARCHAR(50) NOT NULL,
	CONSTRAINT FK_DrinkBase_DrinkID FOREIGN KEY (DrinkBaseID) REFERENCES Drink_Base,
	CONSTRAINT FK_Drink_DrinkBaseID FOREIGN KEY (DrinkID) REFERENCES Drink
	
)
DECLARE @data_path NVARCHAR(MAX);
SELECT @data_path= 'C:\Users\icaru\source\repos\CocktailCafe ETL\Bulk Load data\';

EXECUTE (N'BULK INSERT Store_Location FROM ''' +@data_path + N'Store_Location.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');

EXECUTE (N'BULK INSERT CustomerLocation FROM ''' +@data_path + N'CustomerLocation.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');

EXECUTE (N'BULK INSERT Customer FROM ''' +@data_path + N'Customer.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');

EXECUTE (N'BULK INSERT Sale_Receipt FROM ''' +@data_path + N'Sale_Receipt.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');

EXECUTE (N'BULK INSERT Staff FROM ''' +@data_path + N'Staff.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');

EXECUTE (N'BULK INSERT Coffee FROM ''' +@data_path + N'Coffee.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');

EXECUTE (N'BULK INSERT Alcohol FROM ''' +@data_path + N'Alcohol.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');


EXECUTE (N'BULK INSERT Drink FROM ''' +@data_path + N'Drink.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');

EXECUTE (N'BULK INSERT Invoice FROM ''' +@data_path + N'Invoice.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');

EXECUTE (N'BULK INSERT OrderAmount FROM ''' +@data_path + N'OrderAmount.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');

EXECUTE (N'BULK INSERT Supplier FROM ''' +@data_path + N'Supplier.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');

EXECUTE (N'BULK INSERT Drink_Base FROM ''' +@data_path + N'Drink_Base.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');

EXECUTE (N'BULK INSERT Contact FROM ''' +@data_path + N'Contact.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');

EXECUTE (N'BULK INSERT Drinkbase_Drink FROM ''' +@data_path + N'Drinkbase_Drink.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');

EXECUTE (N'BULK INSERT Drink_Receipt FROM ''' +@data_path + N'Drink_Receipt.csv''
WITH (
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	KEEPIDENTITY,
	TABLOCK
	);
');
GO
SET NOCOUNT ON
SELECT 'Store_Location'AS "Table",	COUNT(*)AS "Rows"			FROM Store_Location UNION
SELECT 'CustomerLocation',	COUNT(*)			FROM CustomerLocation UNION
SELECT 'OrderAmount',       COUNT(*)            FROM OrderAmount UNION
SELECT 'Customer',			COUNT(*)			FROM Customer UNION
SELECT 'Sale_Receipt',		COUNT(*)			FROM Sale_Receipt UNION
SELECT 'Staff',				COUNT(*)			FROM Staff UNION
SELECT 'Coffee' ,			COUNT(*) 			FROM Coffee UNION
SELECT 'Alcohol',			COUNT(*)			FROM Alcohol UNION
SELECT 'Drink',				COUNT(*)			FROM Drink UNION
SELECT 'Invoice',			COUNT(*)			FROM Invoice UNION
SELECT 'Supplier',			COUNT(*)			FROM Supplier UNION
SELECT 'Drink_Base',		COUNT(*)			FROM Drink_Base UNION
SELECT 'Contact',			COUNT(*)			FROM Contact UNION
SELECT 'Drinkbase_Drink',   COUNT(*)            FROM Drinkbase_Drink UNION
SELECT 'Drink_Receipt',     COUNT(*)            FROM Drink_Receipt
ORDER BY 2;
SET NOCOUNT OFF
GO
