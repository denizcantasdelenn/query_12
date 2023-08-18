--find total sales by year for each product_id.

create table sales (
product_id int,
period_start date,
period_end date,
average_daily_sales int
);

insert into sales values(1,'2019-01-25','2019-02-28',100),(2,'2018-12-01','2020-01-01',10),(3,'2019-12-01','2020-01-31',1);


--select * from sales


with cte as (
select min(period_start) as all_dates, max(period_end) as end_date from sales
union all
select dateadd(day, 1, all_dates) as start_date, end_date
from cte
where all_dates < end_date
)
, combined as (
select *
from sales s
inner join cte c on c.all_dates between s.period_start and s.period_end)
, extract_years as (
select product_id, year(all_dates) as years, average_daily_sales
from combined)

select product_id, years, sum(average_daily_sales) as year_base_sales
from extract_years
group by product_id, years
order by product_id, years

option(maxrecursion 1000)



