---bai1 
select name
from STUDENTS
where Marks >75 
order by right(name,3), ID ASC
--- bai2 
select user_id,
concat(upper(left(name,1)),  --Viết hoa chữ cái đầu tiên
lower(substring(name from 2 for length(name)))) as name --viết thường từ ký tự thứ 2
from Users
order by user_id
-- bài3
SELECT manufacturer,
concat('$',ROUND(SUM(total_sales)/1000000,0),' ','million')
FROM pharmacy_sales
group by manufacturer 
order by SUM(total_sales)  DESC,manufacturer
-- bài4
SELECT 
EXTRACT(month from submit_date) as mth,
product_id,
round(avg(stars),2) as avg_stars
FROM reviews
GROUP BY EXTRACT(month from submit_date),product_id
order by EXTRACT(month from submit_date), product_id 
--bài5
SELECT sender_id,
count(message_id) as message_count
FROM messages
where EXTRACT(month FROM sent_date)=8 and EXTRACT(year from sent_date)=2022
GROUP BY (sender_id)
order by message_count DESC
limit 2
--bài6
select tweet_id
from Tweets
where length(content) >15
-- bài7
select activity_date as day,
count(distinct(user_id )) as active_users 
from Activity
WHERE activity_date BETWEEN '2019-06-28' AND  '2019-07-27'
group by activity_date
--bài8
select 
count(id) as mumber of employees
from employees
where extract(month from joining_date) between 1 and 7 
and extract(year from joining_date) =2022
--bài9
select 
position('a'in frist_name) as position
from worker 
where first_name='Amitah'
--bài10
select 
substring(title, from length(winery) +2 for 4 )
from winemag_p2
where country='Macedonia'
