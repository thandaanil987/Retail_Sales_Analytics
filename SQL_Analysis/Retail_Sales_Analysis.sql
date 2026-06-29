CREATE DATABASE retail_sales;
USE retail_sales;
DESCRIBE superstore;
show columns from superstore;

--  Data Validation Quries 

-- Total Orders
select count(distinct(order_id))as total_orders from superstore;

-- Total Customers
select count(distinct(customer_id))as total_Customers from superstore;

-- Total Products
select count(distinct(product_name)) as total_products from superstore;

-- Duplicate Customers
select customer_id,count(*) from superstore
group by customer_id
having count(*)>1;

-- Negative Sales
select*from superstore
where sales < 0;

-- Negative Quantity 
select*from superstore
where quantity<0;

-- Discount Greatern than 1
select*from superstore
where discount > 1;


-- Business Analysis Queries 

-- Total Sales
select round(sum(sales),2)as Total_Sales from superstore;

-- Total Profit
select round(sum(profit),2)as Total_Profit from superstore;

-- Total Orders
select count(distinct(order_id))as Total_Orders from superstore;

-- Total Customers
select count(distinct(customer_id))as Total_Customers from superstore;

-- Average order value
select round(sum(sales)/count(distinct(order_id)),2)as AOV from superstore;

-- Average profit 
select round(avg(profit),2)as Average_Profit from superstore;

-- Average Discount
select round(avg(Discount),2)as Average_Discount from superstore;

-- sales by category 
select category,round(sum(sales),2)As Total_Sales from superstore
group by category
order by Total_Sales desc;

-- profit by category 
select category,round(sum(profit),2)as Total_Profit from superstore
group by category
order by Total_Profit desc;

-- Top 10 Customers
select customer_name,round(sum(sales),2)as Customer_Sales from superstore
group by customer_name 
order by Customer_Sales desc
limit 10;

-- Bottom 10 Customers 
select customer_name,round(sum(sales),2)as Customer_Sales from superstore
group by customer_name 
order by Customer_Sales
limit 10;

-- Region wise sales and profit 
select region,round(sum(sales),2)as Total_Sales,
round(sum(profit),2)as Total_Profit 
from superstore
group by region
order by  Total_Sales desc,Total_Profit desc;

-- Show only categories with sales greater than ₹500,000.
select category,round(sum(sales),2)As Total_Sales
from superstore
group by category 
having Total_Sales>50000;

-- Classify each order as Profit or Loss
select order_id,sales,profit,
case 
	when profit < 0 then 'Loss'
    else 'Profit'
end as status 
from superstore;

-- Discount Levels
select discount,
case 
	when discount=0 then 'No Discount'
    when discount<=0.20 then 'Low'
    when discount<=0.50 then 'Medium'
    else 'High'
end as 'discount_level'
from superstore;

-- show orders where sales are greater than the average sales
select order_id,round(sales,2)as sales
from superstore
where sales>(select avg(sales)from superstore);

-- Find products that earned more than the average profit
select product_name,round(profit,2)as profit from superstore
where profit>(select avg(profit)from superstore);

-- Find the top 10 customers by sales.

with customer_sales as
(select customer_name,round(sum(sales),2)as Total_sales 
from superstore
group by customer_name)
select*from customer_sales
order by Total_sales desc
limit 10;

-- Find the bottom 10 customers by sales.
with customer_sales as
(select customer_name,round(sum(sales),2)as Total_sales 
from superstore
group by customer_name)
select*from customer_sales
order by Total_sales 
limit 10;

-- Find the most profitable states
with state_profit as (
select state,round(sum(profit),2)as Total_Profit 
from superstore
group by state)
select*from state_profit
order by Total_Profit desc 
limit 5;

-- customer ranking (Top 10 Rankers)
select customer_name,round(sum(sales),2)as Total_Sales,
rank()over(order by sum(sales)desc)as rnk 
from superstore
group by customer_name
limit 10;

-- Running Total
select order_date,round(sales,2),
round(sum(sales) over(order by order_date),2)as running_total
from superstore;

-- Monthly sales trend
with monthly_sales as(
select year(order_date)as year,monthname(order_date)as month,
round(sum(sales),2)as Total_sales from superstore
group by  year(order_date),monthname(order_date))
select year,month,Total_sales from monthly_sales
order by year,month;

-- Monthly profit trend
with monthly_profit as(
select year(order_date)as year,monthname(order_date)as month,
round(sum(profit),2)as Total_profit from superstore
group by  year(order_date),monthname(order_date))
select year,month,Total_profit from monthly_profit
order by year,month;

-- loss making products
select product_name,
round(sum(profit),2)as Total_Profit from superstore
group by product_name
having Total_Profit < 0 
order by Total_Profit desc;


-- sales summary
create view sales_summary as(
select category,round(SUM(sales),2) total_sales,
round(SUM(profit),2) total_profit from superstore
group by category);

select*from sales_summary;
