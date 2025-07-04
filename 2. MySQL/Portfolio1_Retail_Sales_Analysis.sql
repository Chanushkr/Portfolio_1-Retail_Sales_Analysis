## 🗃️ MySQL Data Modeling – Retail Sales Analysis

-- After performing data cleaning and transformation in Python, the cleaned dataset was exported to MySQL for modeling. 
-- Below are the steps and SQL code snippets used to create **Fact and Dimension tables** for downstream Power BI reporting.
--

### ✅ Step 1: View Cleaned Data

-- ```sql
SELECT * FROM retail_sales_cleaned;


### 📦 Step 2: Create Fact Tables
-- ------------------------------------------------------------------------------------
-- FACT TABLE: fact_sales
-- ------------------------------------------------------------------------------------
-- Contains transactional-level data for all sales excluding returns.
-- Includes customer ID, product code, quantity, unit price, total price, and date.
-- Used to analyze total sales, revenue trends, and customer purchasing behavior.
-- ------------------------------------------------------------------------------------

-- ```sql
CREATE TABLE fact_sales AS
SELECT
    InvoiceNo,
    StockCode,
    CustomerID,
    InvoiceDate,
    Quantity,
    UnitPrice,
    TotalPrice,
    Transaction_Type
FROM retail_sales_cleaned
WHERE Transaction_Type = 'Sale';


-- ------------------------------------------------------------------------------------
-- FACT TABLE: fact_returns
-- ------------------------------------------------------------------------------------
-- Captures all return transactions where quantity is negative.
-- Helps in understanding return rates, financial impact of returns, and product quality issues.
-- Useful for return analysis, net revenue calculation, and customer satisfaction insights.
-- ------------------------------------------------------------------------------------

-- ```sql
CREATE TABLE fact_returns AS
SELECT
    InvoiceNo,
    StockCode,
    CustomerID,
    InvoiceDate,
    Quantity,
    UnitPrice,
    TotalPrice,
    Transaction_Type
FROM retail_sales_cleaned
WHERE Transaction_Type = 'Return';


### 📘 Step 3: Create Dimension Tables
-- ------------------------------------------------------------------------------------
-- DIMENSION TABLE: dim_products
-- ------------------------------------------------------------------------------------
-- Contains unique product-level data including stock code, description, and unit price.
-- Helps enrich sales/return facts with descriptive product info for better reporting.
-- Supports filtering and grouping reports by product name or category.
-- ------------------------------------------------------------------------------------

-- ```sql
CREATE TABLE dim_products AS
SELECT DISTINCT
    StockCode,
    Description,
    UnitPrice
FROM retail_sales_cleaned
WHERE StockCode IS NOT NULL;


-- ------------------------------------------------------------------------------------
-- DIMENSION TABLE: dim_customers
-- ------------------------------------------------------------------------------------
-- Contains distinct customer information such as CustomerID and Country.
-- Enables segmentation by geography and customer behavior patterns.
-- Useful for customer-level analysis, retention studies, and cohort reporting.
-- ------------------------------------------------------------------------------------

-- ```sql
CREATE TABLE dim_customers AS
SELECT DISTINCT
    CustomerID,
    Country
FROM retail_sales_cleaned
WHERE CustomerID IS NOT NULL;


-- ------------------------------------------------------------------------------------
-- DIMENSION TABLE: dim_date
-- ------------------------------------------------------------------------------------
-- Extracted date parts from InvoiceDate for time-based analysis.
-- Includes year, quarter, month, day, week number, and weekday name.
-- Supports time-series visualizations like trends, seasonality, and YTD/MoM analysis.
-- ------------------------------------------------------------------------------------

-- ```sql
CREATE TABLE dim_date AS
SELECT DISTINCT
    DATE(InvoiceDate) AS Date,
    InvoiceYear,
    InvoiceQuarter,
    InvoiceMonth,
    DAY(InvoiceDate) AS Day,
    WEEK(InvoiceDate) AS Week,
    MONTHNAME(InvoiceDate) AS MonthName,
    DAYNAME(InvoiceDate) AS WeekdayName
FROM retail_sales_cleaned
WHERE InvoiceDate IS NOT NULL;


### 🔍 Sample Query to Validate Tables

-- ```sql
SELECT * FROM fact_sales;
SELECT * FROM fact_returns;
SELECT * FROM dim_products;
SELECT * FROM dim_customers;
SELECT * FROM dim_date;


### 📈 Next Step
-- Proceed to connect this schema to Power BI using the MySQL Connector, build relationships using the star schema, and design dashboards.
