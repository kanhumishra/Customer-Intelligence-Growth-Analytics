USE TelecomDB;
GO

BULK INSERT telco_customer_clean
FROM 'D:\Customer-Intelligence-Growth-Analytics\data\processed\telco_customer_clean.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    TABLOCK,
    CODEPAGE = '65001'
);
GO


-- Total Rows
SELECT COUNT(*) AS Total_Customers
FROM telco_customer_clean;
GO

-- Preview Data
SELECT TOP 10 *
FROM telco_customer_clean;
GO

-- Check for Duplicate Customer IDs
SELECT CustomerID,
       COUNT(*) AS Duplicate_Count
FROM telco_customer_clean
GROUP BY CustomerID
HAVING COUNT(*) > 1;
GO

-- Verify NULL values
SELECT
    SUM(CASE WHEN Churn_Reason IS NULL THEN 1 ELSE 0 END) AS Null_ChurnReason
FROM telco_customer_clean;


SELECT * FROM telco_customer_clean  


--CUSTOMER ANALYSIS
SELECT Gender,
       COUNT(*) AS Total_Customers
FROM telco_customer_clean
GROUP BY Gender;

--CHURN RATE BY CONTRACT 
SELECT Contract,
       ROUND(AVG(Churn_Score), 2) AS Churn_Rate
FROM telco_customer_clean
GROUP BY Contract;

--Revenue by Internet Service
SELECT Internet_Service,
       SUM(Total_Charges) AS Revenue
FROM telco_customer_clean
GROUP BY Internet_Service;

-- Top 10 city by revenue
SELECT Top(10)
City,
       SUM(Total_Charges) AS Revenue
FROM telco_customer_clean
GROUP BY City
ORDER BY Revenue DESC

--High risk customer 
SELECT CustomerID,
       Churn_Score,
       Monthly_Charges
FROM telco_customer_clean
WHERE Churn_Score >= 80;


WITH ChurnAnalysis AS
(
    SELECT
        Contract,
        ROUND(AVG(CAST(Churn_Value AS FLOAT)) * 100, 2) AS Churn_Rate
    FROM telco_customer_clean
    GROUP BY Contract
)
SELECT *
FROM ChurnAnalysis
ORDER BY Churn_Rate DESC;