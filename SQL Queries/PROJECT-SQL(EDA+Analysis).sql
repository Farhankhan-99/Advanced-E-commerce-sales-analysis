-- Step 1: Create schema
CREATE SCHEMA IF NOT EXISTS gold;

-- Creating tables and load data in it 
CREATE TABLE gold.customers (
customer_key INT,
customer_id INT,
customer_number VARCHAR(50),
first_name VARCHAR(50),
last_name VARCHAR(50),
country VARCHAR(50),
marital_status VARCHAR(50),
gender VARCHAR(50),
birthdate DATE,
create_date DATE
);
-- Load customer 
COPY gold.customers
FROM 'C:\SQL\gold.dim_customers.csv'
WITH (
    FORMAT CSV,
    HEADER,
    DELIMITER ','
);


CREATE TABLE gold.products (
product_key INT,
product_id INT,
product_number VARCHAR(50),
product_name VARCHAR(50),
category_id VARCHAR(50),
category VARCHAR(50),
subcategory VARCHAR(50),
maintenance VARCHAR(50),
cost INT,
product_line VARCHAR(50),
start_date DATE
);
-- Load products
COPY gold.products
FROM 'C:/SQL/gold.dim_products.csv'
WITH (
    FORMAT CSV,
    HEADER,
    DELIMITER ','
);


CREATE TABLE gold.sales (
    order_number VARCHAR(50),
    product_key INT,
    customer_key INT,
    order_date DATE,
    shipping_date DATE,
    due_date DATE,
    sales_amount INT,
    quantity SMALLINT,
    price INT
);
-- Load sales
TRUNCATE TABLE gold.sales;

COPY gold.sales
FROM 'C:/SQL/gold.fact_sales.csv'
WITH (
    FORMAT CSV,
    HEADER,
    DELIMITER ','
);

select * from gold.customers;
select * from gold.products;
select * from gold.sales;


-- TO Check total rows 
select count(*) from gold.customers;
select count(*) from gold.products;
select count(*) from gold.sales;


-- # 1) EXPLORE THE DATABASE 

-- explore all objects in the database 
select * from information_schema.tables;

-- explore all columns in the database 
select * from information_schema.columns
where table_schema='gold';

-- explore all object in the tables 
select * from information_schema.columns
where table_name='customers';

select * from information_schema.columns
where table_name='products';

select * from information_schema.columns
where table_name='sales';


-- # 2) DIMENSION (abcd) EXPLORATION

-- explore all the countries our customers come from 
select
distinct country
from gold.customers;

-- explore all products categories "The major divison" ( all unique categories)
select 
distinct category,subcategory,product_name
from gold.products
order by 1,2,3;

-- # 3) DATE EXPLORATION 

-- find the date of first and last orders
--how many years of sales are availabe
select
min(order_date) as first_orders,
max(order_date) as last_order,
age(max(order_date::timestamp), min(order_date::timestamp)) as date_diff_all,
extract(year from age(max(order_date::timestamp), min(order_date::timestamp))) as diff_years,
extract(month from age(max(order_date::timestamp), min(order_date::timestamp))) as month_diff,
extract(day from age(max(order_date::timestamp), min(order_date::timestamp))) as day_diff
from gold.sales;

-- find the most youngest and oldest customer
select
  'youngest' as age_group,
  concat(first_name, ' ', last_name) as customer_name,
  age(current_timestamp, birthdate) as date_diff
from gold.customers
where birthdate = (select max(birthdate) from gold.customers)
union all
select
  'oldest' as age_group,
  concat(first_name, ' ', last_name) as customer_name,
  age(current_timestamp, birthdate) as date_diff
from gold.customers
where birthdate = (select min(birthdate) from gold.customers);

-- # 4) MEASURES EXPLORATION

-- find the total sales
select  sum(sales_amount) total_sales from gold.sales;

-- find how many items are sold
select  sum(quantity) as total_item_sold from gold.sales;

-- find the average selling price
select round(avg(price),2) as avg_price from gold.sales;

-- find the total numbers of orders
select count(distinct order_number) as total_orders from gold.sales;

-- find the total numbers of products
select count(distinct product_key) from gold.products;

-- find the total numbers of customers
select count(distinct customer_key) as total_customers
from gold.customers;

-- find the total numbers of customers that has placed an order
select count(distinct customer_key) as customers_who_ordered
from gold.sales;

