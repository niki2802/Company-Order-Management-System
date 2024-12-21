
create database orders;
select * from orders_data;

						/*total  sales by region*/
                        
select Region ,round(sum(sale_price)) as sales 
from orders_data
group by Region
order by sales desc;
                           /*top 3 highest reveue generating cites*/
                           
                           
select City,round(sum(sale_price)) as sales 
from orders_data
group by city
order by sales desc
limit 3;
                           /*top 10 highest reveue generating products*/


select  Product_Id,sum(sale_price) as sales 
from orders_data
group by Product_Id
order by sales desc
limit 10;

                             /*top 5 highest selling product in each region*/

with cte as (
select region, product_id, sum(sale_price) as sales
from orders_data
group by region, product_id)
select * from (
select * ,row_number() over (partition by region order by sales desc) as rn 
from cte) A
where rn<=5;

								/* month wise sales comparision for 2022 - 2023 */


select year(Order_Date) as order_year,month(Order_Date) as order_months, round(sum(sale_price))
from orders_data
group by  year(Order_Date),month(Order_Date)
order by  year(Order_Date),month(Order_Date);

                                /* find the each category which months had highest sales*/

with cte as (
select category, format (order_Date, 'yyyyMM') as order_year_month,
sum(sale_price) as sales
from orders_data
group by category, format (order_date, 'yyyymm'))
select * from (
select * ,
row_number() over (partition by category order by sales desc) as rn from cte)
a
where rn-1;

							/*sub category had highest growth by profit in 2023 campare to 2022*/
                            
with cte as (
select sub_category, year (order_date) as order_year, 
sum(sale_price) as sales
from orders_data
group by sub_category, year(order_Date)
   )
, cte2 as (
select sub_category 
,sum(case when order_year=2022 then sales else 0 end) as sales_2022 
,sum(case when order_year=2023 then sales else 0 end) as sales_2023
from cte
group by sub_category
)
select  *,
(sales_2023-sales_2022)
from cte2
order by (sales_2023-sales_2022)*100/sales_2022 desc
limit 1;
