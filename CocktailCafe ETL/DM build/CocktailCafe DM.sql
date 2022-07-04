IF NOT EXISTS(SELECT name FROM master.dbo.sysdatabases			
	WHERE name = N'CocktailCafeDM')
	
	CREATE DATABASE CocktailCafeDM
GO

USE CocktailCafeDM
GO

IF EXISTS(
	SELECT*
	FROM sys.tables
	WHERE NAME = N'FactSales')

	DROP TABLE FactSales;

IF EXISTS(
	SELECT*
	FROM sys.tables
	WHERE NAME = N'DimCustomer')

	DROP TABLE DimCustomer;

IF EXISTS(
	SELECT*
	FROM sys.tables
	WHERE NAME = N'DimDate')

	DROP TABLE DimDate;

IF EXISTS(
	SELECT*
	FROM sys.tables
	WHERE NAME = N'DimStore')

	DROP TABLE DimStore;

IF EXISTS(
	SELECT*
	FROM sys.tables
	WHERE NAME = N'DimDrink')

	DROP TABLE DimDrink;

CREATE TABLE DimDate
	(
	Date_SK				INT PRIMARY KEY, 
	Date				DATE,
	FullDate			NCHAR(10),-- Date in MM-dd-yyyy format
	DayOfMonth			INT, -- Field will hold day number of Month
	DayName				NVARCHAR(9), -- Contains name of the day, Sunday, Monday 
	DayOfWeek			INT,-- First Day Sunday=1 and Saturday=7
	DayOfWeekInMonth	INT, -- 1st Monday or 2nd Monday in Month
	DayOfWeekInYear		INT,
	DayOfQuarter		INT,
	DayOfYear			INT,
	WeekOfMonth			INT,-- Week Number of Month 
	WeekOfQuarter		INT, -- Week Number of the Quarter
	WeekOfYear			INT,-- Week Number of the Year
	Month				INT, -- Number of the Month 1 to 12{}
	MonthName			NVARCHAR(9),-- January, February etc
	MonthOfQuarter		INT,-- Month Number belongs to Quarter
	Quarter				NCHAR(2),
	QuarterName			NVARCHAR(9),-- First,Second..
	Year				INT,-- Year value of Date stored in Row
	YearName			CHAR(7), -- CY 2017,CY 2018
	MonthYear			CHAR(10), -- Jan-2018,Feb-2018
	MMYYYY				INT,
	FirstDayOfMonth		DATE,
	LastDayOfMonth		DATE,
	FirstDayOfQuarter	DATE,
	LastDayOfQuarter	DATE,
	FirstDayOfYear		DATE,
	LastDayOfYear		DATE,
	IsHoliday			BIT,-- Flag 1=National Holiday, 0-No National Holiday
	IsWeekday			BIT,-- 0=Week End ,1=Week Day
	Holiday				NVARCHAR(50),--Name of Holiday in US
	Season				NVARCHAR(10)--Name of Season
	);

CREATE TABLE DimDrink
(
DrinkID_SK		INT IDENTITY(10,1) NOT NULL PRIMARY KEY,
DrinkID_AK		INT NOT NULL,
DrinkName		VARCHAR(50) NOT NULL,
DrinkBaseName   VARCHAR(50) NOT NULL,
CostPERg_oz		DECIMAL(7,2) NOT NULL,
Alcoholic		VARCHAR(3) NOT NULL
)

CREATE TABLE DimCustomer
(
CustomerID_SK	INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
CustomerID_AK	INT NOT NULL,
Returning		VARCHAR(3) NOT NULL,
City			VARCHAR(20) NOT NULL,
State			VARCHAR(20) NOT NULL,
ZipCode			INT NOT NULL
)

CREATE TABLE DimStore
(
StoreID_SK		INT IDENTITY(100,1) NOT NULL PRIMARY KEY,
StoreID_AK		INT NOT NULL,
DateOpened		DATE NOT NULL,
StaffSize		INT NOT NULL,
StartDate	    DATE NOT NULL,
EndDate			DATE NULL
)

CREATE TABLE FactSales
(
Sales_DD			INT NOT NULL,
StoreID_SK			INT NOT NULL,
DrinkID_SK			INT NOT NULL,
CustomerID_SK		INT NOT NULL,
Date_SK				INT NOT NULL,
DrinkPrice			DECIMAL(7,2) NOT NULL,
DrinkCost			DECIMAL(7,2) NOT NULL,
AlcoholAmount		DECIMAL NOT NULL,
CoffeeAmount		DECIMAL NOT NULL,
OrderAmount			INT NOT NULL
CONSTRAINT pk_FactSales PRIMARY KEY (StoreID_SK,DrinkID_SK,CustomerID_Sk,Date_SK),
CONSTRAINT fk_FactSales_Dimdate FOREIGN KEY (Date_SK) REFERENCES DimDate(Date_SK),
CONSTRAINT fk_FactSales_Dimstore FOREIGN KEY (StoreID_SK) REFERENCES DimStore(StoreID_SK),
CONSTRAINT fk_FactSales_DimDrink FOREIGN KEY (DrinkID_SK) REFERENCES DimDrink(DrinkID_SK),
CONSTRAINT fk_FactSales_DimCustomer FOREIGN KEY (CustomerID_SK) REFERENCES DimCustomer(CustomerID_SK)
)