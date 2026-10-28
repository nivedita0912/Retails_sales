# Retails_sales
# Retail Sales Analysis Using SQL

## 📌 Project Overview

The **Retail Sales Analysis** project uses MySQL to analyze retail transaction data and extract meaningful insights about sales performance, customer purchasing behavior, product categories, and sales trends.

The project involves database creation, data exploration, data quality checks, and SQL-based business analysis using aggregate functions, date functions, subqueries, conditional statements, and window functions.

## 🎯 Project Objectives

- Explore and validate retail transaction data.
- Analyze total sales and order counts across product categories.
- Understand customer demographics and purchasing patterns.
- Identify the top five customers based on total sales.
- Analyze monthly sales trends and identify the highest-average-sales month in each year.
- Examine sales transactions by gender and category.
- Categorize transactions into morning, afternoon, and evening shifts.
- Practice solving business problems using SQL.

## 🛠️ Tools and Technologies

- **Database:** MySQL
- **SQL Editor:** MySQL Workbench
- **Dataset:** Retail sales transaction data in CSV format
- **Language:** SQL

## 🗂️ Project Structure

```text
Retail-Sales-Analysis/
│
├── sql_query_p1.sql
├── SQL - Retail Sales Analysis_utf.csv
└── README.md
```

*The filenames above reflect the files used during the project. Update them if your repository uses different names.*

## 🗄️ Database and Table Structure

The project uses a database named `Retails_DataBase` and a table named `Retails_sales`.

The table contains the following columns:

| Column | Description |
|---|---|
| `transactions_id` | Unique transaction identifier |
| `sale_date` | Date of the sale |
| `sale_time` | Time of the sale |
| `customer_id` | Customer identifier |
| `gender` | Customer gender |
| `age` | Customer age |
| `category` | Product category |
| `quantiy` | Quantity sold |
| `price_per_unit` | Price per unit |
| `cogs` | Cost of goods sold |
| `total_sale` | Total sale amount for the transaction |

**Note:** The column name `quantiy` follows the original table schema. It can be renamed to `quantity` for better readability.

## ⚙️ Database Setup

### 1. Create the database

```sql
CREATE DATABASE Retails_DataBase;

USE Retails_DataBase;
```

### 2. Create the sales table

```sql
CREATE TABLE Retails_sales (
    transactions_id INT,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(15),
    quantiy INT,
    price_per_unit INT,
    cogs FLOAT,
    total_sale FLOAT
);
```

### 3. Set the primary key

```sql
ALTER TABLE Retails_sales
ADD PRIMARY KEY (transactions_id);
```

This requires `transactions_id` to contain unique, non-null values.

### 4. Explore the table

```sql
SELECT * FROM Retails_sales;

DESC Retails_sales;

SELECT COUNT(*)
FROM Retails_sales;
```

If you import the CSV directly into MySQL Workbench, ensure that the imported column names match those used in your queries.

## 🔍 SQL Analysis and Business Questions

### 1. Data Exploration and Quality Checks

**Count all records**

```sql
SELECT COUNT(*)
FROM Retails_sales;
```

**Check the table structure**

```sql
DESC Retails_sales;
```

**Check for missing values in important columns**

```sql
SELECT *
FROM Retails_sales
WHERE cogs IS NULL
   OR gender IS NULL
   OR category IS NULL;
```

**Find distinct product categories**

```sql
SELECT DISTINCT category
FROM Retails_sales;
```

**Count distinct customers**

```sql
SELECT COUNT(DISTINCT customer_id) AS total_unique_customers
FROM Retails_sales;
```

These queries help inspect the dataset, identify missing values in selected fields, and understand the available categories and customer population.

### 2. Sales on a Specific Date

**Business question:** How many transactions occurred on November 5, 2022?

```sql
SELECT COUNT(*) AS total_transactions
FROM Retails_sales
WHERE sale_date = '2022-11-05';
```

### 3. Clothing Transactions in November 2022

**Business question:** How many Clothing transactions had a quantity greater than 4 in November 2022?

```sql
SELECT COUNT(*) AS total_transactions
FROM Retails_sales
WHERE category = 'Clothing'
  AND quantiy > 4
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01';
```

This query combines category filtering, quantity filtering, and a date range.

### 4. Total Sales by Product Category

**Business question:** What are the total sales and number of transactions for each category?

```sql
SELECT
    category,
    SUM(total_sale) AS net_sales,
    COUNT(*) AS total_orders
FROM Retails_sales
GROUP BY category;
```

This identifies categories contributing the most revenue and transaction volume.

### 5. Average Customer Age in the Beauty Category

**Business question:** What is the average age of customers who purchased Beauty products?

```sql
SELECT
    ROUND(AVG(age), 2) AS average_age
FROM Retails_sales
WHERE category = 'Beauty';
```

### 6. High-Value Transactions

**Business question:** Which transactions have a total sale greater than 1,000?

```sql
SELECT *
FROM Retails_sales
WHERE total_sale > 1000;
```

This filters transactions based on their total sale amount.

### 7. Transaction Count by Gender and Category

