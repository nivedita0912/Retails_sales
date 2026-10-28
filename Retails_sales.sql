create  database Retails_DataBase;
use Retails_DataBase;
-- dateshould be year , month , date-- 
create table Retails_sales (
transactions_id int,
sale_date	date,
sale_time	time,  
customer_id	int,
gender	varchar(10),
age	int,
category varchar(15),



quantiy	int,
price_per_unit int,	
cogs 	float,
total_sale float
);

Alter table  Retails_sales
add primary key (transactions_id);

 select * from  Retails_sales;
 drop table Retails_sales;
 show tables;
 rename table `sql - retail sales analysis_utf` to Retails_sales;
 
 
select count(*) from  Retails_sales;
desc Retails_sales;
alter table  Retails_sales 
RENAME COLUMN `ï»¿transactions_id` TO transactions_id;
select count(*) from Retails_sales group by gender ;
select * from Retails_sales where 
cogs is null
or
gender is null
or
category is null 
;

alter table Retails_sales
add primary key(transactions_id);

select count(*)  as total_customer from Retails_sales ; 
select count(distinct customer_id) as Total_unique_cust from Retails_sales;

select distinct category from Retails_sales;
 desc Retails_sales;
-- Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select count(*)
from Retails_sales 
where sale_date ='2022-11-05';


-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
select count(*) from Retails_sales
 where 
 category ="Clothing" and
quantiy <= 4
and 
date_format(sale_date,"%Y-%m") = "2022-11";

-- Write a SQL query to calculate the total sales (total_sale) for each category.:
select category, sum(total_sale) as net_sale , count(*) as total_order from Retails_sales group by category ;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select ROUND(avg(age),2)  as avg_age from Retails_sales where category = 'Beauty';

-- Write a SQL query to find all transactions where the total_sale is greater than 1000
select * from Retails_sales where total_sale > 1000;

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select gender , count(transactions_id) from Retails_sales group by gender;
desc Retails_sales;

-- Write a SQL query to calculate the average sale for each month. 
-- Find out best selling month in each year.
select * from (
select extract(Month from sale_date) as Month_,
extract(Year from sale_date) as Year_,
avg(total_sale)  as Avg_Sale ,
Rank() over(Partition by extract(Year from sale_date) order  by avg(total_sale) desc) as Rank_
from Retails_sales   
group by 1,2  ) as t1 
where Rank_ = 1;


select extract(Month from sale_date) as Month_,
extract(Year from sale_date) as Year_,
avg(total_sale)  as Avg_Sale 
from Retails_sales 
group by 2,1  order by 1,2 asc;

-- revise cte , temp , and window funcions 
-- Write a SQL query to find the top 5 customers based on the highest total sales.
select customer_id, sum(total_sale) as Total_sale
from  Retails_sales
group by customer_id  
order by Total_sale desc
limit 5;

-- Write a SQL query to find the number of unique customers who purchased items from each category.
select category , count(customer_id) from Retails_sales group by category;


-- Write a SQL query to create each shift and number of orders 
-- (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
select * from Retails_sales;

select Slots , count(*) from(
select * ,
case 
 when sale_time < 12 then "Morning"
when sale_time  between 12 and 17 then "Afternoon"
when sale_time > 17 then "Evening" 
 end as Slots
from Retails_sales) as t1 
group by Slots;