-- GENERATE A REPORT THAT SHOWS ALL KEY METRICS OF BUSINESS

select 'total_sales' as Measure_name ,sum(sales_amount) Measure_value from gold.sales
union all
select 'total_quantity' as measure_name, sum(quantity) Measure_value  from gold.sales
union all
select 'avg_price ' as measure_name ,round(avg(price),2) measure_value from gold.sales
union all
select 'Total_Orders' as measure_name ,count(distinct order_number) measure_value from gold.sales
union all
select 'Total_Products' as measure_name ,count(distinct product_key)  measure_value from gold.products
union all
select 'Total_Customers' as measure_name ,count(distinct customer_key)  measure_value from gold.customers
union all
select 'Total_customers_ordered' as measure_name ,count(distinct customer_key)  measure_value from gold.sales


--# 5) MAGNITUDE  ( [measures] by [dimensions] ) e.g total_sales by country etc...

-- find the total customers by countries
select 
country,
count(customer_key) as total_customers
from gold.customers
group by country order by count(customer_key) desc;

-- find the total customers by gender
select 
gender,
count(customer_key) as total_customers
from gold.customers
group by gender; 

-- find the total products by category
select
category,
count(product_key) as total_products
from gold.products
group by category; 

-- what is the avg cost in each category?
select 
category,
round(avg(cost),2) as avg_cost
from gold.products
group by category order by avg(cost) desc;

-- what is the total_revenue generated for each category?
select 
p.category,
sum(s.sales_amount)
from gold.sales s
left join gold.products p
on s.product_key=p.product_key
group by p.category
 
-- find the total_revenue generated by each customers?
select 
c.customer_key,
c.first_name,c.last_name,
sum(s.sales_amount) total_revenue
from gold.sales s
left join gold.customers c
on s.customer_key=c.customer_key
group by c.customer_key,c.first_name,c.last_name
order by total_revenue desc;

select * from gold.sales;
select * from gold.customers;

-- what is the distribution of sold items across countries?
select
c.country,
sum(s.quantity) total_sold_item
from gold.sales s
left join gold.customers c
on s.customer_key=c.customer_key
group by c.country
order by total_sold_item desc;

--# RANKING ANALYSIS ( order the values of dimension by measures) e.g Top N performers /rank countries by totalsales

-- which 6 products generate the highest revenue 
select 
p.product_name,
sum(s.sales_amount) as total_revenue
from gold.products p 
left join gold.sales s
on p.product_key=s.product_key
group by p.product_name
order by total_revenue desc nulls last 
limit 5;
--OR
SELECT 
  p.product_name,
  SUM(s.sales_amount) AS total_revenue,
  ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount) DESC NULLS LAST) AS rank
FROM gold.products p 
LEFT JOIN gold.sales s ON p.product_key = s.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC NULLS LAST
LIMIT 5;                                                  

-- what are the  5 worst-performing products in terms of sales  
select 
p.product_name,
sum(s.sales_amount) as total_revenue
from gold.products p 
left join gold.sales s
on p.product_key=s.product_key
group by p.product_name
order by total_revenue asc nulls last
limit 5;


-- find the top 10 customers who have generated the highest revenue
select
c.customer_key,
c.first_name,c.last_name,
sum(s.sales_amount) total_revenue
from gold.sales s
left join gold.customers c
on s.customer_key=c.customer_key
group by c.customer_key,c.first_name,c.last_name
order by total_revenue desc
limit 10;

-- top 3 customers with the fewest order placed
select
c.customer_key,
c.first_name,c.last_name,
count(s.order_number) total_order
from gold.sales s
left join gold.customers c
on s.customer_key=c.customer_key
group by c.customer_key,c.first_name,c.last_name
order by total_order asc
limit 3;

--==================================================================================================================================================================
--==================================================================================================================================================================

--### ADVANCE DATA ANALYSIS 

select * from gold.customers;
select * from gold.products;
select * from gold.sales;

--1. CHANGES OVER TIME : Analyze sales performance over time 
select 
extract(year from order_date) Years,
extract(month from order_date) sales_month,
sum(sales_amount) as total_sales,
count(distinct customer_key) as total_customers,
sum(quantity) as total_quantity
from gold.sales
where order_date is not null
group by extract(month from order_date),extract(year from order_date)
order by extract(year from order_date);