**Business question:** How many transactions were made by each gender in each category?

```sql
SELECT
    gender,
    category,
    COUNT(transactions_id) AS total_transactions
FROM Retails_sales
GROUP BY gender, category
ORDER BY gender, category;
```

Grouping by both gender and category provides a more detailed breakdown than grouping by gender alone.

### 8. Monthly Average Sales

**Business question:** What is the average sale amount for each month?

```sql
SELECT
    EXTRACT(YEAR FROM sale_date) AS sales_year,
    EXTRACT(MONTH FROM sale_date) AS sales_month,
    ROUND(AVG(total_sale), 2) AS average_sale
FROM Retails_sales
GROUP BY
    EXTRACT(YEAR FROM sale_date),
    EXTRACT(MONTH FROM sale_date)
ORDER BY sales_year, sales_month;
```

This query groups transactions by year and month to show how average sales change over time.

### 9. Highest-Average-Sales Month in Each Year

**Business question:** Which month had the highest average transaction value in each year?

```sql
SELECT *
FROM (
    SELECT
        EXTRACT(YEAR FROM sale_date) AS sales_year,
        EXTRACT(MONTH FROM sale_date) AS sales_month,
        AVG(total_sale) AS average_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS sales_rank
    FROM Retails_sales
    GROUP BY
        EXTRACT(YEAR FROM sale_date),
        EXTRACT(MONTH FROM sale_date)
) AS monthly_sales
WHERE sales_rank = 1;
```

**SQL concepts used:** `EXTRACT()`, `AVG()`, `GROUP BY`, subqueries, and `RANK()` window functions.

The `RANK()` function returns all months tied for the highest average sale within a year.

*Note: This identifies the month with the highest average transaction value, not necessarily the month with the highest total revenue. To find the best-selling month by revenue, use `SUM(total_sale)` instead of `AVG(total_sale)`.*

### 10. Top Five Customers by Total Sales

**Business question:** Which five customers generated the highest total sales?

```sql
SELECT
    customer_id,
    SUM(total_sale) AS total_sales
FROM Retails_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

This aggregates transaction values for each customer and returns the five highest totals.

### 11. Unique Customers by Category

**Business question:** How many distinct customers purchased from each category?

```sql
SELECT
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM Retails_sales
GROUP BY category;
```

`COUNT(DISTINCT customer_id)` ensures that a customer who makes multiple purchases in the same category is counted only once within that category.

### 12. Customers Who Purchased from Every Category

**Business question:** Which customers purchased items from all categories available in the dataset?

```sql
SELECT customer_id
FROM Retails_sales
GROUP BY customer_id
HAVING COUNT(DISTINCT category) = (
    SELECT COUNT(DISTINCT category)
    FROM Retails_sales
);
```

This query uses a subquery and `HAVING` to identify customers whose purchases cover every distinct category in the dataset.

### 13. Number of Orders by Time of Day

**Business question:** How many transactions occurred during the morning, afternoon, and evening?

For this analysis, the shifts are defined as:

- **Morning:** Before 12:00 PM
- **Afternoon:** 12:00 PM through 5:00 PM
- **Evening:** After 5:00 PM

```sql
SELECT
    CASE
        WHEN sale_time < '12:00:00' THEN 'Morning'
        WHEN sale_time <= '17:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS sales_shift,
    COUNT(*) AS total_orders
FROM Retails_sales
GROUP BY sales_shift
ORDER BY FIELD(
    sales_shift,
    'Morning',
    'Afternoon',
    'Evening'
);
```

This uses a `CASE` expression to classify transactions into shifts and aggregate the number of orders in each shift.

## 🧠 SQL Concepts Practiced

| SQL concept | Application |
|---|---|
| Filtering with `WHERE` | Finding transactions that meet specific conditions |
| `GROUP BY` | Summarizing sales by category, month, gender, and customer |
| Aggregate functions | Calculating totals, averages, and counts |
| `COUNT(DISTINCT ...)` | Counting unique customers |
| Date functions | Analyzing sales by year and month |
| `CASE` expressions | Categorizing sales into time shifts |
| Subqueries | Finding customers who purchased across all categories |
| Window functions | Ranking months by average sales |
| `HAVING` | Filtering grouped customer records |
| `ORDER BY` and `LIMIT` | Identifying the top five customers |

## 💡 Key Learning Outcomes

Through this project, I practiced:

- Exploring and validating retail transaction data.
- Translating business questions into SQL queries.
- Aggregating sales and customer information.
- Analyzing trends across time periods and product categories.
- Using subqueries and window functions to solve more advanced analytical problems.
- Understanding the difference between transaction counts, unique customer counts, average sales, and total sales.

## 🚀 Future Improvements

- Add actual business findings based on query results.
- Analyze revenue contribution by category.
- Identify repeat customers and customer purchase frequency.
- Compare monthly revenue growth and seasonality.
- Connect the SQL analysis to Power BI to create an interactive dashboard.

## 👩‍💻 Author

**Nivedita Thapliyal**

Software Engineering Graduate | Aspiring Data Analyst

