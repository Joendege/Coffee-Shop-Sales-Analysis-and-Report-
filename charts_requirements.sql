-- Calender heatmap
select 
	dayofmonth(transaction_date) day,
	concat(round((sum(transaction_qty * unit_price)/1000), 1), 'K') total_sales,
    concat(round((sum(transaction_qty)/1000), 1), 'K') total_qty,
    concat(round((count(transaction_id)/1000), 2), 'K') total_orders
from coffee_sales
where month(transaction_date) = 3
group by dayofmonth(transaction_date)
order by dayofmonth(transaction_date);

-- Sales Analysis by weekdays & weekends

select 
	case
		when dayofweek(transaction_date) in(1, 7) then 'Weekends'
        else 'Weekdays'
	end as day_type,
	concat('$',round((sum(transaction_qty * unit_price) / 1000), 1),' K') total_sales
from coffee_sales
where month(transaction_date) = 2
group by
	case
		when dayofweek(transaction_date) in(1, 7) then 'Weekends'
        else 'Weekdays'
	end;
    
-- Store sales analysis
select 
	store_location,
    concat('$', round((sum(transaction_qty * unit_price) / 1000), 2), 'K') total_sales
from coffee_sales
where month(transaction_date) = 2
group by  store_location
order by total_sales desc;

-- Daily sales analysis
select 
	dayofmonth(transaction_date) day_month,
    concat(round((sum(transaction_qty * unit_price) / 1000), 1), 'K') totals_sales,
    concat(round(avg(sum(transaction_qty * unit_price) / 1000) over(), 1), 'K') as avg_sales
from coffee_sales
where month(transaction_date) = 5
group by dayofmonth(transaction_date);

-- Comparision daily sales
select 
	a.*,
    case
		when a.total_sales > a.avg_sales then 'Above Average'
        when a.total_sales < a.avg_sales then 'Below Average'
        else 'Average'
	end as sales_status
from
	(select 
		dayofmonth(transaction_date) day_month,
		concat(round((sum(transaction_qty * unit_price) / 1000), 1), 'K') total_sales,
		concat(round(avg(sum(transaction_qty * unit_price) / 1000) over(), 1), 'K') as avg_sales
	from coffee_sales
	where month(transaction_date) = 4
	group by dayofmonth(transaction_date)) a;


-- Sales by Category
select 
	product_category,
    round(sum(transaction_qty * unit_price))  total_sales
from coffee_sales
where month(transaction_date) = 5 
group by product_category
order by total_sales desc;

-- Sales by Product Type

select 
	product_type,
    round(sum(transaction_qty * unit_price)) total_sales
from coffee_sales
where month(transaction_date) = 5 and product_category = 'Coffee'
group by product_type
order by  total_sales desc
limit 10;


select 
	hour(transaction_time) hour, 
    concat(round(sum(transaction_qty * unit_price) / 1000, 2), 'K') total_sales,
    sum(transaction_qty) total_qty,
    count(transaction_id) total_orders
from coffee_sales
where month(transaction_date) = 5 and dayofweek(transaction_date) = 1
group by hour(transaction_time)
order by hour(transaction_time);

-- Total Sales by hours
select 
	hour(transaction_time) hour,
    round(sum(transaction_qty * unit_price)) total_sales
from coffee_sales
where month(transaction_date) = 5
group by hour(transaction_time)
order by hour(transaction_time);

-- Total sales by day of week
select 
	a.day_name,
    total_sales
from
	(select 
		dayofweek(transaction_date) day_week,
		dayname(transaction_date) day_name,
		round(sum(transaction_qty * unit_price)) total_sales
	from coffee_sales
	where month(transaction_date) = 5
	group by dayofweek(transaction_date), dayname(transaction_date)
	order by day_week) a 



















