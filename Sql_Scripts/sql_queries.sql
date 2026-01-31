
-- 1. Sales Performance by Region
select c.region,sum(s.sales) as total_sales from customer as c join sales as s on c.customer_id=
s.customer_id group by 1 order by 2 desc;


-- 2. Top Selling Products
select p.product_id,p.product_name,sum(s.sales) as total_sales from product as p join
sales as s on p.product_id=s.product_id group by 1,2 order by 3 desc;


-- 3.	Discount Impact on Profit
select discount,avg(profit) as avg_profit,sum(profit) as total_profit,count(*) as order_count
from sales group by 1 order by 1;


-- 4.	 Sales by Customer Segment
select c.segment,sum(s.sales) as total_sales from customer as c join sales as s on c.customer_id=
s.customer_id group by 1 order by 2 desc;


-- 5.	Product Category Sales
select p.category,sum(s.sales) as total_sales from product as p join
sales as s on p.product_id=s.product_id group by 1 order by 2 desc;


-- 6.	Customer Orders by Ship Mode
select ship_mode,count( distinct order_id) as order_count from sales group by ship_mode;


-- 7.	Sales by Date
select extract(month from order_date) as Month,sum(sales) as total_sales from sales group by 1 order by 1;


-- 8.	Customer Distribution by State
select  state,count(distinct customer_id) as total_customer from customer group by 1;


-- 9.Top 5 Customers by Sales
select c.customer_id,c.customer_name,sum(s.sales) as total_sales from customer as c join sales as s on c.customer_id=
s.customer_id group by 1,2 order by 3 desc limit 5;


-- 10.	 Product Performance in Subcategories
select p.sub_category,sum(s.sales) as total_sales from product as p join
sales as s on p.product_id=s.product_id group by 1 order by 2 desc;


-- 11.	Rank Products by Sales
select category,product_id,product_name,total_sales,rank() over (partition by category order by total_sales desc) as sales_rank
from(
select p.category,p.product_id,p.product_name,sum(s.sales) as total_sales from product as p join
sales as s on p.product_id=s.product_id group by 1,2,3) as product_sales order by category,sales_rank;



-- 12.	Cumulative Sales by Date
select p.product_id,p.product_name,s.order_date,s.sales,sum(s.sales) over (partition by p.product_id
order by s.order_id,s.order_date) as cumulative_sales  from product as p join
sales as s on p.product_id=s.product_id order by 1,3,s.order_id;


-- 13.	Find Top 3 Customers by Profit
select region,customer_id,customer_name,total_profit from(
select c.region,c.customer_id,c.customer_name,sum(s.profit) as total_profit,dense_rank() over
( partition by c.region order by  sum(s.profit) desc) as profit_rank from customer as c join 
sales as s on c.customer_id=s.customer_id group by c.region,c.customer_id,c.customer_name) as ranked_customer
where profit_rank<=3  order by region,profit_rank;



-- 14.	Average Sales by Segment with Row Number
select c.segment,c.customer_id,c.customer_name,s.sales,avg(s.sales) over (partition by c.segment) as avg_sales_per_segment,
row_number() over (partition by c.segment order by s.sales desc) as row_num from customer
as c join sales as s on c.customer_id=s.customer_id order by c.segment,row_num;


-- 15.	Difference in Sales Between Consecutive Days
select p.product_id,p.product_name,s.order_date,s.sales,s.sales - lag(s.sales,1,0) over (partition by 
p.product_id  order by order_date) as sales_diff from product as p join sales as s on p.product_id=s.product_id
order by p.product_id,s.order_date;


-- 16.	Find Percent of Total Sales by Region
select c.region,sum(s.sales) as region_sales,round(sum(s.sales)*100.00 /sum(sum(s.sales)) over(),2) as percent_of_total_sales
from customer as c join sales as s on c.customer_id=s.customer_id  group by c.region order by percent_of_total_sales desc;


-- 17.	Calculate Moving Average of Sales
select p.product_id,p.product_name,s.order_date,s.sales,avg(s.sales) over(partition by p.product_id order by s.order_date
rows between 2 preceding and current row) as moving_avg_3_orders from product as p join sales as s on
p.product_id=s.product_id order by p.product_id,s.order_date;


-- 18.	 Find Largest and Smallest Order by Customer
select c.customer_id,c.customer_name,s.order_id,s.order_date,s.sales,max(s.sales) over (partition by c.customer_id)
as max_orders,min(s.sales) over (partition by c.customer_id) as min_orders from customer as c
join sales as s on c.customer_id=s.customer_id order by c.customer_id,s.order_date;


-- 19.	Running Total of Profit by Customer
SELECT c.customer_id, c.customer_name, s.order_date, s.profit,
SUM(s.profit) OVER ( PARTITION BY c.customer_id ORDER BY s.order_date, s.order_id
Rows beyween unbounded preceding and current row) AS running_total_profit FROM customer AS c
JOIN sales AS s ON c.customer_id = s.customer_id
ORDER BY c.customer_id, s.order_date, s.order_id;


-- 20.	Calculate Dense Rank of Sales by Ship Mode
select ship_mode,order_id,total_sales,dense_rank() over (partition by ship_mode order by total_sales desc) as sales_rank
from(
select ship_mode,order_id,sum(sales) as total_sales from sales group by 1,2) as t order by ship_mode,sales_rank;

