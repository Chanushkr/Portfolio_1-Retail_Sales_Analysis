# 🛍️ Online Retail Sales Analysis – Portfolio Project

This project demonstrates a complete data analysis pipeline using **Python**, **MySQL**, and **Power BI**. The raw Excel dataset is cleaned and processed using **Pandas**, stored in **MySQL**, and modeled into **Fact and Dimension tables**. The final data is used to create dashboards in **Power BI**.

---

## 📌 Project Overview

- **Data Source**: Online Retail dataset (Excel)
- **Tools Used**:
  - 🐍 Python (Pandas, SQLAlchemy)
  - 🛢️ MySQL
  - 📊 Power BI
- **Goal**: Prepare clean, structured data for analysis and visualization

---

## 🧹 Step 1: Data Cleaning (Python)

### 📦 Libraries Used

```python
import pandas as pd
from sqlalchemy import create_engine
import urllib.parse
```

### 📥 Load & Inspect Data
```python
df = pd.read_excel("Data/Online Retail.xlsx")
df.shape
df.dtypes
df.describe().round(2).T
```

### 🔍 Missing Values Check
```python
df.isnull().sum()
missing_percentage = df.isnull().mean() * 100
missing_percentage[missing_percentage > 0].apply(lambda x: f"{x:.2f} %")
```

### 🧼 Data Cleaning Steps
```python
# Dropping missing product descriptions
df = df.dropna(subset = ['Description'])

# Dropping rows with missing CustomerID
df = df.dropna(subset = ['CustomerID'])

# Tagging transactions as 'Sale' or 'Return'
df['Transaction_Type'] = df['Quantity'].apply(lambda x: 'Return' if x < 0 else 'Sale')

# Creating a TotalPrice column
df['TotalPrice'] = df['Quantity'] * df['UnitPrice']

# Converting InvoiceDate to datetime
df['InvoiceDate'] = pd.to_datetime(df['InvoiceDate'])

# Extracting date components
df['InvoiceYear'] = df['InvoiceDate'].dt.year
df['InvoiceQuarter'] = df['InvoiceDate'].dt.quarter
df['InvoiceMonth'] = df['InvoiceDate'].dt.month

# Removing duplicate rows
df = df.drop_duplicates()
```

### ✅ Final Cleaned Data Sample
```python
df.head()
```

## 💾 Step 2: Exporting to MySQL
### 📦 Install Required Packages
```python
pip install mysql-connector-python
pip install sqlalchemy
```

### 🔗 MySQL Connection & Export
```python
host = "localhost"
user = "root"
password = urllib.parse.quote_plus("your_password")
database = "portfolio1_retail_sales_analysis"

connection = create_engine(f"mysql+mysqlconnector://{user}:{password}@{host}/{database}")
df.to_sql(name='retail_sales_cleaned', con=connection, if_exists='replace', index=False)
```

## 🧱 Step 3: Data Modeling (MySQL)
### 📝 Table: retail_sales_cleaned
| Column Name       | Type     |
| ----------------- | -------- |
| InvoiceNo         | TEXT     |
| StockCode         | TEXT     |
| Description       | TEXT     |
| Quantity          | BIGINT   |
| InvoiceDate       | DATETIME |
| UnitPrice         | DOUBLE   |
| CustomerID        | DOUBLE   |
| Country           | TEXT     |
| Transaction\_Type | TEXT     |
| TotalPrice        | DOUBLE   |
| InvoiceYear       | INT      |
| InvoiceQuarter    | INT      |
| InvoiceMonth      | INT      |


### 📦 Fact and Dimension Tables
#### 📊 Fact Tables
```sql
-- Creating fact table for Sales Transactions
CREATE TABLE fact_sales AS
SELECT * FROM retail_sales_cleaned
WHERE Transaction_Type = 'Sale';

-- Creating fact table for Return Transactions
CREATE TABLE fact_returns AS
SELECT * FROM retail_sales_cleaned
WHERE Transaction_Type = 'Return';
```

#### 📐 Dimension Tables
```sql
-- Creating Customer Dimension Table
CREATE TABLE dim_customers AS
SELECT DISTINCT CustomerID, Country
FROM retail_sales_cleaned
WHERE CustomerID IS NOT NULL;

-- Creating Product Dimension Table
CREATE TABLE dim_products AS
SELECT DISTINCT StockCode, Description, UnitPrice
FROM retail_sales_cleaned;

-- Creating Calendar Dimension Table
CREATE TABLE dim_calendar AS
SELECT DISTINCT InvoiceDate, InvoiceYear, InvoiceQuarter, InvoiceMonth
FROM retail_sales_cleaned;
```

## 📊 Step 4: Power BI Dashboard
Data Source: MySQL Database
Data Modeling: Relationships established between fact and dimension tables:

  ❶ fact_sales.CustomerID → dim_customers.CustomerID
  
  ❷ fact_sales.StockCode → dim_products.StockCode
  
  ❸ fact_sales.InvoiceDate → dim_calendar.InvoiceDate


### 📄 Report Pages Created
1️⃣ Executive Summary

2️⃣ Manager Overview

3️⃣ Customer Details

4️⃣ Product Insights


### 📁 Folder Structure
Retail-Sales-Analysis/
├── Data/
│   └── Online Retail.xlsx
├── Python/
│   └── retail_data_cleaning.ipynb
├── SQL/
│   └── retail_fact_dim_modeling.sql
├── PowerBI/
│   └── Executive_Report.pbix
└── README.md


### 🧾 Data Cleaning & Transformation Summary
✅ Removed missing product descriptions (necessary for item-level analysis)

✅ Removed missing customer IDs (for accurate segmentation)

✅ Tagged each transaction as Sale or Return

✅ Created TotalPrice for revenue calculation

✅ Converted dates to datetime

✅ Extracted Year, Quarter, Month for time-based reporting

✅ Removed duplicate rows


#
## 🙋‍♂️ Author
KR Chanush

🧠 Data Analyst & BI Enthusiast | Learning Data Science

🔗 Connect on LinkedIn



## ⭐ If you found this project helpful, give it a ⭐ and share it with your network!
