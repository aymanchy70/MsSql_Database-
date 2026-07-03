
-- DIGITAL MARKETING SERVICES 
USE master;
GO

--Database Create In Default Location With Custom Properties
 

DECLARE @data_path NVARCHAR (256);
SET @data_path = (SELECT SUBSTRING(physical_name, 1, CHARINDEX(N'master.mdf', LOWER(physical_name)) - 1)
      FROM master.sys.master_files
      WHERE database_id = 1 AND file_id = 1);
 -- Execute The Create Database Statement
EXECUTE ('CREATE DATABASE DigitalMarketingServices 
ON PRIMARY(NAME = DigitalMarketingServices_data, FILENAME = ''' + @data_path + 'DigitalMarketingServices_data.mdf'', SIZE = 16MB, MAXSIZE = Unlimited, FILEGROWTH = 2MB)
LOG ON (NAME = DigitalMarketingServices_log, FILENAME = ''' + @data_path + 'DigitalMarketingServices_log.ldf'', SIZE = 10MB, MAXSIZE = Unlimited, FILEGROWTH = 1MB)'
);
GO


-- Show Database Properties
sp_helpdb DigitalMarketingServices
GO

/* ==========================
  Users Table
========================== */
USE DigitalMarketingServices                          
CREATE TABLE Users 
(
    UserID INT PRIMARY KEY IDENTITY,
    UserName VARCHAR(100) NOT NULL,
    Email VARCHAR(150) UNIQUE NOT NULL,
    ContractNumber  VARCHAR(20),
    FeedbackUsers VARCHAR (500) NULL 
);
GO

/* ==========================
    Employees Table
========================== */
USE DigitalMarketingServices                          
CREATE TABLE Employees 
(
    EmployeeID INT PRIMARY KEY IDENTITY,
    UserID INT  FOREIGN KEY REFERENCES  Users(UserID),
    DepartmentName VARCHAR(100) NOT NULL,
    Designation VARCHAR(100),
    Description VARCHAR(255),
    Salary MONEY,
    EntryTime TIME NOT NULL,
    OutTime TIME NOT NULL
    
);
GO

-- Non-Clustered Index

USE DigitalMarketingServices;
GO

CREATE INDEX IX_Employees_DepartmentName
ON Employees (DepartmentName);

/* ==========================
   Services Table
========================== */
USE DigitalMarketingServices                          
CREATE TABLE Services 
(
    ServicesID INT PRIMARY KEY IDENTITY,
    ServicesName VARCHAR(150) NOT NULL,
    Duration VARCHAR(10),
    StartDate DATE,
    EndDate DATE,
    Price  MONEY,
);
GO


/* ==========================
     Clients Table
========================== */
USE DigitalMarketingServices
CREATE TABLE Clients 
(
    ClientID INT PRIMARY KEY IDENTITY,
    ClientName VARCHAR(100) NOT NULL,
    ContactEmail VARCHAR(150),
    ContactPhone VARCHAR(20),
    ServicesID INT FOREIGN KEY REFERENCES Services(ServicesID),
    FeedbackClients VARCHAR(500)
);
GO

/* ==========================
   Payments Table
========================== */
USE DigitalMarketingServices
CREATE TABLE Payments 
(
    PaymentID INT PRIMARY KEY IDENTITY,
    ClientID INT FOREIGN KEY REFERENCES Clients(ClientID),
    ServicesID INT FOREIGN KEY REFERENCES Services(ServicesID),
    Amount MONEY NOT NULL,
    PaymentDue MONEY,
    PaymentDate DATE DEFAULT GETDATE(),
    PaymentDueDate DATE DEFAULT GETDATE(),
   
    
);
GO
-- ADD COLIMN 
ALTER TABLE Payments
ADD  PaymentMethod VARCHAR(50) ;
GO


/* ==========================
    Feedback Users Table
========================== */
USE DigitalMarketingServices
CREATE TABLE Feedback
(
    FeedbackID INT PRIMARY KEY IDENTITY,
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    ClientID INT FOREIGN KEY REFERENCES Clients(ClientID) ,
);
GO





/* ==========================
   Expenses Table
========================== */
USE DigitalMarketingServices
CREATE TABLE Expenses 
(
    ExpenseID INT PRIMARY KEY IDENTITY,
    ExpenseName VARCHAR(100) NOT NULL,
    Amount MONEY NOT NULL,
    ExpenseDate DATE DEFAULT GETDATE(),
);
GO

-- CREATE NONCLUSTERED INDEX
CREATE NONCLUSTERED INDEX NCL_Employees_Designation
ON Employees (Designation);




--DROP TABLE Expenses;
--GO


--DROP DATABASE DigitalMarketingServices;
--GO
