--bài 1
SELECT 
sum(CASE
  when device_type='laptop' then 1 else 0
  end) as laptop_views,
sum(CASE
  when device_type in ('tablet','phone') then 1 else 0
  end) as mobile_view
FROM viewership
--bài2
select x,y,z,
 case
    WHEN x + y > z 
    and x + z > y 
    and  y + z > x then 'Yes'
   else 'No'
   end as triangle 
from Triangle
--bài3
SELECT 
ROUND(1.0*SUM(CASE
when call_category is null or call_category ='n/a' then 1 else 0
end)/count(*)*100,1) as call_percentage
FROM callers
---bài4
select name
from Customer
where referee_id != 2 or referee_id is null
---bài5
select survived,
sum(case 
    when pclass = 1 then 1 else 0 
    end) as  first_class,
sum(case 
    when pclass = 2 then 1 else 0 
    end) as  second_classs,
sum(case 
    when pclass = 3 then 1 else 0 
    end) as third_class
from titanic
group by survived
