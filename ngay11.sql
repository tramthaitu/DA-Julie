--bài1
select b.continent,
floor(avg(a.population)) 
from CITY as a
Join Country as b
on a.Countrycode=b.code
group by b.continent
--bai2
select round(1.0*SUM(case when b.signup_action='Confirmed' then 1 else 0 end)/count(b.signup_action),2) as confirm_rate
from emails as a
left JOIN texts as b
on a.email_id=b.email_id
where b.email_id is not null 
--bài3
SELECT age_bucket,
round((100*sum(case when activity_type='send' then  time_spent else 0 end)/
(sum(case when activity_type='send' then  time_spent else 0 end)+ 
sum(case when activity_type='open' then  time_spent else 0 end))),2)as send_perc,
  
round((100*sum(case when activity_type='open' then  time_spent else 0 end)/
(sum(case when activity_type='send' then  time_spent else 0 end)+ 
sum(case when activity_type='open' then  time_spent else 0 end))),2)as open_perc
  
from activities as a 
join age_breakdown as b 
on a.user_id=b.user_id
group by age_bucket
--bài4
SELECT a.customer_id
FROM customer_contracts as a 
left join products as b 
on a.product_id=b.product_id
GROUP BY a.customer_id
HAVING COUNT(DISTINCT b.product_category)=3
-- bai5
select  a.reports_to as employee_id, b.name,
count(a.reports_to) as reports_count,
Round(avg(a.age),0) as average_age 
from Employees as a
join Employees as b
on a.reports_to=b.employee_id
group by a.reports_to
order by a.reports_to
--bai6
select  a.product_name,
sum(b.unit) as unit
from Products as a
join Orders as b
on a.product_id=b.product_id 
where extract(month from b.order_date)=2 and extract(year from b.order_date)=2020
group by a.product_id
having sum(b.unit) >=100
--bai7
SELECT a.page_id
FROM pages as a 
LEFT JOIN page_likes as b 
on a.page_id=b.page_id
where b.liked_date is null 
group by a.page_id



