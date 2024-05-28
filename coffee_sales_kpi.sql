select * from coffee_sales;

-- Converting transaction_date and transaction_time to right formats

update coffee_sales
set transaction_date= str_to_date(transaction_date, '%m/%d/%Y');

alter table coffee_sales
modify column transaction_date date;

update coffee_sales
set transaction_time= str_to_date(transaction_time, '%H:%i:%s');

alter table coffee_sales
modify column transaction_time time;

describe coffee_sales;


-- Renaming a column

select * from coffee_sales;

alter table coffee_sales
change column ï»¿transaction_id transaction_id int;

select 
	sum(cast((transaction_qty * unit_price) as decimal(7,2))) total_sales
from coffee_sales;

-- Total monthly sales 
select 
	a.month,
    a.total_sales
from
	(select 
		month(transaction_date) month_no,
		monthname(transaction_date) month,
		sum(cast((transaction_qty * unit_price) as decimal(7,2))) total_sales
	from coffee_sales
	group by monthname(transaction_date), month(transaction_date) 
	order by month(transaction_date)) a;

-- MoM sales

select 
	month(transaction_date) month_no,
    sum(cast((transaction_qty * unit_price) as decimal(7,2))) total_sales,
    cast((sum(transaction_qty * unit_price) - lag(sum(transaction_qty * unit_price), 1) over(order by month(transaction_date))) /
    lag(sum(transaction_qty * unit_price), 1) over(order by month(transaction_date)) * 100 as decimal(5, 2)) as MoM_increase_percentage
from coffee_sales
group by month(transaction_date)
order by month(transaction_date);


select
	a.month_name,
    a.total_sales,
    a.sales_diff,
    a.MoM_percentage_increase
from
	(select 
		month(transaction_date) month_no,
		monthname(transaction_date) month_name,
		sum(cast((transaction_qty * unit_price) as decimal(7,2))) total_sales,
		lag(sum(cast((transaction_qty * unit_price) as decimal(7,2))), 1) over(order by month(transaction_date)) pm_sales,
		sum(cast((transaction_qty * unit_price) as decimal(7,2))) - lag(sum(cast((transaction_qty * unit_price) as decimal(7,2))), 1) over(order by month(transaction_date)) sales_diff,
		cast((sum(cast((transaction_qty * unit_price) as decimal(7,2))) - lag(sum(cast((transaction_qty * unit_price) as decimal(7,2))), 1) over(order by month(transaction_date))) / lag(sum(cast((transaction_qty * unit_price) as decimal(7,2))), 1) over(order by month(transaction_date)) * 100 as decimal(5,2)) as MoM_percentage_increase
	from coffee_sales
	group by monthname(transaction_date), month(transaction_date)
	order by month(transaction_date)) a;
    

select
	a.month_name,
    a.total_sales,
    a.sales_diff,
    a.MoM_percentage_increase
from
	(select
		month(transaction_date) month_no,
		monthname(transaction_date) month_name,
		sum(cast(transaction_qty * unit_price as decimal(7,2))) total_sales,
		lead(sum(cast(transaction_qty * unit_price as decimal(7,2))), 1) over(order by month(transaction_date)) next_month_sales,
		lead(sum(cast(transaction_qty * unit_price as decimal(7,2))), 1) over(order by month(transaction_date)) - sum(cast(transaction_qty * unit_price as decimal(7,2))) sales_diff,
		cast((lead(sum(cast(transaction_qty * unit_price as decimal(7,2))), 1) over(order by month(transaction_date)) - sum(cast(transaction_qty * unit_price as decimal(7,2)))) / sum(cast(transaction_qty * unit_price as decimal(7,2))) * 100 as decimal(5,2)) MoM_percentage_increase
	from coffee_sales
	group by month(transaction_date), monthname(transaction_date)
	order by month(transaction_date)) a
where a.month_no in(4,5);


-- Total Orders
select
	a.month_name,
    a.total_orders
from
	(select 
		month(transaction_date) month_no,
		monthname(transaction_date) month_name,
		count(transaction_id) total_orders
	from coffee_sales
	group by month(transaction_date), monthname(transaction_date)
	order by month(transaction_date)) a;
    
select
	a.month_name,
    a.total_orders,
    a.orders_diff,
    a.MoM_percentage_increase
from
	(select 
		month(transaction_date) month_no,
		monthname(transaction_date) month_name,
		count(transaction_id) total_orders,
		lag(count(transaction_id), 1) over(order by month(transaction_date)) pm_orders,
		count(transaction_id) - lag(count(transaction_id), 1) over(order by month(transaction_date)) orders_diff,
		cast((count(transaction_id) - lag(count(transaction_id), 1) over(order by month(transaction_date))) / lag(count(transaction_id), 1) over(order by month(transaction_date)) * 100 as decimal(5,2)) MoM_percentage_increase
	from coffee_sales
	group by month(transaction_date), monthname(transaction_date)) a;

-- Total Quantity
select
	a.month_name,
    a.total_qty
from
	(select 
		month(transaction_date) month_no,
		monthname(transaction_date) month_name,
		sum(transaction_qty) total_qty
	from coffee_sales
	group by month(transaction_date), monthname(transaction_date)
	order by month(transaction_date)) a;

select 
	a.month_name,
    a.total_qty,
    a.qty_diff,
    a.MoM_percentage_increase
from
	(select 
		month(transaction_date) month_no,
		monthname(transaction_date) month_name,
		sum(transaction_qty) total_qty,
		sum(transaction_qty) - lag(sum(transaction_qty), 1) over(order by month(transaction_date)) qty_diff,
		cast((sum(transaction_qty) - lag(sum(transaction_qty), 1) over(order by month(transaction_date))) / lag(sum(transaction_qty), 1) over(order by month(transaction_date)) * 100 as decimal(5,2)) MoM_percentage_increase
	from coffee_sales
	group by month(transaction_date), monthname(transaction_date)
	order by month(transaction_date)) a
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    