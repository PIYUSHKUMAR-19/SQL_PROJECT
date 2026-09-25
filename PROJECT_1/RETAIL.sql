#SQL RETAIL ANALYSIS

#Creating retail database
CREATE DATABASE RETAIL;

#Taking access to retail database
USE RETAIL;

#imported table 


#---------DATA--CLEANING----------#




#having a look to the table
SELECT * FROM retail_table;

#having a look to the table till first 100 record
SELECT * FROM retail_table
Limit 100;

#counting number of record for checking count of missing record
select count(*) from retail_table;


#checking for transactions_id=432 because its age column was null thatswhy its is not imported 
select * from retail_table
where transactions_id=432;

#checking for duplicate record
SELECT transactions_id, COUNT(*) AS occurrence
FROM retail_table
GROUP BY transactions_id
HAVING COUNT(*) > 1;

#
select * from retail_table
where transactions_id = null;



select * from retail_table
where sale_date = null;

 
 select * from retail_table
where sale_time = null;



select * from retail_table
where customer_id = null;



select * from retail_table
where gender = null;


select * from retail_table
where age= null;


#checking for record with missing column value 
select * from retail_table
where
transactions_id = null
or
sale_date = null
or
sale_time = null
or 
customer_id = null
or 
age= null
or 
category =null
or 
quantity=null
or 
price_per_unit=null
or 
cogs=null
or 
total_sale=null;



#------------------EXPLORATORY DATA ANALYSIS------------------------#



#count of transactio=1987
SELECT count(distinct transactions_id) from retail_table;

#count of days=644
select count(distinct sale_date) from retail_table;


 

#max sale month="December"
SELECT
    MONTHNAME(sale_date) AS month,
    SUM(total_sale) AS total_sales
FROM retail_table
GROUP BY MONTH(sale_date), MONTHNAME(sale_date)
ORDER BY total_sales DESC;

#MIN sale month=FEB
SELECT
    MONTHNAME(sale_date) AS month,
    SUM(total_sale) AS total_sales
FROM retail_table
GROUP BY MONTH(sale_date), MONTHNAME(sale_date)
ORDER BY total_sales ASC;


#average monthly sale=Rs.75685.833
SELECT ROUND(AVG(monthly_sales),3) AS average_monthly_sales
FROM (
    SELECT
        MONTH(sale_date) AS month,
        SUM(total_sale) AS monthly_sales
    FROM retail_table
    GROUP BY MONTH(sale_date)
) AS monthly_data;





#On which date max took place=2023-11-22 and 2022-12-01
#max_order_count in a day=12
#min_order_countin a day=1;
select sale_date,count(transactions_id) as count_order
from retail_table
group by sale_date
order by count_order desc;


#first half of a month order_count=994
#second half of a month order-count=993
SELECT
    CASE
        WHEN DAY(sale_date) <= 15 THEN 'First Half'
        ELSE 'Second Half'
    END AS month_half,
    COUNT(*) AS transaction_count
FROM retail_table
GROUP BY month_half
ORDER BY transaction_count DESC;


#first half_of_a_day order_count=1439
#second half_of_a_day order-count=548
SELECT
    CASE
        WHEN HOUR(sale_time) < 12 THEN 'First Half'
        ELSE 'Second Half'
    END AS day_half,
    COUNT(*) AS transaction_count
FROM retail_table
GROUP BY day_half
ORDER BY transaction_count DESC;



#year with max sale=2023
select year(sale_date) as year,
sum(total_sale) as net_sale
from retail_table
group by 1
order by 2 desc;

#growth wrt to previous year=+2.13%
WITH yearly_sales AS (
    SELECT
        YEAR(sale_date) AS sales_year,
        SUM(total_sale) AS total_sales
    FROM retail_table
    GROUP BY YEAR(sale_date)
)

SELECT
    sales_year,
    total_sales,
    LAG(total_sales) OVER (ORDER BY sales_year) AS previous_year_sales,

    total_sales - LAG(total_sales) OVER (ORDER BY sales_year)
        AS sales_change,

    ROUND(
        (
            total_sales - LAG(total_sales) OVER (ORDER BY sales_year)
        )
        / LAG(total_sales) OVER (ORDER BY sales_year) * 100,
        2
    ) AS growth_percentage,

    CASE
        WHEN total_sales > LAG(total_sales) OVER (ORDER BY sales_year)
            THEN 'Increase'
        WHEN total_sales < LAG(total_sales) OVER (ORDER BY sales_year)
            THEN 'Decrease'
        ELSE 'No Change'
    END AS growth_status

FROM yearly_sales
ORDER BY sales_year;



#count of distinct customer=155
select count(distinct customer_id) from retail_table;

#max order by a single customer=76
#min order by a single customer=2
select customer_id,count(transactions_id) as count_order
from retail_table
group by customer_id
order by count_order desc;


#min age customer=18
select min(age) from retail_table;

#max age customer=64
select max(age) from retail_table;

#average age=41.351
select round(avg(age),3) from retail_table;


#average female age=41.288
select round(avg(age),3) 
from retail_table
where gender="female";

