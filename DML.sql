 
-- DIGITAL MARKETING SERVICES (DML OPERATIONS)

USE DigitalMarketingServices;
GO

INSERT INTO Users (UserName, Email, ContractNumber, FeedbackUsers)
VALUES 
('Rahim Ahmed', 'rahim@gmail.com', '019888', NULL),
('Karim Hossain', 'karim@gmail.com', '12364', NULL);
GO
INSERT INTO Users VALUES 
(' Hossain', 'Hossain@gmail.com', '152364', 'They provide very good service');
GO

SELECT*FROM Users



-- Insert into Employees
INSERT INTO Employees (UserID, DepartmentName, Designation, Description, Salary, EntryTime, OutTime)
VALUES
(1, 'Marketing', 'Manager', 'Handles campaigns', 50000, '09:00AM', '17:00PM'),
(2, 'SEO', 'Specialist', 'Handles SEO', 40000, '09:30 AM', '18:00PM');
GO
SELECT*FROM Employees


-- Insert into Services
INSERT INTO Services (ServicesName, Duration, StartDate, EndDate, Price)
VALUES
('Facebook Ads', '3 Day', '2025-01-01', '2025-03-31', 50000),
('Google Ads', '4 Day', '2025-02-01', '2025-05-01', 75000);
GO


SELECT*FROM Services

-- Insert into Clients
INSERT INTO Clients (ClientName, ContactEmail, ContactPhone, ServicesID, FeedbackClients)
VALUES
('Rahim Traders', 'rahim@traders.com', '0156985', 1, 'Good' ),
('Karim Enterprise', 'karim@enterprise.com', '01721592', 2, 'Poor service');
GO

SELECT*FROM Clients

-- Insert into Payments
INSERT INTO Payments (ClientID, ServicesID, Amount, PaymentDue, PaymentMethod)
VALUES
(1, 1, 20000, 30000, 'Bank Transfer'),
(2, 2, 35000, 40000, 'Credit Card');
GO

SELECT*FROM Payments

-- Insert into Feedback
INSERT INTO Feedback (UserID, ClientID)
VALUES
(1, 1),
(2, 2);
GO

SELECT*FROM  Feedback


-- Insert into Expenses
INSERT INTO Expenses (ExpenseName, Amount)
VALUES
('Office Rent', 15000),
('Software Subscription', 5000);

SELECT*FROM  Expenses
GO



-- Show Employees with their User info
SELECT e.EmployeeID, u.UserName, e.DepartmentName, e.Designation, e.Salary
FROM Employees e
JOIN Users u ON e.UserID = u.UserID;
GO

-- Show all Clients with Services
SELECT cl.ClientName, s.ServicesName, s.Price
FROM Clients cl
JOIN Services s ON cl.ServicesID = s.ServicesID;
GO


-- Total Payments
SELECT SUM(Amount) AS TotalPayments FROM Payments;
GO


-- Total Expenses
SELECT SUM(Amount) AS TotalExpenses FROM Expenses;
GO


-- Update Client Email
UPDATE Clients
SET ContactEmail = 'zchhh@yhahoo.com'
WHERE ClientID = 1;
GO


-- Delete a Payment
DELETE FROM Payments
WHERE PaymentID = 1;
GO


-- Truncate Payments table
TRUNCATE TABLE Payments;
GO

-- CTE (Common Table Expression)

USE DigitalMarketingServices;
GO

;WITH EmployeeClientCTE AS
(
    SELECT 
        e.EmployeeID,
        e.DepartmentName,
        e.Designation,
        COUNT(c.ClientID) AS TotalClients
    FROM Employees e
    LEFT JOIN Clients c ON e.UserID = c.ClientID  -- assume Employee.UserID maps to Client
    GROUP BY e.EmployeeID, e.DepartmentName, e.Designation
)
SELECT *
FROM EmployeeClientCTE
ORDER BY TotalClients DESC;


--Stored Procedure

CREATE PROCEDURE sp_add_new_client
    @clientname VARCHAR (100),
    @contactemail VARCHAR(150),
    @contactphone VARCHAR(20),
    @servicesid INT , 
    @feedbackclients VARCHAR(20)
AS
BEGIN
    INSERT INTO Clients VALUES
                        (
                        @clientname, 
                        @contactemail,
                        @contactphone, 
                        @servicesid,
                        @feedbackclients
                        );

  
    SELECT 'Client added successfully!' AS Message;

    
    
END
GO

-- Example execution
EXEC sp_add_new_client
    @clientName = 'Aziz Electronics',
    @contactEmail = 'aziz@asf.com',
    @contactPhone = '165979',
    @servicesid = 1,
    @feedbackClients ='nice';

    SELECT *FROM Clients
    GO

 DROP PROC sp_add_new_client;
 GO 

