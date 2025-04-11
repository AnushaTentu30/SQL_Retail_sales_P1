-- SQL Retail Sales Analysis-P1
Create Database SQL_Project_P1;

-- Create Table
Drop table if exists retail_sales;
Create Table retail_sales
			(
				transactions_id INT Primary key,
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
				gender VARCHAR(15),
				age INT,
				category VARCHAR(15),
				quantity INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
			);

Select * from retail_sales;

select count(*) from retail_sales;

-- Data Cleaning
	select * from retail_sales
	where transactions_id is null;

select * from retail_sales
where transactions_id is null
	OR 
	sale_date is null
	OR 
	sale_time is null
	OR 
	customer_id is null
	OR 
	gender is null
	OR 
	category is null
	OR 
	quantity is null
	OR 
	price_per_unit is null
	OR 
	cogs is null
	OR 
	total_sale is null;

delete from retail_sales
where transactions_id is null
	OR 
	sale_date is null
	OR 
	sale_time is null
	OR 
	customer_id is null
	OR 
	gender is null
	OR 
	category is null
	OR 
	quantity is null
	OR 
	price_per_unit is null
	OR 
	cogs is null
	OR 
	total_sale is null;

-- Data Exploration

-- How many sales do we have?
Select count(*) as total_sales from retail_sales;

-- How many unique customers do we have?
Select count(Distinct customer_id) as total_customers from retail_sales;

-- How many unique categories do we have?
Select Distinct category from retail_sales;


--Data Analysis & Business Key Problems & Answers

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate each category's total sales (total_sale).
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale exceeds 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best-selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
	
	select * 
	from retail_sales
	where sale_date = '2022-11-5';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022 
	
	select 
	  *
	FROM retail_sales
	WHERE 
	    category = 'Clothing'
	    AND 
	    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	    AND
	    quantity >= 4

-- Q.3 Write a SQL query to calculate each category's total sales (total_sale).

	select category, 
		    sum(total_sale) as total_sales,
			count(*) as total_orders
	from retail_sales
	group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

	select 
		Round(AVG(age),2) as avg_age
	from retail_sales
	where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale exceeds 1000.

	select *
	from retail_sales
	where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

	select gender,
		   category, 
		   count(transactions_id) as Total_transactions
	from retail_sales
	group by gender, category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

	select 
		year,
		month,
		avg_sales
	from
	(
		select 
			Extract (year from sale_date) as year,
			Extract (month from sale_date) as month,
			avg(total_sale) as avg_sales,
			rank() over(partition by Extract (year from sale_date) order by avg(total_sale) desc) as rank
		from retail_sales
		group by year, month
	) as t1
		where rank=1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
	select 
		customer_id, 
		sum(total_sale) as highest_sales
	from retail_sales
	group by customer_id
	order by highest_sales desc
	limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
	
	select 
		count(distinct customer_id) as Distinct_customers,
		category
	from retail_sales
	group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

with hourly_sale
  as (
	 select 8,
		case
			when extract(hour from sale_time) <12 then 'Morning'
			when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
			else 'evening'
		end as shift
	 from retail_sales
	 )
	 select
	 	shift,
		count(*) as total_orders
	 from hourly_sale
	 group by shift;

-- end of Project
	