#average male age=41.411
select round(avg(age),3) 
from retail_table
where gender="male";



#16-32age_group order_count = 588
#32-48age_group order_count = 662
#48-64age_group order_count = 737
SELECT
    CASE
        WHEN age >= 16 AND age < 32 THEN '16-32'
        WHEN age >= 32 AND age < 48 THEN '32-48'
        WHEN age >= 48 AND age <= 64 THEN '48-64'
    END AS age_group,
    COUNT(*) AS order_count
FROM retail_table
WHERE age BETWEEN 16 AND 64
GROUP BY age_group
ORDER BY age_group;



#max ordering gender=female
#count of order by females=1012
SELECT gender, COUNT(*) AS gender_count
FROM retail_table
GROUP BY gender
ORDER BY gender_count DESC
LIMIT 1;

#to find the distinct category
select distinct category from retail_table;

#Clothing	698
#Electronics	678
#Beauty	611
select category, count(transactions_id) as order_count
from retail_table
group by category
order by order_count desc;



 #total quantity sell=4995
 select sum(quantity) from retail_table;
 
#categorywise quantity sell
#Clothing=1780
#Electronics=1682
#Beauty=1533
select category,sum(quantity) as total_quant
from retail_table
group by category
order by total_quant desc;

 
#cheapest things price=RS.25
select min(price_per_unit),category from retail_table
group by category;

#costliest price=Rs.500
select max(price_per_unit) from retail_table
group by category;


#total sale Rs.9,08,230
select sum(total_sale) from retail_table;


#Rs.445120 Male
#Rs.463110 Female
select sum(total_sale),gender 
from retail_table
group by gender;

#customer_id=3 spent Rs.38440
select sum(total_sale) as total_Spent,customer_id
from retail_table
group by customer_id
order by total_Spent desc
limit 1;

#customer_count with more than 30k spent is 3;
SELECT COUNT(*) AS customer_count
FROM (
    SELECT customer_id
    FROM retail_table
    GROUP BY customer_id
    HAVING SUM(total_sale) >= 30000
) AS high_spending_customers;


#customer_count with more than 20k and less than 30spent is 2;
SELECT COUNT(*) AS customer_count
FROM (
    SELECT customer_id
    FROM retail_table
    GROUP BY customer_id
    HAVING SUM(total_sale) < 30000 and sum(total_sale)>= 20000
) AS high_spending_customers;

#customer_count with more than 10k and less than 20spent is 8;
SELECT COUNT(*) AS customer_count
FROM (
    SELECT customer_id
    FROM retail_table
    GROUP BY customer_id
    HAVING SUM(total_sale) < 20000 and sum(total_sale)>= 10000
) AS high_spending_customers;

#categorywise total_sale
#Electronics	Rs.311445
#Clothing	Rs.309995
#Beauty	Rs.286790
#
select category,sum(total_sale)
from retail_table
group by 1
order by 2 desc;


#
with hourly_sale
as
(
select *,
case
    when hour(sale_time) < 12
    then "MORNING"
    when hour(sale_time) between 12 and 17
    then "AFTERNOON"
	else "EVENING"
    end as shift
from retail_table
)
select shift,count(*)
from hourly_sale
group by 1
order by 2 desc;
 
#one transactions max sale=Rs.2000
select * from retail_table
where total_sale=(select max(total_sale) from retail_table);


#one transactions min sale=Rs.25
select * from retail_table
where total_sale=(select min(total_sale) from retail_table);




#avg sale per customer=Rs.5859.548
select round((sum(total_sale)/count(distinct customer_id)),3)as per_cust_sale
from retail_table;


#avg sale per transaction=Rs.457.086
select round((sum(total_sale)/count(transactions_id)),3) as per_cust_sale
from retail_table;


#customer returning 
select customer_id,count(transactions_id) as customer_coming
from retail_table
group by 1
having customer_coming >=2;


#profit generated=Rs.719302.2
SELECT round(SUM(total_sale - cogs),3) AS total_profit
FROM retail_table;


#category_wise_profit
#Clothing	Rs.245945.25
#Electronics	Rs.244767.55
#Beauty	Rs.228589.4
SELECT category,round(SUM(total_sale - cogs),3)
from retail_table
group by 1
order by 2 desc;


#average_profit_per_unit
#138.22	Beauty
#126.43	Clothing
#130.6	Electronics
SELECT
    category,
    ROUND(
        AVG((total_sale - cogs) / quantity),
        2
    ) AS avg_profit_per_unit
FROM retail_table
WHERE quantity IS NOT NULL
  AND total_sale IS NOT NULL
  AND cogs IS NOT NULL
GROUP BY category
ORDER BY avg_profit_per_unit DESC;


select gender,category,round(SUM(total_sale - cogs),3) as profit
from retail_table
group by gender,category
order by profit desc;

#customer _id 3 generted max profit
select customer_id,round(SUM(total_sale - cogs),3) as profit
from retail_table
group by 1
order by 2 desc;




#-----------------------------END OF THIS PROJECT--------------------------#




 















 
 





 
 































 