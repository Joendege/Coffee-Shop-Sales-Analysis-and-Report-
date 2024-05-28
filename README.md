# Coffee Shop Sales Analysis 

## Table of Contents

- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Tools](#tools)
- [Data Cleaning and Preparation](#data-cleaning-and-preparation)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Data Analysis](#data-analysis)
- [Recommedations](#recommedations)
- [Results and Findings](#results-and-findings)
- [References](#references)


### Project Overview
This data analysis project aim to provide insights into sales performance of a coffee outlet for a period of six months. Through analysis of this coffee sales data I seek to indentfy the sales trend over the six months,  different weeks, days of the week and hours. Also we seek to compare orders and quantity sold over the six months, different weeks, days of the week and also hours. Finally, I will make data driven recommedations based on the results and findings from the analysis and reports created while gaining a deeper understanding on the coffee sales outlets.

![coffee_sales](https://github.com/Joendege/Coffee-Shop-Sales-Analysis-and-Report-/assets/123901910/8a0611a8-3dee-4312-beaf-85a59e134414)


### Data Sources
Coffee Sales Data: The primary data source for this analysis is "Coffee Shop Sales.csv" file containing a detailed sale made in the selected coffee outlet.

### Tools
- My SQL - Data Cleaning, Data Analysis [Download Here](https://dev.mysql.com/downloads/workbench/)
- Power BI - Report Creating [Download Here](https://www.microsoft.com)

### Data Cleaning and Preparation
In the initial data preparation phase I performed the following tasks:
1. Data loading and Inspection
2. Data Cleaning and Formatting

### Exploratory Data Analysis
EDA involved exploring the sales data to answer key questions, such as:
1. What is the monthly total sales, orders and quantity sold? What is the month by month increase or decrease of sales, orders and quantity sold?
2. How is the performance of each day of the month in terms of sales, orders and quantity sold?
3. How is the sales comparison on weekdays and weekends?
4. How are the sales based on product categories? What are the top ten products in each category based on sales?
5. How is the sales based on hours and days of the week?


### Data Analysis
``` SQL
-- MoM sales

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
```
``` SQL
-- Daily Sales Analysis
select 
	dayofmonth(transaction_date) day,
	concat(round((sum(transaction_qty * unit_price)/1000), 1), 'K') total_sales,
    concat(round((sum(transaction_qty)/1000), 1), 'K') total_qty,
    concat(round((count(transaction_id)/1000), 2), 'K') total_orders
from coffee_sales
where month(transaction_date) = 3
group by dayofmonth(transaction_date)
order by dayofmonth(transaction_date);
```
``` SQL
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
```
``` SQL   
-- Store sales analysis
select 
	store_location,
    concat('$', round((sum(transaction_qty * unit_price) / 1000), 2), 'K') total_sales
from coffee_sales
where month(transaction_date) = 2
group by  store_location
order by total_sales desc;
```

``` SQL
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
```

``` SQL
-- Sales by Category
select 
	product_category,
    round(sum(transaction_qty * unit_price))  total_sales
from coffee_sales
where month(transaction_date) = 5 
group by product_category
order by total_sales desc;
```
``` SQL
-- Sales by Product Type

select 
	product_type,
    round(sum(transaction_qty * unit_price)) total_sales
from coffee_sales
where month(transaction_date) = 5 and product_category = 'Coffee'
group by product_type
order by  total_sales desc
limit 10;
```
``` SQL
select 
	hour(transaction_time) hour, 
    concat(round(sum(transaction_qty * unit_price) / 1000, 2), 'K') total_sales,
    sum(transaction_qty) total_qty,
    count(transaction_id) total_orders
from coffee_sales
where month(transaction_date) = 5 and dayofweek(transaction_date) = 1
group by hour(transaction_time)
order by hour(transaction_time);
```
``` SQL

-- Total Sales by hours
select 
	hour(transaction_time) hour,
    round(sum(transaction_qty * unit_price)) total_sales
from coffee_sales
where month(transaction_date) = 5
group by hour(transaction_time)
order by hour(transaction_time);
```
``` SQL

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
```

### Recommedations
Based on the analysis, we recommed the following actions:
1. Channel more resources and marketing to prduct categories that are high performing
2. Segment the market to ensure the products utilised by a given market group is available and market the prouct to the specific group
3. Increase coffee brands as its evident to be the best performing product category
4. Channel more resources to peak hours to ensure maximum sales

### Results and findings
The analysis results are summarized as follows:
1. Most sales and orders are made between 8 a.m and 10 pm and mostly on weekdays
2. The month February has decline in sales, orders and quantity due to the less number of days
3. There is a significant increase in sales month by month
4. Hell's Kitchen is the best performing store overoll.


### References
1. [Stack Overflow](https://stackoverflow.com/questions)
2. [My SQL Documentation](https://dev.mysql.com/doc/)
3. [Power BI Documentation](https://learn.microsoft.com/en-us/power-bi/)

