-- Trigger

USE DigitalMarketingServices;
GO

--  AFTER INSERT Trigger
CREATE TRIGGER trg_AfterInsertPayment
ON Payments
AFTER INSERT
AS
BEGIN
    PRINT 'AFTER INSERT Trigger fired: Payment has been added.';
END;
GO

--  INSERT Trigger
CREATE TRIGGER trg_InsteadOfInsertPayment
ON Payments
INSTEAD OF INSERT
AS
BEGIN
    PRINT 'INSTEAD OF INSERT Trigger fired: You tried to insert a Payment.';
   
    INSERT INTO Payments (ClientID, ServicesID, Amount, PaymentDue, PaymentMethod, PaymentDate, PaymentDueDate)
    SELECT ClientID, ServicesID, Amount, PaymentDue, PaymentMethod, PaymentDate, PaymentDueDate
    FROM inserted
    WHERE Amount > 0;
END;
GO

--  AFTER UPDATE Trigger
CREATE TRIGGER trg_AfterUpdatePayment
ON Payments
AFTER UPDATE
AS
BEGIN
    PRINT 'AFTER UPDATE Trigger fired: Payment has been updated.';
END;
GO


-- INSERT Trigger fire 
INSERT INTO Payments (ClientID, ServicesID, Amount, PaymentDue, PaymentMethod, PaymentDate, PaymentDueDate)
VALUES (1, 1, 5000, 5000, 'Cash', GETDATE(), DATEADD(DAY,30,GETDATE()));

--  AFTER Trigger fire 
UPDATE Payments
SET Amount = 5500
WHERE PaymentID = 1;

-- DROP Trigger

DROP TRIGGER trg_AfterUpdatePayment;
GO

-- VIEW
USE DigitalMarketingServices;
GO

CREATE VIEW vw_ClientServices
AS
SELECT 
    c.ClientID,
    c.ClientName,
    c.ContactEmail,
    s.ServicesName,
    s.Price
FROM Clients c
INNER JOIN Services s ON c.ServicesID = s.ServicesID;
GO

SELECT * FROM vw_ClientServices;
GO
-- ALTER VIEW 


ALTER VIEW vw_ClientServices
AS 
    SELECT c.ClientName, p.Amount, p.PaymentDate, p.PaymentMethod
    FROM dbo.Clients c
    JOIN dbo.Payments p ON c.ClientID = p.ClientID;
GO


-- DROP

VIEW vw_ClientServices;
GO


-- FUNCTION 
USE DigitalMarketingServices;
GO

CREATE FUNCTION fn_TotalPayments()
RETURNS MONEY
AS
BEGIN
    DECLARE @Total MONEY;

    SELECT @Total = ISNULL(SUM(Amount), 0)
    FROM Payments;

    RETURN @Total;
END
GO


-- Get total payments
SELECT dbo.fn_TotalPayments() AS TotalPayments;



USE DigitalMarketingServices;
GO

CREATE FUNCTION fn_TotalExpenses()
RETURNS MONEY
AS
BEGIN
    DECLARE @Total MONEY;

    SELECT @Total = ISNULL(SUM(Amount), 0)
    FROM Expenses;

    RETURN @Total;
END
GO


SELECT dbo.fn_TotalExpenses() AS TotalExpenses;

-- DROP FUNCTION 
DROP FUNCTION fn_TotalExpenses


-- ALL TYPE OF JOIN
USE DigitalMarketingServices;
GO

SELECT
    p.PaymentID,
    c.ClientName,
    s.ServicesName,
    s.Price AS ServicePrice,
    p.Amount AS PaymentAmount,
    p.PaymentDate,
    e.EmployeeID,
    e.DepartmentName,
    e.Designation
FROM Payments p
INNER JOIN Clients c ON p.ClientID = c.ClientID
INNER JOIN Services s ON p.ServicesID = s.ServicesID
LEFT JOIN Employees e ON e.UserID = c.ClientID;



-- ROLLUP Commit

USE DigitalMarketingServices;
GO

BEGIN TRANSACTION;

SELECT 
    c.ClientName,
    SUM(p.Amount) AS TotalPayment
INTO #TempPaymentRollup
FROM Payments p
INNER JOIN Clients c ON p.ClientID = c.ClientID
GROUP BY ROLLUP(c.ClientName);

DECLARE @TotalPayments MONEY;
DECLARE @TotalExpenses MONEY;

SELECT @TotalPayments = SUM(TotalPayment) FROM #TempPaymentRollup WHERE ClientName IS NOT NULL;
SELECT @TotalExpenses = ISNULL(SUM(Amount),0) FROM Expenses;


COMMIT TRANSACTION;

SELECT * FROM #TempPaymentRollup;

DROP TABLE #TempPaymentRollup;



