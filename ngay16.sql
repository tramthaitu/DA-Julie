--bai1
with cte as(
  select *, 
  rank() over(partition by customer_id order by order_date ) as rank1
  from Delivery
)
select 
round(avg(case
when order_date= customer_pref_delivery_date then 1.0 else 0.0 end) 
*100,2) as immediate_percentage
from cte 
where rank1=1
--bai2
with cte as
(select  player_id , min( event_date) as first
from Activity
group by  player_id) 

select 
round(count(a.player_id )/
(select count(distinct b.player_id) from Activity as b ),2) as fraction
from Activity a join cte  
using (player_id)  
where datediff(a.event_date,cte.first)=1
--datediff chênh lệch giữa 2 móc thời gian 
--bai3
select 
case 
  when mod(id,2)=0 then  id -1
  when mod(id,2)!=0 and id=(select count(*) from Seat) then id 
  else id+1 
  end as id,
student
from Seat
order by id
--bài4
with sum as(
    select visited_on,
    sum(amount) as amount
    from Customer 
    group by visited_on
)
select a.visited_on,
   round(sum(b.amount),2) as amount,
    round(avg(b.amount),2) as average_amount
    from sum a, sum b
    where datediff(a.visited_on, b.visited_on) between 0 and 6
    group by a.visited_on
    having count(*) >6 
    order by a.visited_on 
--bai5
with cte as (
    select tiv_2016,
    count(*) over(partition by tiv_2015) as count_same_tiv_2015,
    count(*) over(partition by lat,lon) as count_city
    from Insurance
)
select round(sum(tiv_2016),2) as tiv_2016
from cte 
where count_same_tiv_2015 >1 and count_city=1
---bai6
with cte as(
  select name, salary, departmentId,
  DENSE_RANK() OVER(partition by  departmentId order by salary desc ) rank1
  from Employee 
) 
select b.name as Department, c.name as Employee, c.salary as Salary
from Department b
join cte c
on c.departmentId=b. id
where c.rank1 <=3
--bai7
with cte as(
    select *,
    sum(weight) over(order by turn asc) as totalweight
    from Queue
)
select person_name
from cte 
where totalweight <=1000
order by totalweight desc
limit 1
--bai8
with cte as (
select product_id,new_price,
rank() over(partition by product_id  order by change_date desc ) as rank1
from Products
where change_date <='2019-08-16' 
)
select product_id,new_price as price 
from cte 
where rank1=1
 
 union
select product_id, 10 as price
from Products
where product_id not in (select product_id from cte)

