--2. CUMULATIVE ANALYSIS :
--calculate the total sales per-month and running total of sales over time and moving avg price
select 
order_date,
total_sales,
sum(total_sales) over (order by order_date) as running_total_sales,
round(avg(avg_price) over (order by order_date),2) as moving_average_price
from (
     select 
	 extract (year from order_date) as order_year,
	 sum(sales_amount) as total_sales,
	 avg(price) as avg_price
	 from gold.sales
	 where order_date is not null 
	 group by extract (year from order_date)t;

--3. PERFORMANCE ANALYSIS :
--QTS:Analyze the early performance of products by comparing each products sales  to both 
--  its avg sales performance and the privious years sales

WITH yearly_product_sales as(
	select
	extract(year from s.order_date) as order_year,
	p.product_name,
	sum(s.sales_amount) as current_sales
	from gold.sales s 
	left join gold.products p on s.product_key = p.product_key 
	where s.order_date is not null
	group by extract(year from s.order_date),p.product_name
)
select 
order_year,
product_name,
current_sales,
round(avg(current_sales) over(partition by product_name),0) as avg_sales,
current_sales - round(avg(current_sales) over(partition by product_name),0) as diff_avg,
Case when current_sales - round(avg(current_sales) over(partition by product_name),0) > 0 then 'Above AVG'
     WHEN current_sales - round(avg(current_sales) over(partition by product_name),0) < 0 then 'Below AVG'
	 else 'AVG' END as avg_change,
LAG(current_sales) over(partition by product_name order by order_year) as PY_sales,
current_sales - LAG(current_sales) over(partition by product_name order by order_year) as diff_PY, -- YOY ANALYSIS 
Case when current_sales - LAG(current_sales) over(partition by product_name order by order_year) > 0 then 'Increase'
     WHEN current_sales - LAG(current_sales) over(partition by product_name order by order_year) < 0 then 'Decrease'
	 else 'No Change' END as PY_change
from yearly_product_sales
order by product_name , order_year;


--4. PROPORTIONAL ANALYSIS : which categories contributes the most  to overall sales 
with category_sales as(
	select 
	p.category,
	sum(s.sales_amount) as cat_total_sales
	from gold.sales s
	left join gold.products p 
	on s.product_key = p.product_key
	group by p.category
)
select 
category,
cat_total_sales,
sum(cat_total_sales) over() as total_sales,
CONCAT(ROUND((cat_total_sales / sum(cat_total_sales) over())*100,2),'%') as Category_Contribution
from category_sales;

--5. DATA SEGMENTATION : segment products into cost ranges and count how many products fall into each segment 
WITH product_segment  as (
	select 
	product_key,
	product_name,
	cost,
	CASE  when cost < 100 then 'Below 100'
		  when cost between 100 and 500  then '100-500'
		  when cost between 500 and 1000 then '500-1000'
		  else 'Above 1000'
		  end as cost_range
	from gold.products
)
select 
cost_range,
count(product_key) as total_products
from product_segment
group by cost_range
order by total_products desc;

--6. Customer Segmentation / Behavioral Analysis :
--  QTS:Group customers into three segments based on their spending behaviour
--   VIP : AT least 12 months history and spending more than 5000$
--   REGULAR : at least 12 month of history but spending 5000$ or less
--   NEW : lifespan less than 12 month     
--   total number of customer by each groups 
WITH customer_spending as(
	select 
	c.customer_key,
	sum(s.sales_amount) as total_spending,
	min(order_date) as first_order,
	max(order_date) as last_order,
	(extract(year from age(max(order_date), MIN(order_date))) * 12 +
         extract(month from age(max(order_date), MIN(order_date)))) AS lifespan
	from gold.sales s
	left join gold.customers c
	on s.customer_key=c.customer_key
	group by c.customer_key
	order by lifespan desc
)
select 
customer_segment,
count(customer_key) as total_customers
from(
	select 
	customer_key,
	total_spending,
	lifespan,
	case when lifespan >=12 and total_spending > 5000 then 'VIP'
	     when lifespan >=12 and total_spending <=5000 then 'REGULAR'
		 else 'NEW'
		 END as customer_segment
	from customer_spending) t
group by customer_segment;



/*
------------------------------------------------------------------------------------------------------------------------------------------
Customer Report
------------------------------------------------------------------------------------------------------------------------------------------
Purpose : this report consolidates key customer metrics and behaviours.

Highlights:
1. Gather essential fields such as names,ages,and transaction details.
2. Segments customers into categories(VIP,Regular,New) and age groups.
3. Aggregates customers-Level metrics:
   - total orders
   - total sales
   - total quantity purchased
   - total products 
   - lifespan (in months)

4. Calculate valuable KPIs:
   - recency(months since last order)
   - average order value
   - average monthly spends
------------------------------------------------------------------------------------------------------------------------------------------
*/

-- Retrive core  columns from table 

CREATE VIEW gold.customer_report as
with base_query as( --Gather essential fields such as names,ages,and transaction details.
select
s.order_number,
s.product_key,
s.order_date,
s.sales_amount,
s.quantity,
c.customer_key,
c.customer_number,
CONCAT(c.first_name,' ',c.last_name) as customer_name,
extract(year from age(c.birthdate)) as age
from gold.sales s
left join gold.customers c 
on s.customer_key=c.customer_key
where s.order_date is not null
),
customer_aggregation as(  --  Aggregates customers-Level metrics:
select 
customer_key,
customer_number,
customer_name,
age,
count(distinct order_number) as total_orders,
sum(sales_amount) as total_sales,
max(order_date) as last_order_date,
(extract(year from age(max(order_date), MIN(order_date))) * 12 +
         extract(month from age(max(order_date), MIN(order_date)))) AS lifespan
from base_query
group by customer_key,customer_number,customer_name,age
)
select              --2. Segments customers into categories(VIP,Regular,New) and age groups.
customer_key,
customer_number,
customer_name,
age,
case when age < 20 then 'Under 20'
     when age between 20 and 29 then '20-29'
	 when age between 30 and 39 then '30-39'
	 when age between 40 and 49 then '40-49'
	 else '50 and Above'
end as age_group,
case when lifespan >=12 and total_sales > 5000 then 'VIP'
	 when lifespan >=12 and total_sales <=5000 then 'REGULAR'
     else 'NEW'
END as customer_segment,
last_order_date,
extract(year from age(current_date,last_order_date))*12 +
       extract (month from age (current_date,last_order_date)) as Recency ,
total_orders,
total_sales,
lifespan,
case when total_orders = 0 then 0 -- avg_order_value
else total_sales/total_orders end as avg_order_value,
case when lifespan =0 then total_sales
else round(total_sales / lifespan,1) end as avg_monthly_sales
from customer_aggregation;

select * from gold.

/*
===================================================================================
Product Report
===================================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
        - total orders
        - total sales
        - total quantity sold
        - total customers (unique)
        - lifespan (in months)
    4. Calculates valuable KPIs:
        - recency (months since last sale)
        - average order revenue (AOR)
        - average monthly revenue
===================================================================================
*/ 
CREATE VIEW gold.product_report as 
with product_base_query as (
select     --Gathers essential fields such as product name, category, subcategory, and cost.
p.product_key,
p.product_id,
p.product_name,
p.category,
p.subcategory,
p.cost,
s.order_number,
s.customer_key,
s.order_date,
s.sales_amount,
s.quantity
from gold.products p
left join 
gold.sales s
on p.product_key=s.product_key
where s.order_date is not null
),
products_aggregation as(   --Aggregates product-level metrics:  
select 
product_key,
product_id,
product_name,
category,
subcategory,
count(order_number) as total_orders,
sum(sales_amount) as total_sales,
sum(quantity) as total_quantity,
count(distinct customer_key) as total_customers,
(extract(year from age(max(order_date),min(order_date))) * 12 +
      extract(month from age(max(order_date),min(order_date)))) as lifespan,
max(order_date) as last_order_date
from product_base_query
group by product_key,product_id,product_name,category,subcategory
)
select         -- Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
product_key,
product_id,
product_name,
category,
subcategory,
total_orders,
total_sales,
case when total_sales > 50000  then 'High-Performers'
     when total_sales >= 10000 then 'Mid-Range'
	 else 'Low-Performers'
end as product_segment,
total_quantity,
total_customers,
lifespan,
extract(year from age(current_date,last_order_date))*12 +       -- recency (months since last sale)
       extract (month from age (current_date,last_order_date)) as Recency,
case 
 when total_orders = 0 then 0 --average order revenue (AOR)
else total_sales / total_orders end as average_order_revenue,
case
  when lifespan = 0 then total_sales
else round(total_sales/lifespan,1) end as avg_monthly_revenue
from products_aggregation;

select * from gold.product_report ;
