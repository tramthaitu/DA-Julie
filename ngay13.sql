--bài1
with cte as(
SELECT DISTINCT(company_id), count(job_id) 
FROM job_listings
group by company_id
HAVING count(job_id) >1 
)
select count(*) as duplicate_companies
from cte 
--bài2
with cte as(
SELECT category,product,
sum(spend) as total_spend,
RANK() OVER(PARTITION BY category ORDER BY SUM(spend) DESC) as ranking
FROM product_spend
where EXTRACT(year from transaction_date )='2022'
group by category,product
)

SELECT category, product,total_spend
from cte 
where ranking <=2
order by category, ranking
---bài3
WITH cte AS (
  SELECT policy_holder_id,
  COUNT(case_id) AS so_lan
  FROM callers
  GROUP BY policy_holder_id
  HAVING COUNT(case_id) >= 3
)
SELECT
  COUNT(policy_holder_id) AS member_count
FROM cte
--bai4
SELECT DISTINCT page_id
FROM pages
WHERE page_id NOT IN (
  SELECT page_id
  FROM page_likes
)
ORDER BY page_id ASC;
--bài5
with cte as 
(SELECT  user_id	
from user_actions 
where EXTRACT(month from event_date) in (6,7) 
and EXTRACT(year from event_date) = 2022 
GROUP BY user_id 
having count(DISTINCT EXTRACT(month from event_date)) = 2)

SELECT 7 as month_ , count(*) as number_of_user 
from cte 
--bài6
Select DATE_FORMAT(trans_date, '%Y-%m') as month, country,
COUNT(id) as trans_count,
SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) as approved_count,
SUM(amount) as trans_total_amount,
SUM(CASE WHEN state ='approved' THEN amount ELSE 0 END) as approved_total_amount
FROM Transactions
Group By month, country;
---bài7
select a.product_id, min(a.year) as first_year,a.quantity,a.price 
from Sales as a
group by a.product_id
--bài8
WITH cte AS (
    SELECT
    a.product_id,
    MIN(a.year) AS first_year
    FROM Sales a
    GROUP BY a.product_id
)
SELECT
    b.product_id,
    b.first_year,
    a.quantity,
    a.price
FROM cte as b
join sales as a on a.product_id=b.product_id and a.year=b.first_year
ORDER BY b.product_id;
---bai9
select employee_id 
from Employees
where salary <30000 
and manager_id not in (select employee_id from Employees)
order by employee_id  asc
--bai10
with cte as(
SELECT DISTINCT(company_id), count(job_id) 
FROM job_listings
group by company_id
HAVING count(job_id) >1 
)
select count(*) as duplicate_companies
from cte 
--bai11
  (
    select name as results
    from MovieRating 
    join Users 
    using( User_id )
    group by  User_id
    order by count(*) desc, name
    limit 1
)Union all
(
    select title  as results
    from MovieRating 
    join Movies
    using( movie_id )
    where year(created_at)=2020 and month(created_at)=2
    group by  movie_id
    order by avg(rating) desc, title 
    limit 1
)
--bài12
with cte as
(select requester_id as id from RequestAccepted
union all
select accepter_id as id from RequestAccepted)

select id, count(id) as num
from cte
group by id
order by num desc
limit 1


