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
------------------------------Mid-course test-----------------------------
---bai1 
/*Task: Tạo danh sách tất cả chi phí thay thế (replacement costs) khác nhau của các film.
Question: Chi phí thay thế thấp nhất là bao nhiêu?*/
select distinct title,replacement_cost
from film
group by replacement_cost,title
order by replacement_cost asc
---bai2
/*Task: Viết một truy vấn cung cấp cái nhìn tổng quan về số lượng phim có chi phí thay thế 
trong các phạm vi chi phí sau
1.low: 9.99 - 19.99
2.medium: 20.00 - 24.99
3.high: 25.00 - 29.99
Question: Có bao nhiêu phim có chi phí thay thế thuộc nhóm “low”?*/ 
select 
sum(case 
	when replacement_cost between 25.00 and 29.99 then 1
	else 0 end) as high,
sum(case 
	when replacement_cost between 20.00 and 24.99 then 1 
	else 0 end) as medium,
sum(case 
	when replacement_cost between 9.99 and 19.99 then 1
	else 0 end) as low
from film
----bai3 
/*Task: Tạo danh sách các film_title  bao gồm tiêu đề (title), độ dài (length) 
và tên danh mục (category_name) được sắp xếp theo độ dài giảm dần. Lọc kết quả
để chỉ các phim trong danh mục 'Drama' hoặc 'Sports'.
Question: Phim dài nhất thuộc thể loại nào và dài bao nhiêu?*/

select a.title, a.length, c.name
from film as a
join public.film_category as  b on a.film_id=b.film_id
join public.category as c on b.category_id=c.category_id
where c.name in ('Drama','Sports')
order by a.length desc

---bài4
/*Task: Đưa ra cái nhìn tổng quan về số lượng phim (tilte) 
trong mỗi danh mục (category).
Question:Thể loại danh mục nào là phổ biến nhất trong số các bộ phim?*/

select b.name,
count(a.film_id) as title
from film_category as a
join public.category as b on a.category_id=b.category_id
group by b.name 
order by count(a.film_id) desc

--bai5
/*Task:Đưa ra cái nhìn tổng quan về họ và tên của các diễn viên 
cũng như số lượng phim họ tham gia.
Question: Diễn viên nào đóng nhiều phim nhất?*/

select a.first_name, a.last_name,
count(b.film_id) as so_luong
from public.actor as a
join public.film_actor as b 
on a.actor_id=b.actor_id
group by a.first_name, a.last_name
order by count(b.film_id) desc

--bai6
/*Task: Tìm các địa chỉ không liên quan đến bất kỳ khách hàng nào.
Question: Có bao nhiêu địa chỉ như vậy?*/

select
count(b.address_id)
from customer as a
right join public.address as b
on a.address_id=b.address_id
where a.address_id is null

--bai7
/*Task: Danh sách các thành phố và doanh thu tương ừng trên từng thành phố 
Question:Thành phố nào đạt doanh thu cao nhất?*/

select a.city ,
sum(d.amount) as doanh_thu
from public.city as a
left join public.address as b on a.city_id=b.city_id
left join public.customer as c on b.address_id=c.address_id
left join public.payment as d on c.customer_id=d.customer_id
group by a.city 
order by sum(d.amount) desc

--bai8
/*Task: Tạo danh sách trả ra 2 cột dữ liệu: 
-cột 1: thông tin thành phố và đất nước ( format: “city, country")
-cột 2: doanh thu tương ứng với cột 1
Question: thành phố của đất nước nào đat doanh thu cao nhất*/

select 
concat(a.country,',',b.city) as thong_tin,
sum(e.amount) as doanh_thu
from public.country as a
left join public.city as b on a.country_id=b.country_id
left join public.address as c on b.city_id=c.city_id
left join public.customer as d on c.address_id=d.address_id
left join public.payment as e on d.customer_id=e.customer_id
group by concat(a.country,',',b.city)
order by sum(e.amount) asc



